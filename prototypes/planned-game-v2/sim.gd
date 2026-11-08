# PROTOTYPE - NOT FOR PRODUCTION
# Question: Does the planned MVP (deterministic command-driven simulation, viewer projection, art-bible look) play as intended?
# Date: 2026-11-08
extends RefCounted

# Plain-data simulation core. Contracts exercised (see design/gdd/systems-index.md C1-C7):
#  C1 fixed tick 10 Hz, integer mm, seeded RNG held in state, commands are the only input,
#     no Nodes, one writer per field (damage is accumulated and applied once at the end of the tick).
#  C2 commands validated against faction ownership.  C5 one fire resolver.  C6 tuning tables are data.
# Known shortcuts: brute-force target search (fine at <=100 units), no unit-unit collision, isqrt uses float sqrt.

const Region = preload("res://region.gd")

const TICK_MS := 100
const K_INF := 0
const K_ARM := 1
const NONE := -1

# ---- tuning (data, C6). index by kind ----
const KIND_NAME := ["INFANTRY", "ARMOR"]
const HP_MAX := [100, 400]
const SPEED := [800, 1200]            # mm per tick
const RANGE_MM := [220000, 320000]
const SIGHT_MM := [420000, 480000]
const COOLDOWN := [10, 20]
const DAMAGE := [[10, 25], [45, 60]]    # [shooter kind][target kind]
const ACC := [70, 75]                 # percent at point blank
const AMMO_MAX := [60, 24]
const COVER_DEF := [0, 15, 30, 45]    # percent hit-chance reduction by cover class
const MOVING_ACC := 60                # percent multiplier while moving
const STANDING_ACC := 80              # percent multiplier while a standing order is active (A2)
const CAPTURE_R := 150000
const CAPTURE_STEP := 5               # control points per 10 ticks per side present
const HOLD_TICKS := 600
const TICK_LIMIT := 12000
const WITHDRAW_FRAC := 40

# commands
const C_MOVE := 1
const C_FRONT := 2
const C_STOP := 3
const C_STANDING := 4
const C_HOLDFIRE := 5
const C_FREE := 6

# standing orders
const S_NONE := 0
const S_HOLD := 1
const S_WITHDRAW := 2
const S_ADVANCE := 3
const STANDING_NAME := ["", "HOLD", "WITHDRAW", "ADVANCE IF CLEAR"]

var region: RefCounted
var tick := 0
var rng := 1
var n := 0

# per-unit SoA
var alive := PackedByteArray()
var faction := PackedByteArray()
var kind := PackedByteArray()
var x := PackedInt64Array()
var y := PackedInt64Array()
var px := PackedInt64Array()
var py := PackedInt64Array()
var hp := PackedInt32Array()
var ammo := PackedInt32Array()
var cd := PackedInt32Array()
var heading := PackedInt32Array()     # degrees 0..359, 0 = east, 90 = south (screen space)
var face := PackedInt32Array()        # desired facing on arrival, -1 none
var target := PackedInt32Array()
var order := PackedByteArray()        # 0 idle, 1 moving
var standing := PackedByteArray()
var sx := PackedInt64Array()          # standing-order anchor / advance goal
var sy := PackedInt64Array()
var holdfire := PackedByteArray()
var stuck := PackedInt32Array()
var path_i := PackedInt32Array()
var dest_x := PackedInt64Array()
var dest_y := PackedInt64Array()
var fired_tick := PackedInt32Array()  # last tick the unit fired (for presentation)
var paths: Array = []                 # per unit PackedInt64Array
var dmg_acc := PackedInt32Array()

# objectives
var obj_control := PackedInt32Array([0, 0, 0])   # +100 = faction 0, -100 = faction 1
var obj_owner := PackedInt32Array([-1, -1, -1])
var hold_ticks := PackedInt32Array([0, 0])
var winner := -2                       # -2 running, -1 draw, 0/1 faction
var win_reason := ""

var cmd_queue: Array = []
var _path_cache: Array = []            # per-command scratch: lets a group share one A* result
var events: Array = []                 # cleared each step
var stats := {"shots": [0, 0], "hits": [0, 0], "kills": [0, 0], "rejected": 0}


func setup(seed_val: int, per_side_inf: int, per_side_arm: int, reg: RefCounted) -> void:
	region = reg
	rng = (seed_val & 0xFFFFFFFF) | 1
	tick = 0
	winner = -2
	win_reason = ""
	cmd_queue.clear()
	events.clear()
	obj_control = PackedInt32Array([0, 0, 0])
	obj_owner = PackedInt32Array([-1, -1, -1])
	hold_ticks = PackedInt32Array([0, 0])
	stats = {"shots": [0, 0], "hits": [0, 0], "kills": [0, 0], "rejected": 0}
	n = 0
	_alloc(2 * (per_side_inf + per_side_arm))
	for f in 2:
		var base: Vector2i = Region.BASE0 if f == 0 else Region.BASE1
		var k := 0
		for i in per_side_inf + per_side_arm:
			var kd := K_ARM if i >= per_side_inf else K_INF
			var col := k % 4
			var row := k / 4
			var ox := (col - 2) * 45000 + (80000 if f == 0 else -80000) + 22000
			var oy := (row - 3) * 45000 + 20000
			_spawn(f, kd, base.x + ox, base.y + oy)
			k += 1


func _alloc(total: int) -> void:
	for a in [alive, faction, kind, order, standing, holdfire]:
		a.resize(total)
	for a in [x, y, px, py, sx, sy, dest_x, dest_y]:
		a.resize(total)
	for a in [hp, ammo, cd, heading, face, target, stuck, path_i, fired_tick, dmg_acc]:
		a.resize(total)
	paths.clear()
	for i in total:
		paths.append(PackedInt64Array())


func _spawn(f: int, kd: int, sx_: int, sy_: int) -> int:
	var i := n
	n += 1
	alive[i] = 1
	faction[i] = f
	kind[i] = kd
	x[i] = sx_
	y[i] = sy_
	px[i] = sx_
	py[i] = sy_
	hp[i] = HP_MAX[kd]
	ammo[i] = AMMO_MAX[kd]
	cd[i] = 0
	heading[i] = 0 if f == 0 else 180
	face[i] = -1
	target[i] = NONE
	order[i] = 0
	standing[i] = S_NONE
	holdfire[i] = 0
	stuck[i] = 0
	path_i[i] = 0
	fired_tick[i] = -100
	dmg_acc[i] = 0
	sx[i] = sx_
	sy[i] = sy_
	dest_x[i] = sx_
	dest_y[i] = sy_
	return i


# ---------- RNG (state-held, C1) ----------
func _rnd() -> int:
	rng = (rng * 1664525 + 1013904223) & 0xFFFFFFFF
	return rng >> 8


func isqrt(v: int) -> int:
	if v <= 0:
		return 0
	var r := int(sqrt(float(v)))
	while r * r > v:
		r -= 1
	while (r + 1) * (r + 1) <= v:
		r += 1
	return r


func heading_to(dx: int, dy: int) -> int:
	# integer atan2 approximation in degrees (error under ~4 deg), 0 = east, 90 = south
	if dx == 0 and dy == 0:
		return 0
	var ax := absi(dx)
	var ay := absi(dy)
	var a := 0
	if ax >= ay:
		a = 45 * ay / ax
	else:
		a = 90 - 45 * ax / ay
	if dx < 0 and dy >= 0:
		a = 180 - a
	elif dx < 0 and dy < 0:
		a = 180 + a
	elif dx >= 0 and dy < 0:
		a = 360 - a
	return a % 360


func dist(i: int, j: int) -> int:
	return isqrt((x[i] - x[j]) * (x[i] - x[j]) + (y[i] - y[j]) * (y[i] - y[j]))


# ---------- commands (C2): the only input ----------
func issue(cmd: Dictionary) -> bool:
	var f: int = cmd.get("faction", -1)
	var ids: Array = cmd.get("units", [])
	var ok: Array = []
	for u in ids:
		if u >= 0 and u < n and alive[u] == 1 and faction[u] == f:
			ok.append(u)
	if ok.is_empty() or f < 0 or f > 1:
		stats.rejected += 1
		return false
	var c := cmd.duplicate()
	c["units"] = ok
	cmd_queue.append(c)
	return true


func _apply_commands() -> void:
	_path_cache.clear()
	for c in cmd_queue:
		var ids: Array = c.units
		match int(c.type):
			C_MOVE:
				var mv := ids.duplicate()
				mv.sort()
				var mc := mv.size()
				for k in mc:
					# small deterministic grid so a group does not pile onto one point
					var ox := 0
					var oy := 0
					if mc > 1:
						ox = ((k % 4) * 2 - 3) * 15000
						oy = ((k / 4) - (mc - 1) / 8) * 30000
					_order_move(mv[k], int(c.x) + ox, int(c.y) + oy, int(c.get("face", -1)))
			C_FRONT:
				var sorted := ids.duplicate()
				sorted.sort()
				var cnt := sorted.size()
				for k in cnt:
					var t := 500 if cnt == 1 else k * 1000 / (cnt - 1)
					var tx: int = int(c.x) + (int(c.x2) - int(c.x)) * t / 1000
					var ty: int = int(c.y) + (int(c.y2) - int(c.y)) * t / 1000
					_order_move(sorted[k], tx, ty, int(c.get("face", -1)))
			C_STOP:
				for u in ids:
					order[u] = 0
					paths[u] = PackedInt64Array()
					standing[u] = S_NONE
			C_STANDING:
				for u in ids:
					standing[u] = int(c.mode)
					sx[u] = int(c.get("x", x[u]))
					sy[u] = int(c.get("y", y[u]))
					if int(c.mode) == S_HOLD:
						sx[u] = x[u]
						sy[u] = y[u]
			C_HOLDFIRE:
				for u in ids:
					holdfire[u] = 1 if c.on else 0
			C_FREE:
				for u in ids:
					standing[u] = S_NONE
					holdfire[u] = 0
	cmd_queue.clear()


func _order_move(u: int, tx: int, ty: int, fc: int) -> void:
	tx = clampi(tx, 1000, Region.REGION - 1000)
	ty = clampi(ty, 1000, Region.REGION - 1000)
	var sd: Vector2i = region.snap_dest(tx, ty)
	tx = sd.x
	ty = sd.y
	paths[u] = _shared_path(u, tx, ty)
	path_i[u] = 0
	order[u] = 1
	stuck[u] = 0
	dest_x[u] = tx
	dest_y[u] = ty
	face[u] = fc


func _shared_path(u: int, tx: int, ty: int) -> PackedInt64Array:
	# one A* per group: units starting within 3 coarse cells of each other and ending within 2 share a path,
	# then each swaps in its own last point. Keeps a 12-unit order to a handful of searches.
	var scx: int = x[u] / Region.PCELL
	var scy: int = y[u] / Region.PCELL
	var gcx: int = tx / Region.PCELL
	var gcy: int = ty / Region.PCELL
	for e in _path_cache:
		if absi(e.scx - scx) <= 3 and absi(e.scy - scy) <= 3 and absi(e.gcx - gcx) <= 2 and absi(e.gcy - gcy) <= 2:
			var p: PackedInt64Array = e.path.duplicate()
			var last := p.size() - 2
			if last >= 0 and region.is_passable(tx, ty):
				p[last] = tx
				p[last + 1] = ty
			# drop leading waypoints that would send the unit backwards
			while p.size() > 4:
				var d0 := (p[0] - x[u]) * (p[0] - x[u]) + (p[1] - y[u]) * (p[1] - y[u])
				var d01 := (p[0] - p[2]) * (p[0] - p[2]) + (p[1] - p[3]) * (p[1] - p[3])
				var du1 := (x[u] - p[2]) * (x[u] - p[2]) + (y[u] - p[3]) * (y[u] - p[3])
				if du1 < d01 or d0 > du1:
					p = p.slice(2)
				else:
					break
			return p
	var np: PackedInt64Array = region.find_path(x[u], y[u], tx, ty)
	_path_cache.append({"scx": scx, "scy": scy, "gcx": gcx, "gcy": gcy, "path": np})
	return np.duplicate()


# ---------- main step ----------
func step() -> void:
	if winner != -2:
		return
	events.clear()
	_apply_commands()
	for i in n:
		px[i] = x[i]
		py[i] = y[i]
		dmg_acc[i] = 0
	if tick % 10 == 0:
		_update_objectives()
	for i in n:
		if alive[i] == 1:
			_unit_tick(i)
	_apply_damage()
	tick += 1
	_check_victory()


func _unit_tick(i: int) -> void:
	var f := faction[i]
	var kd := kind[i]
	if cd[i] > 0:
		cd[i] -= 1
	# resupply at own base or owned objective
	if tick % 3 == 0 and ammo[i] < AMMO_MAX[kd] and _near_supply(i):
		ammo[i] += 1
	# standing orders decide movement only when no explicit move order is active
	if order[i] == 0:
		_standing_logic(i)
	# targeting
	_acquire(i)
	# movement
	if order[i] != 0:
		_move(i)
	# facing
	if target[i] != NONE:
		heading[i] = heading_to(x[target[i]] - x[i], y[target[i]] - y[i])
	elif order[i] == 0 and face[i] >= 0:
		heading[i] = face[i]
	# fire
	_try_fire(i)


func _near_supply(i: int) -> bool:
	var f := faction[i]
	var base: Vector2i = Region.BASE0 if f == 0 else Region.BASE1
	var dx := x[i] - base.x
	var dy := y[i] - base.y
	if dx * dx + dy * dy <= CAPTURE_R * CAPTURE_R:
		return true
	for o in 3:
		if obj_owner[o] == f:
			var ox: int = Region.OBJ[o].x
			var oy: int = Region.OBJ[o].y
			if (x[i] - ox) * (x[i] - ox) + (y[i] - oy) * (y[i] - oy) <= CAPTURE_R * CAPTURE_R:
				return true
	return false


func _enemy_visible_near(i: int, rad: int) -> bool:
	var r2 := rad * rad
	for j in n:
		if alive[j] == 1 and faction[j] != faction[i]:
			var dx := x[j] - x[i]
			var dy := y[j] - y[i]
			if dx * dx + dy * dy <= r2 and region.los(x[i], y[i], x[j], y[j]):
				return true
	return false


func _standing_logic(i: int) -> void:
	var kd := kind[i]
	match int(standing[i]):
		S_WITHDRAW:
			if hp[i] * 100 < HP_MAX[kd] * WITHDRAW_FRAC or ammo[i] == 0:
				var base: Vector2i = Region.BASE0 if faction[i] == 0 else Region.BASE1
				_order_move(i, base.x, base.y, -1)
				standing[i] = S_HOLD
				sx[i] = base.x
				sy[i] = base.y
				events.append({"t": "withdraw", "id": i, "f": faction[i]})
		S_ADVANCE:
			if target[i] == NONE and not _enemy_visible_near(i, SIGHT_MM[kd]):
				if (x[i] - sx[i]) * (x[i] - sx[i]) + (y[i] - sy[i]) * (y[i] - sy[i]) > 20000 * 20000:
					_order_move(i, sx[i], sy[i], -1)
					# keep the standing order, the move order is the autonomous advance
					order[i] = 2


func _acquire(i: int) -> void:
	var kd := kind[i]
	var t := target[i]
	if t != NONE:
		if alive[t] == 0 or dist(i, t) > RANGE_MM[kd] or not region.los(x[i], y[i], x[t], y[t]):
			t = NONE
	if t == NONE and (tick + i) % 3 == 0:
		var best := 0x7fffffffffff
		for j in n:
			if alive[j] == 1 and faction[j] != faction[i]:
				var dx := x[j] - x[i]
				var dy := y[j] - y[i]
				var d2 := dx * dx + dy * dy
				if d2 <= RANGE_MM[kd] * RANGE_MM[kd] and d2 < best and region.los(x[i], y[i], x[j], y[j]):
					best = d2
					t = j
	target[i] = t


func _move(i: int) -> void:
	# order 2 = autonomous advance (stops when an enemy is acquired); order 1 = player move
	if order[i] == 2 and target[i] != NONE:
		order[i] = 0
		paths[i] = PackedInt64Array()
		return
	var p: PackedInt64Array = paths[i]
	var k := path_i[i]
	if k * 2 + 1 >= p.size():
		order[i] = 0
		return
	var wx := p[k * 2]
	var wy := p[k * 2 + 1]
	var dx := wx - x[i]
	var dy := wy - y[i]
	var d := isqrt(dx * dx + dy * dy)
	var sp: int = SPEED[kind[i]]
	var last := (k * 2 + 2) >= p.size()
	if d <= sp or (not last and d <= 12000):
		x[i] = wx
		y[i] = wy
		path_i[i] += 1
		if last:
			order[i] = 0
			if face[i] >= 0:
				heading[i] = face[i]
		return
	var vx := dx * sp / d
	var vy := dy * sp / d
	var cands := [
		[vx, vy], [(vx - vy) * 707 / 1000, (vx + vy) * 707 / 1000], [(vx + vy) * 707 / 1000, (vy - vx) * 707 / 1000],
		[-vy, vx], [vy, -vx]]
	var moved := false
	for ci in cands.size():
		var nx: int = x[i] + cands[ci][0]
		var ny: int = y[i] + cands[ci][1]
		if region.is_passable(nx, ny):
			x[i] = nx
			y[i] = ny
			stuck[i] = 0 if ci == 0 else stuck[i] + 1
			moved = true
			break
	if not moved:
		stuck[i] += 3
	if target[i] == NONE:
		heading[i] = heading_to(dx, dy)
	if stuck[i] > 12:
		paths[i] = region.find_path(x[i], y[i], dest_x[i], dest_y[i])
		path_i[i] = 0
		stuck[i] = 0
		if paths[i].size() <= 2 and d < 20000:
			order[i] = 0


func _try_fire(i: int) -> void:
	var t := target[i]
	if t == NONE or cd[i] > 0 or ammo[i] <= 0 or holdfire[i] == 1:
		return
	var kd := kind[i]
	if not region.los(x[i], y[i], x[t], y[t]):
		return
	var d := dist(i, t)
	if d > RANGE_MM[kd]:
		return
	var chance: int = ACC[kd] * (100 - 50 * d / RANGE_MM[kd]) / 100     # 100% .. 50% of base over range
	if order[i] != 0:
		chance = chance * MOVING_ACC / 100
	if standing[i] != S_NONE:
		chance = chance * STANDING_ACC / 100
	var cv: int = region.cover_at(x[t], y[t])
	chance = chance * (100 - COVER_DEF[cv]) / 100
	var hit := (_rnd() % 100) < chance
	ammo[i] -= 1
	cd[i] = COOLDOWN[kd]
	fired_tick[i] = tick
	stats.shots[faction[i]] += 1
	if hit:
		dmg_acc[t] += DAMAGE[kd][kind[t]]
		stats.hits[faction[i]] += 1
	events.append({"t": "shot", "a": i, "b": t, "hit": hit, "f": int(faction[i]), "x1": x[i], "y1": y[i], "x2": x[t], "y2": y[t]})


func _apply_damage() -> void:
	for i in n:
		if alive[i] == 1 and dmg_acc[i] > 0:
			hp[i] -= dmg_acc[i]
			if hp[i] <= 0:
				hp[i] = 0
				alive[i] = 0
				order[i] = 0
				target[i] = NONE
				# credit the kill to the faction opposite the victim
				stats.kills[1 - faction[i]] += 1
				events.append({"t": "death", "id": i, "f": int(faction[i]), "k": int(kind[i]), "x": x[i], "y": y[i]})


func _update_objectives() -> void:
	for o in 3:
		var ox: int = Region.OBJ[o].x
		var oy: int = Region.OBJ[o].y
		var c := [0, 0]
		for i in n:
			if alive[i] == 1:
				var dx := x[i] - ox
				var dy := y[i] - oy
				if dx * dx + dy * dy <= CAPTURE_R * CAPTURE_R:
					c[faction[i]] += 1
		if c[0] > 0 and c[1] == 0:
			obj_control[o] = mini(100, obj_control[o] + CAPTURE_STEP * mini(c[0], 3))
		elif c[1] > 0 and c[0] == 0:
			obj_control[o] = maxi(-100, obj_control[o] - CAPTURE_STEP * mini(c[1], 3))
		var old := obj_owner[o]
		if obj_control[o] >= 100:
			obj_owner[o] = 0
		elif obj_control[o] <= -100:
			obj_owner[o] = 1
		elif obj_owner[o] == 0 and obj_control[o] <= 0:
			obj_owner[o] = -1
		elif obj_owner[o] == 1 and obj_control[o] >= 0:
			obj_owner[o] = -1
		if obj_owner[o] != old:
			events.append({"t": "capture", "obj": o, "owner": int(obj_owner[o])})


func count_alive(f: int) -> int:
	var c := 0
	for i in n:
		if alive[i] == 1 and faction[i] == f:
			c += 1
	return c


func total_hp(f: int) -> int:
	var s := 0
	for i in n:
		if alive[i] == 1 and faction[i] == f:
			s += hp[i]
	return s


func held(f: int) -> int:
	var c := 0
	for o in 3:
		if obj_owner[o] == f:
			c += 1
	return c


func _check_victory() -> void:
	for f in 2:
		if held(f) >= 2:
			hold_ticks[f] += 1
		else:
			hold_ticks[f] = 0
	var a0 := count_alive(0)
	var a1 := count_alive(1)
	if a0 == 0 and a1 == 0:
		winner = -1
		win_reason = "MUTUAL ELIMINATION"
	elif a1 == 0:
		winner = 0
		win_reason = "ENEMY ELIMINATED"
	elif a0 == 0:
		winner = 1
		win_reason = "FORCE ELIMINATED"
	elif hold_ticks[0] >= HOLD_TICKS:
		winner = 0
		win_reason = "HELD 2 OF 3 OBJECTIVES"
	elif hold_ticks[1] >= HOLD_TICKS:
		winner = 1
		win_reason = "HELD 2 OF 3 OBJECTIVES"
	elif tick >= TICK_LIMIT:
		var h0 := held(0)
		var h1 := held(1)
		if h0 != h1:
			winner = 0 if h0 > h1 else 1
		else:
			var t0 := total_hp(0)
			var t1 := total_hp(1)
			winner = -1 if t0 == t1 else (0 if t0 > t1 else 1)
		win_reason = "TIME LIMIT"


# ---------- determinism, save / load ----------
func state_hash() -> int:
	var h := 1469598103
	h = _mix(h, tick)
	for i in n:
		h = _mix(h, alive[i])
		h = _mix(h, int(x[i]))
		h = _mix(h, int(y[i]))
		h = _mix(h, hp[i])
		h = _mix(h, ammo[i])
		h = _mix(h, heading[i])
		h = _mix(h, target[i] + 1)
	for o in 3:
		h = _mix(h, obj_control[o] + 200)
	return (h ^ rng) & 0xFFFFFFFF


func _mix(h: int, v: int) -> int:
	return ((h ^ (v & 0xFFFFFFFF)) * 16777619) & 0xFFFFFFFF


func snapshot() -> Dictionary:
	var pc: Array = []
	for p in paths:
		pc.append(p.duplicate())
	return {
		"tick": tick, "rng": rng, "n": n, "winner": winner, "win_reason": win_reason,
		"alive": alive.duplicate(), "faction": faction.duplicate(), "kind": kind.duplicate(),
		"x": x.duplicate(), "y": y.duplicate(), "px": px.duplicate(), "py": py.duplicate(),
		"hp": hp.duplicate(), "ammo": ammo.duplicate(), "cd": cd.duplicate(),
		"heading": heading.duplicate(), "face": face.duplicate(), "target": target.duplicate(),
		"order": order.duplicate(), "standing": standing.duplicate(), "sx": sx.duplicate(), "sy": sy.duplicate(),
		"holdfire": holdfire.duplicate(), "stuck": stuck.duplicate(), "path_i": path_i.duplicate(),
		"dest_x": dest_x.duplicate(), "dest_y": dest_y.duplicate(), "fired_tick": fired_tick.duplicate(),
		"paths": pc, "obj_control": obj_control.duplicate(), "obj_owner": obj_owner.duplicate(),
		"hold_ticks": hold_ticks.duplicate(), "cmd_queue": cmd_queue.duplicate(true), "stats": stats.duplicate(true),
	}


func restore(s: Dictionary) -> void:
	tick = s.tick
	rng = s.rng
	n = s.n
	winner = s.winner
	win_reason = s.win_reason
	alive = s.alive.duplicate()
	faction = s.faction.duplicate()
	kind = s.kind.duplicate()
	x = s.x.duplicate()
	y = s.y.duplicate()
	px = s.px.duplicate()
	py = s.py.duplicate()
	hp = s.hp.duplicate()
	ammo = s.ammo.duplicate()
	cd = s.cd.duplicate()
	heading = s.heading.duplicate()
	face = s.face.duplicate()
	target = s.target.duplicate()
	order = s.order.duplicate()
	standing = s.standing.duplicate()
	sx = s.sx.duplicate()
	sy = s.sy.duplicate()
	holdfire = s.holdfire.duplicate()
	stuck = s.stuck.duplicate()
	path_i = s.path_i.duplicate()
	dest_x = s.dest_x.duplicate()
	dest_y = s.dest_y.duplicate()
	fired_tick = s.fired_tick.duplicate()
	paths.clear()
	for p in s.paths:
		paths.append(p.duplicate())
	obj_control = s.obj_control.duplicate()
	obj_owner = s.obj_owner.duplicate()
	hold_ticks = s.hold_ticks.duplicate()
	cmd_queue = s.cmd_queue.duplicate(true)
	stats = s.stats.duplicate(true)
	dmg_acc.resize(n)
	dmg_acc.fill(0)
	events.clear()
