# PROTOTYPE - NOT FOR PRODUCTION
# Question: Can a plain-data, fixed-point, fixed-tick simulation core written in GDScript run hundreds of units headless fast enough and deterministically?
# Date: 2026-11-08
extends RefCounted

# Units: positions are integer millimetres. Headings are 0..255 (256 = a full turn).
# No Node, no engine service, no wall clock, no float in state. Only commands change state from outside.

const HZ := 10
const ARENA := 4096000          # mm, 4,096 m square
const CELL := 64000             # obstacle grid cell, 64 m
const GRID := 64
const HASH_CELL := 512000       # spatial hash cell, 512 m
const HASH_N := 8
const RANGE := 300000           # weapon range, mm
const RANGE2 := RANGE * RANGE
const STEP := 500               # mm per tick (5 m/s at 10 Hz)
const ARC := 28                 # firing arc half-angle in headings (about 40 degrees)
const TURN := 8                 # max turn per tick in headings
const START_HP := 60
const START_AMMO := 24
const DAMAGE := 14
const FIRE_INTERVAL := 5
const RESPAWN_TICKS := 100
const BASE0 := 1700000
const BASE1 := 2396000

var n := 0
var tick := 0
var rng := 1
var px := PackedInt64Array()
var py := PackedInt64Array()
var heading := PackedInt32Array()
var hp := PackedInt32Array()
var ammo := PackedInt32Array()
var team := PackedInt32Array()
var cd := PackedInt32Array()
var respawn := PackedInt32Array()
var alive := PackedByteArray()
var dest_x := PackedInt64Array()
var dest_y := PackedInt64Array()
var has_dest := PackedByteArray()
var obstacles := PackedByteArray()
var hash_head := PackedInt32Array()
var hash_next := PackedInt32Array()
var dx_tab := PackedInt32Array()
var dy_tab := PackedInt32Array()
var atan_tab := PackedInt32Array()
var cmd_tick := PackedInt32Array()
var cmd_unit := PackedInt32Array()
var cmd_x := PackedInt64Array()
var cmd_y := PackedInt64Array()
var cmd_cursor := 0
var shots := 0
var hits := 0
var kills := 0

# profiling (host-side only; never read by the simulation)
var prof := false
var t_hash := 0
var t_units := 0


func setup(seed_value: int, n_units: int) -> void:
	n = n_units
	tick = 0
	cmd_cursor = 0
	shots = 0
	hits = 0
	kills = 0
	rng = seed_value & 0xFFFFFFFF
	if rng == 0:
		rng = 1
	_build_tables()
	px.resize(n); py.resize(n); heading.resize(n); hp.resize(n); ammo.resize(n)
	team.resize(n); cd.resize(n); respawn.resize(n); alive.resize(n)
	dest_x.resize(n); dest_y.resize(n); has_dest.resize(n)
	hash_head.resize(HASH_N * HASH_N)
	hash_next.resize(n)
	_build_obstacles()
	for i in n:
		team[i] = i % 2
		_respawn(i)


func _build_tables() -> void:
	dx_tab.resize(256)
	dy_tab.resize(256)
	for h in 256:
		var a := float(h) * TAU / 256.0
		dx_tab[h] = int(round(cos(a) * 1024.0))
		dy_tab[h] = int(round(sin(a) * 1024.0))
	atan_tab.resize(256)
	for i in 256:
		atan_tab[i] = int(round(atan(float(i) / 255.0) * 128.0 / PI))


func _build_obstacles() -> void:
	obstacles.resize(GRID * GRID)
	obstacles.fill(0)
	for k in 70:
		var cx := _rand(GRID - 3)
		var cy := _rand(GRID)
		var w := 1 + _rand(3)
		var h := 1 + _rand(3)
		for yy in range(cy, mini(cy + h, GRID)):
			for xx in range(cx, mini(cx + w, GRID)):
				obstacles[yy * GRID + xx] = 1
	# keep the two base areas clear so units can always spawn and resupply
	for base_x in [BASE0, BASE1]:
		var bc: int = base_x / CELL
		for yy in GRID:
			for xx in range(maxi(bc - 3, 0), mini(bc + 4, GRID)):
				obstacles[yy * GRID + xx] = 0


func load_commands(total_ticks: int, seed_value: int, per_batch: int) -> void:
	# a command log generated up front, independent of the simulation's RNG stream
	cmd_tick.resize(0); cmd_unit.resize(0); cmd_x.resize(0); cmd_y.resize(0)
	var r := seed_value & 0xFFFFFFFF
	for t in range(0, total_ticks, 300):
		for k in per_batch:
			r = (r * 1664525 + 1013904223) & 0xFFFFFFFF
			var u := (r >> 8) % n
			r = (r * 1664525 + 1013904223) & 0xFFFFFFFF
			var x := 400000 + (r >> 8) % (ARENA - 800000)
			r = (r * 1664525 + 1013904223) & 0xFFFFFFFF
			var y := 400000 + (r >> 8) % (ARENA - 800000)
			cmd_tick.append(t); cmd_unit.append(u); cmd_x.append(x); cmd_y.append(y)


func _rand(limit: int) -> int:
	rng = (rng * 1664525 + 1013904223) & 0xFFFFFFFF
	return (rng >> 8) % limit


func _respawn(i: int) -> void:
	var bx := BASE0 if team[i] == 0 else BASE1
	px[i] = bx + _rand(200000) - 100000
	py[i] = 200000 + _rand(ARENA - 400000)
	heading[i] = 0 if team[i] == 0 else 128
	hp[i] = START_HP
	ammo[i] = START_AMMO
	cd[i] = 0
	respawn[i] = 0
	alive[i] = 1
	has_dest[i] = 0
	dest_x[i] = 0
	dest_y[i] = 0


func step() -> void:
	_apply_commands()
	var t0 := 0
	if prof:
		t0 = Time.get_ticks_usec()
	_rebuild_hash()
	if prof:
		var t1 := Time.get_ticks_usec()
		t_hash += t1 - t0
		t0 = t1
	for i in n:
		if alive[i] == 1:
			_update_unit(i)
		else:
			respawn[i] -= 1
			if respawn[i] <= 0:
				_respawn(i)
	if prof:
		t_units += Time.get_ticks_usec() - t0
	tick += 1


func _apply_commands() -> void:
	while cmd_cursor < cmd_tick.size() and cmd_tick[cmd_cursor] <= tick:
		var u := cmd_unit[cmd_cursor]
		if u < n and alive[u] == 1:
			dest_x[u] = cmd_x[cmd_cursor]
			dest_y[u] = cmd_y[cmd_cursor]
			has_dest[u] = 1
		cmd_cursor += 1


func _rebuild_hash() -> void:
	hash_head.fill(-1)
	for i in n:
		if alive[i] == 1:
			var c := clampi(py[i] / HASH_CELL, 0, HASH_N - 1) * HASH_N + clampi(px[i] / HASH_CELL, 0, HASH_N - 1)
			hash_next[i] = hash_head[c]
			hash_head[c] = i


func _nearest_enemy(i: int) -> int:
	var cx := clampi(px[i] / HASH_CELL, 0, HASH_N - 1)
	var cy := clampi(py[i] / HASH_CELL, 0, HASH_N - 1)
	var best := -1
	var best_d := RANGE2 + 1
	for oy in range(maxi(cy - 1, 0), mini(cy + 2, HASH_N)):
		for ox in range(maxi(cx - 1, 0), mini(cx + 2, HASH_N)):
			var j := hash_head[oy * HASH_N + ox]
			while j != -1:
				if alive[j] == 1 and team[j] != team[i]:
					var ddx := px[j] - px[i]
					var ddy := py[j] - py[i]
					var d2 := ddx * ddx + ddy * ddy
					if d2 < best_d:
						best_d = d2
						best = j
				j = hash_next[j]
	return best


func _blocked(x: int, y: int) -> bool:
	var cx := clampi(x / CELL, 0, GRID - 1)
	var cy := clampi(y / CELL, 0, GRID - 1)
	return obstacles[cy * GRID + cx] == 1


func _los(ax: int, ay: int, bx: int, by: int) -> bool:
	var x0 := clampi(ax / CELL, 0, GRID - 1)
	var y0 := clampi(ay / CELL, 0, GRID - 1)
	var x1 := clampi(bx / CELL, 0, GRID - 1)
	var y1 := clampi(by / CELL, 0, GRID - 1)
	var dx := absi(x1 - x0)
	var dy := -absi(y1 - y0)
	var sx := 1 if x0 < x1 else -1
	var sy := 1 if y0 < y1 else -1
	var err := dx + dy
	while not (x0 == x1 and y0 == y1):
		var e2 := 2 * err
		if e2 >= dy:
			err += dy
			x0 += sx
		if e2 <= dx:
			err += dx
			y0 += sy
		if not (x0 == x1 and y0 == y1) and obstacles[y0 * GRID + x0] == 1:
			return false
	return true


func _heading_to(dx: int, dy: int) -> int:
	var ax := absi(dx)
	var ay := absi(dy)
	if ax == 0 and ay == 0:
		return 0
	var a := 0
	if ay <= ax:
		a = atan_tab[(ay * 255) / ax]
	else:
		a = 64 - atan_tab[(ax * 255) / ay]
	if dx >= 0 and dy >= 0:
		return a
	if dx < 0 and dy >= 0:
		return 128 - a
	if dx < 0 and dy < 0:
		return 128 + a
	return (256 - a) & 255


func _turn(i: int, want: int) -> void:
	var diff := ((want - heading[i] + 128) & 255) - 128
	if diff > TURN:
		diff = TURN
	elif diff < -TURN:
		diff = -TURN
	heading[i] = (heading[i] + diff) & 255


func _move(i: int, wx: int, wy: int) -> void:
	_turn(i, _heading_to(wx - px[i], wy - py[i]))
	var nx := clampi(px[i] + STEP * dx_tab[heading[i]] / 1024, 1000, ARENA - 1000)
	var ny := clampi(py[i] + STEP * dy_tab[heading[i]] / 1024, 1000, ARENA - 1000)
	if not _blocked(nx, ny):
		px[i] = nx
		py[i] = ny
	elif not _blocked(nx, py[i]):
		px[i] = nx
	elif not _blocked(px[i], ny):
		py[i] = ny


func _fire(i: int, t: int) -> void:
	ammo[i] -= 1
	cd[i] = FIRE_INTERVAL
	shots += 1
	var ddx := px[t] - px[i]
	var ddy := py[t] - py[i]
	var pct := 80 - (55 * (ddx * ddx + ddy * ddy)) / RANGE2
	if _rand(100) < pct:
		hits += 1
		hp[t] -= DAMAGE
		if hp[t] <= 0:
			alive[t] = 0
			respawn[t] = RESPAWN_TICKS
			kills += 1


func _update_unit(i: int) -> void:
	if cd[i] > 0:
		cd[i] -= 1
	var bx := BASE0 if team[i] == 0 else BASE1
	if absi(px[i] - bx) < 300000 and ammo[i] < START_AMMO:
		ammo[i] = START_AMMO
	if ammo[i] == 0:
		_move(i, bx, py[i])
		return
	var tgt := _nearest_enemy(i)
	if tgt != -1 and _los(px[i], py[i], px[tgt], py[tgt]):
		var want := _heading_to(px[tgt] - px[i], py[tgt] - py[i])
		_turn(i, want)
		var diff := absi(((want - heading[i] + 128) & 255) - 128)
		if diff <= ARC and cd[i] == 0:
			_fire(i, tgt)
		return
	if has_dest[i] == 1:
		_move(i, dest_x[i], dest_y[i])
		var rx := dest_x[i] - px[i]
		var ry := dest_y[i] - py[i]
		if rx * rx + ry * ry < 1000000:
			has_dest[i] = 0
	else:
		_move(i, BASE1 if team[i] == 0 else BASE0, py[i])


# ---- determinism and persistence ----

func _mix(h: int, v: int) -> int:
	return ((h ^ (v & 0xFFFFFFFF)) * 16777619) & 0xFFFFFFFF


func state_hash() -> int:
	var h := 2166136261
	h = _mix(h, tick)
	h = _mix(h, rng)
	h = _mix(h, cmd_cursor)
	for i in n:
		h = _mix(h, px[i]); h = _mix(h, py[i]); h = _mix(h, heading[i]); h = _mix(h, hp[i])
		h = _mix(h, ammo[i]); h = _mix(h, alive[i]); h = _mix(h, cd[i]); h = _mix(h, respawn[i])
		h = _mix(h, has_dest[i]); h = _mix(h, dest_x[i]); h = _mix(h, dest_y[i])
	for c in obstacles.size():
		h = _mix(h, obstacles[c])
	h = _mix(h, shots); h = _mix(h, hits); h = _mix(h, kills)
	return h


func snapshot() -> Dictionary:
	return {
		"version": 1, "n": n, "tick": tick, "rng": rng, "cmd_cursor": cmd_cursor,
		"shots": shots, "hits": hits, "kills": kills,
		"px": px.duplicate(), "py": py.duplicate(), "heading": heading.duplicate(),
		"hp": hp.duplicate(), "ammo": ammo.duplicate(), "team": team.duplicate(),
		"cd": cd.duplicate(), "respawn": respawn.duplicate(), "alive": alive.duplicate(),
		"dest_x": dest_x.duplicate(), "dest_y": dest_y.duplicate(), "has_dest": has_dest.duplicate(),
		"obstacles": obstacles.duplicate(),
	}


func restore(s: Dictionary) -> void:
	n = s["n"]; tick = s["tick"]; rng = s["rng"]; cmd_cursor = s["cmd_cursor"]
	shots = s["shots"]; hits = s["hits"]; kills = s["kills"]
	px = s["px"].duplicate(); py = s["py"].duplicate(); heading = s["heading"].duplicate()
	hp = s["hp"].duplicate(); ammo = s["ammo"].duplicate(); team = s["team"].duplicate()
	cd = s["cd"].duplicate(); respawn = s["respawn"].duplicate(); alive = s["alive"].duplicate()
	dest_x = s["dest_x"].duplicate(); dest_y = s["dest_y"].duplicate(); has_dest = s["has_dest"].duplicate()
	obstacles = s["obstacles"].duplicate()
	hash_head.resize(HASH_N * HASH_N)
	hash_next.resize(n)
	_build_tables()
