# PROTOTYPE - NOT FOR PRODUCTION
# Question: Do positioning, facing, range, line of sight and ammo make fights feel decided by the player's own choices?
# Date: 2026-11-07
extends Node2D

const ARENA_SIZE := Vector2(1280, 720)
const UNIT_RADIUS := 11.0
const MOVE_SPEED := 90.0
const TURN_RATE := 1.9            # radians per second (about 110 degrees)
const WEAPON_RANGE := 340.0
const FIRE_ARC := 0.70            # half-angle in radians (about 40 degrees)
const FIRE_INTERVAL := 0.5
const SHOT_DAMAGE := 14.0
const START_HP := 60.0
const START_AMMO := 24
const HIT_CHANCE_CLOSE := 0.80
const HIT_CHANCE_FAR := 0.25

const PLAYER := 0
const ENEMY := 1
const ADVANCE := 0
const ENGAGE := 1
const COVER := 2

const COL_BG := Color(0.07, 0.08, 0.10)
const COL_GRID := Color(0.11, 0.12, 0.15)
const COL_OBS := Color(0.16, 0.17, 0.21)
const COL_OBS_EDGE := Color(0.32, 0.34, 0.40)
const COL_PLAYER := Color(0.25, 0.80, 0.95)
const COL_ENEMY := Color(0.95, 0.50, 0.20)
const COL_TEXT := Color(0.70, 0.74, 0.80)


class Unit:
	var team := 0
	var pos := Vector2.ZERO
	var facing := 0.0
	var want_facing := 0.0
	var hp := 60.0
	var ammo := 24
	var cooldown := 0.0
	var dest := Vector2.ZERO
	var has_dest := false
	var wp := Vector2.ZERO
	var has_wp := false
	var arrive_facing := 0.0
	var has_arrive_facing := false
	var hold_fire := false
	var selected := false
	var alive := true
	var state := 0
	var hurt_timer := 0.0
	var cover_timer := 0.0
	var cover_cooldown := 0.0


var obstacles: Array[Rect2] = []
var waypoints: Array[Vector2] = []
var units: Array[Unit] = []
var tracers: Array = []
var corpses: Array[Vector2] = []
var shots_fired := 0
var shots_hit := 0
var over := false
var result := ""
var dragging := false
var drag_start := Vector2.ZERO
var rmb_start := Vector2.ZERO
var rmb_down := false
var selftest := false


func _ready() -> void:
	selftest = "--selftest" in OS.get_cmdline_user_args()
	reset_game()
	if selftest:
		_run_selftests()
		get_tree().quit()


func reset_game() -> void:
	obstacles.clear()
	for r in [
		Rect2(600, 80, 36, 230),
		Rect2(600, 410, 36, 230),
		Rect2(330, 200, 90, 36),
		Rect2(330, 480, 90, 36),
		Rect2(860, 160, 90, 36),
		Rect2(860, 520, 90, 36),
		Rect2(960, 330, 36, 60),
	]:
		obstacles.append(r)
	waypoints.clear()
	for r in obstacles:
		var g := r.grow(UNIT_RADIUS + 6.0)
		waypoints.append(g.position)
		waypoints.append(Vector2(g.end.x, g.position.y))
		waypoints.append(g.end)
		waypoints.append(Vector2(g.position.x, g.end.y))
	units.clear()
	tracers.clear()
	corpses.clear()
	shots_fired = 0
	shots_hit = 0
	over = false
	result = ""
	for i in 4:
		units.append(_make_unit(PLAYER, Vector2(120, 270 + i * 60), 0.0))
		units.append(_make_unit(ENEMY, Vector2(1160, 270 + i * 60), PI))
	queue_redraw()


func _make_unit(team: int, pos: Vector2, facing: float) -> Unit:
	var u := Unit.new()
	u.team = team
	u.pos = pos
	u.facing = facing
	u.want_facing = facing
	u.hp = START_HP
	u.ammo = START_AMMO
	return u


func _process(delta: float) -> void:
	if not over:
		_step(minf(delta, 0.05))
	queue_redraw()


# ---------------------------------------------------------------- simulation

func _step(delta: float) -> void:
	for u in units:
		if not u.alive:
			continue
		u.cooldown -= delta
		u.hurt_timer = maxf(0.0, u.hurt_timer - delta)
		u.cover_cooldown = maxf(0.0, u.cover_cooldown - delta)
		if u.team == ENEMY:
			_ai(u, delta)
		_move(u, delta)
		_turn(u, delta)
		_try_fire(u)
	for t in tracers:
		t["t"] -= delta
	tracers = tracers.filter(func(t): return t["t"] > 0.0)
	var player_alive := _count_alive(PLAYER)
	var enemy_alive := _count_alive(ENEMY)
	if enemy_alive == 0:
		over = true
		result = "VICTORY"
	elif player_alive == 0:
		over = true
		result = "DEFEAT"
	elif _total_ammo() == 0:
		over = true
		result = "OUT OF AMMO"


func _count_alive(team: int) -> int:
	var n := 0
	for u in units:
		if u.alive and u.team == team:
			n += 1
	return n


func _total_ammo() -> int:
	var n := 0
	for u in units:
		if u.alive:
			n += u.ammo
	return n


func _nearest_enemy(u: Unit) -> Unit:
	var best: Unit = null
	var best_d := INF
	for e in units:
		if e.alive and e.team != u.team:
			var d := u.pos.distance_to(e.pos)
			if d < best_d:
				best_d = d
				best = e
	return best


func _ai(u: Unit, delta: float) -> void:
	var nearest := _nearest_enemy(u)
	if nearest == null:
		return
	var d := u.pos.distance_to(nearest.pos)
	var seen := not _sight_blocked(u.pos, nearest.pos)
	if u.hurt_timer > 0.0 and u.state != COVER and u.cover_cooldown <= 0.0:
		var spot := _find_cover(u, nearest.pos)
		if spot != Vector2.INF:
			u.state = COVER
			u.dest = spot
			u.has_dest = true
			u.has_wp = false
			u.cover_timer = 3.0
			u.cover_cooldown = 6.0
	match u.state:
		ADVANCE:
			if seen and d < WEAPON_RANGE * 0.85:
				u.state = ENGAGE
				u.has_dest = false
			else:
				u.dest = nearest.pos
				u.has_dest = true
		ENGAGE:
			if not seen or d > WEAPON_RANGE:
				u.state = ADVANCE
			else:
				u.want_facing = (nearest.pos - u.pos).angle()
		COVER:
			u.cover_timer -= delta
			if not u.has_dest:
				u.want_facing = (nearest.pos - u.pos).angle()
			if u.cover_timer <= 0.0:
				u.state = ADVANCE


func _find_cover(u: Unit, threat: Vector2) -> Vector2:
	var best := Vector2.INF
	var best_d := 260.0
	for r in obstacles:
		var away := (r.get_center() - threat).normalized()
		var spot := r.get_center()
		for i in 80:
			if not r.grow(18.0).has_point(spot):
				break
			spot += away * 8.0
		if not Rect2(Vector2.ZERO, ARENA_SIZE).has_point(spot):
			continue
		if not _sight_blocked(spot, threat):
			continue
		var d := u.pos.distance_to(spot)
		if d < best_d:
			best_d = d
			best = spot
	return best


func _move(u: Unit, delta: float) -> void:
	if not u.has_dest:
		return
	if u.pos.distance_to(u.dest) < 5.0:
		u.has_dest = false
		if u.has_arrive_facing:
			u.want_facing = u.arrive_facing
		return
	if u.has_wp and u.pos.distance_to(u.wp) < 4.0:
		u.has_wp = false
	if not u.has_wp:
		var s := _steer(u.pos, u.dest)
		if s != u.dest:
			u.wp = s
			u.has_wp = true
	var target := u.wp if u.has_wp else u.dest
	var to := target - u.pos
	if to.length() < 0.5:
		return
	u.want_facing = to.angle()
	u.pos = _push_out(u.pos + to.normalized() * minf(MOVE_SPEED * delta, to.length()))


func _turn(u: Unit, delta: float) -> void:
	var diff := angle_difference(u.facing, u.want_facing)
	u.facing += clampf(diff, -TURN_RATE * delta, TURN_RATE * delta)


func _try_fire(u: Unit) -> void:
	if u.cooldown > 0.0 or u.ammo <= 0 or u.hold_fire:
		return
	var best: Unit = null
	var best_d := INF
	for e in units:
		if not e.alive or e.team == u.team:
			continue
		var d := u.pos.distance_to(e.pos)
		if d > WEAPON_RANGE or d >= best_d:
			continue
		if absf(angle_difference(u.facing, (e.pos - u.pos).angle())) > FIRE_ARC:
			continue
		if _sight_blocked(u.pos, e.pos):
			continue
		best_d = d
		best = e
	if best == null:
		return
	u.ammo -= 1
	u.cooldown = FIRE_INTERVAL
	shots_fired += 1
	var chance := lerpf(HIT_CHANCE_CLOSE, HIT_CHANCE_FAR, best_d / WEAPON_RANGE)
	var hit := randf() < chance
	if hit:
		shots_hit += 1
		best.hp -= SHOT_DAMAGE
		best.hurt_timer = 2.0
		if best.hp <= 0.0:
			best.alive = false
			best.selected = false
			corpses.append(best.pos)
	tracers.append({"a": u.pos, "b": best.pos, "t": 0.18, "hit": hit, "team": u.team})


# ------------------------------------------------------------------ geometry

func _seg_rect(a: Vector2, b: Vector2, r: Rect2) -> bool:
	var d := b - a
	var t0 := 0.0
	var t1 := 1.0
	for axis in 2:
		var origin: float = a[axis]
		var dir: float = d[axis]
		var lo: float = r.position[axis]
		var hi: float = r.end[axis]
		if absf(dir) < 0.00001:
			if origin < lo or origin > hi:
				return false
		else:
			var ta := (lo - origin) / dir
			var tb := (hi - origin) / dir
			if ta > tb:
				var tmp := ta
				ta = tb
				tb = tmp
			t0 = maxf(t0, ta)
			t1 = minf(t1, tb)
			if t0 > t1:
				return false
	return true


func _sight_blocked(a: Vector2, b: Vector2) -> bool:
	for r in obstacles:
		if _seg_rect(a, b, r):
			return true
	return false


func _move_blocked(a: Vector2, b: Vector2) -> bool:
	for r in obstacles:
		if _seg_rect(a, b, r.grow(UNIT_RADIUS)):
			return true
	return false


func _steer(from: Vector2, to: Vector2) -> Vector2:
	if not _move_blocked(from, to):
		return to
	var best := to
	var best_cost := INF
	for cand in waypoints:
		if cand.distance_to(from) < 8.0 or _move_blocked(from, cand):
			continue
		var cost := from.distance_to(cand) + cand.distance_to(to)
		if cost < best_cost:
			best_cost = cost
			best = cand
	return best


func _push_out(p: Vector2) -> Vector2:
	for r in obstacles:
		var closest := Vector2(clampf(p.x, r.position.x, r.end.x), clampf(p.y, r.position.y, r.end.y))
		var offset := p - closest
		var dist := offset.length()
		if dist < UNIT_RADIUS:
			if dist > 0.001:
				p += offset.normalized() * (UNIT_RADIUS - dist)
			else:
				p.x = r.position.x - UNIT_RADIUS
	return Vector2(clampf(p.x, UNIT_RADIUS, ARENA_SIZE.x - UNIT_RADIUS), clampf(p.y, UNIT_RADIUS, ARENA_SIZE.y - UNIT_RADIUS))


# --------------------------------------------------------------------- input

func _unhandled_input(event: InputEvent) -> void:
	var key := event as InputEventKey
	if key != null:
		if key.pressed and not key.echo:
			match key.keycode:
				KEY_R:
					reset_game()
				KEY_A:
					for u in units:
						u.selected = u.alive and u.team == PLAYER
				KEY_H:
					for u in units:
						if u.selected:
							u.hold_fire = not u.hold_fire
		return
	var mb := event as InputEventMouseButton
	if mb == null:
		return
	if mb.button_index == MOUSE_BUTTON_LEFT:
		if mb.pressed:
			dragging = true
			drag_start = mb.position
		else:
			dragging = false
			_finish_select(mb.position, mb.shift_pressed)
	elif mb.button_index == MOUSE_BUTTON_RIGHT:
		if mb.pressed:
			rmb_down = true
			rmb_start = mb.position
		else:
			rmb_down = false
			_issue_move(rmb_start, mb.position)


func _finish_select(pos: Vector2, additive: bool) -> void:
	if not additive:
		for u in units:
			u.selected = false
	if drag_start.distance_to(pos) < 6.0:
		var best: Unit = null
		var best_d := 22.0
		for u in units:
			if u.alive and u.team == PLAYER and u.pos.distance_to(pos) < best_d:
				best_d = u.pos.distance_to(pos)
				best = u
		if best != null:
			best.selected = true
	else:
		var box := Rect2(drag_start, pos - drag_start).abs()
		for u in units:
			if u.alive and u.team == PLAYER and box.has_point(u.pos):
				u.selected = true


func _issue_move(start: Vector2, end: Vector2) -> void:
	var chosen: Array[Unit] = []
	for u in units:
		if u.alive and u.selected and u.team == PLAYER:
			chosen.append(u)
	if chosen.is_empty():
		return
	if start.distance_to(end) > 18.0:
		# Total War style: the dragged line is the frontage; units spread along it
		# and face perpendicular (drag left to right = face up the screen).
		var along := (end - start).normalized()
		chosen.sort_custom(func(a: Unit, b: Unit) -> bool: return a.pos.dot(along) < b.pos.dot(along))
		var slots := _line_slots(start, end, chosen.size())
		var face := (end - start).angle() - PI / 2.0
		for i in chosen.size():
			var u := chosen[i]
			u.dest = _push_out(slots[i])
			u.has_dest = true
			u.has_wp = false
			u.has_arrive_facing = true
			u.arrive_facing = face
	else:
		# Plain click: move to the point as a short line, keep walking direction.
		var centroid := Vector2.ZERO
		for u in chosen:
			centroid += u.pos
		centroid /= chosen.size()
		var across := Vector2.from_angle((start - centroid).angle() + PI / 2.0)
		for i in chosen.size():
			var u := chosen[i]
			var offset := (i - (chosen.size() - 1) / 2.0) * 30.0
			u.dest = _push_out(start + across * offset)
			u.has_dest = true
			u.has_wp = false
			u.has_arrive_facing = false


func _line_slots(start: Vector2, end: Vector2, n: int) -> Array[Vector2]:
	var slots: Array[Vector2] = []
	var length := start.distance_to(end)
	var dir := (end - start) / maxf(length, 0.001)
	var spacing := 0.0
	if n > 1:
		spacing = maxf(length / (n - 1), 24.0)
	var origin := (start + end) / 2.0 - dir * spacing * (n - 1) / 2.0
	for i in n:
		slots.append(origin + dir * spacing * i)
	return slots


# ------------------------------------------------------------------ drawing

func _draw() -> void:
	draw_rect(Rect2(Vector2.ZERO, ARENA_SIZE), COL_BG)
	for x in range(0, 1281, 80):
		draw_line(Vector2(x, 0), Vector2(x, 720), COL_GRID, 1.0)
	for y in range(0, 721, 80):
		draw_line(Vector2(0, y), Vector2(1280, y), COL_GRID, 1.0)
	for r in obstacles:
		draw_rect(r, COL_OBS)
		draw_rect(r, COL_OBS_EDGE, false, 2.0)
	for c in corpses:
		draw_line(c + Vector2(-6, -6), c + Vector2(6, 6), COL_OBS_EDGE, 2.0)
		draw_line(c + Vector2(-6, 6), c + Vector2(6, -6), COL_OBS_EDGE, 2.0)
	for u in units:
		if not u.alive:
			continue
		var col := COL_PLAYER if u.team == PLAYER else COL_ENEMY
		if u.team == PLAYER and u.has_dest:
			var dim := Color(col.r, col.g, col.b, 0.45)
			draw_dashed_line(u.pos, u.dest, dim, 1.5, 6.0)
			if u.has_arrive_facing:
				draw_line(u.dest, u.dest + Vector2.from_angle(u.arrive_facing) * 16.0, dim, 2.0)
		_draw_wedge(u, col)
	for u in units:
		if u.alive:
			_draw_unit(u)
	for t in tracers:
		var a: float = clampf(t["t"] / 0.18, 0.0, 1.0)
		var tc := COL_PLAYER if t["team"] == PLAYER else COL_ENEMY
		draw_line(t["a"], t["b"], Color(tc.r, tc.g, tc.b, a), 2.0 if t["hit"] else 1.0)
		if t["hit"]:
			draw_circle(t["b"], 4.0, Color(1, 1, 1, a))
	if dragging:
		var box := Rect2(drag_start, get_local_mouse_position() - drag_start).abs()
		draw_rect(box, Color(1, 1, 1, 0.10))
		draw_rect(box, Color(1, 1, 1, 0.5), false, 1.0)
	if rmb_down:
		var mouse := get_local_mouse_position()
		var n := 0
		for u in units:
			if u.alive and u.selected and u.team == PLAYER:
				n += 1
		if n > 0 and rmb_start.distance_to(mouse) > 18.0:
			var ghost := Color(COL_PLAYER.r, COL_PLAYER.g, COL_PLAYER.b, 0.7)
			var face := (mouse - rmb_start).angle() - PI / 2.0
			draw_line(rmb_start, mouse, Color(ghost.r, ghost.g, ghost.b, 0.35), 2.0)
			for p in _line_slots(rmb_start, mouse, n):
				draw_circle(p, 6.0, ghost)
				draw_line(p, p + Vector2.from_angle(face) * 22.0, ghost, 3.0)
	_draw_hud()


func _draw_wedge(u: Unit, col: Color) -> void:
	var alpha := 0.16 if u.selected else 0.05
	var pts := PackedVector2Array([u.pos])
	for i in 13:
		var a := u.facing - FIRE_ARC + (2.0 * FIRE_ARC) * float(i) / 12.0
		pts.append(u.pos + Vector2.from_angle(a) * WEAPON_RANGE)
	draw_colored_polygon(pts, Color(col.r, col.g, col.b, alpha))


func _draw_unit(u: Unit) -> void:
	var col := COL_PLAYER if u.team == PLAYER else COL_ENEMY
	var s := 12.0
	var body := PackedVector2Array([
		u.pos + Vector2(0, -s), u.pos + Vector2(s, 0),
		u.pos + Vector2(0, s), u.pos + Vector2(-s, 0)])
	draw_colored_polygon(body, Color(col.r, col.g, col.b, 0.35))
	body.append(body[0])
	draw_polyline(body, Color(1, 1, 1) if u.selected else col, 2.0)
	draw_line(u.pos, u.pos + Vector2.from_angle(u.facing) * 20.0, col, 3.0)
	var frac := clampf(u.hp / START_HP, 0.0, 1.0)
	draw_rect(Rect2(u.pos + Vector2(-13, -22), Vector2(26, 3)), Color(0, 0, 0, 0.6))
	draw_rect(Rect2(u.pos + Vector2(-13, -22), Vector2(26.0 * frac, 3)), col)
	draw_string(ThemeDB.fallback_font, u.pos + Vector2(-8, 30), str(u.ammo), HORIZONTAL_ALIGNMENT_LEFT, -1, 13, COL_TEXT)
	if u.hold_fire:
		draw_rect(Rect2(u.pos + Vector2(10, -20), Vector2(6, 6)), Color(1, 1, 1))


func _draw_hud() -> void:
	var font := ThemeDB.fallback_font
	var lines := [
		"LMB select (drag = box)   RMB move   RMB drag = draw a line: units spread along it and face perpendicular (left to right = face up)   H hold fire   A select all   R restart",
		"Your units: %d   Enemy: %d   Shots fired: %d   Hits: %d   Ammo per unit shown under each symbol" % [_count_alive(PLAYER), _count_alive(ENEMY), shots_fired, shots_hit],
	]
	for i in lines.size():
		draw_string(font, Vector2(14, 22 + i * 18), lines[i], HORIZONTAL_ALIGNMENT_LEFT, -1, 14, COL_TEXT)
	if over:
		draw_rect(Rect2(Vector2.ZERO, ARENA_SIZE), Color(0, 0, 0, 0.45))
		draw_string(font, Vector2(0, 350), result, HORIZONTAL_ALIGNMENT_CENTER, ARENA_SIZE.x, 56, Color(1, 1, 1))
		draw_string(font, Vector2(0, 392), "Press R to restart", HORIZONTAL_ALIGNMENT_CENTER, ARENA_SIZE.x, 18, COL_TEXT)


# ----------------------------------------------------------------- selftests

func _run_selftests() -> void:
	reset_game()
	_simulate(6000, "passive")
	reset_game()
	for u in units:
		if u.team == PLAYER:
			u.dest = Vector2(540, u.pos.y)
			u.has_dest = true
			u.has_arrive_facing = true
			u.arrive_facing = 0.0
	_simulate(6000, "advance")
	# Line drag: top to bottom at x=500 should put 4 units on that line, facing east (angle 0).
	reset_game()
	for u in units:
		u.selected = u.team == PLAYER
	_issue_move(Vector2(500, 200), Vector2(500, 520))
	for i in 600:
		_step(1.0 / 30.0)
	for u in units:
		if u.team == PLAYER:
			print("  LINETEST pos=(%d,%d) facing=%.2f (expect x~500, facing~0)" % [u.pos.x, u.pos.y, u.facing])
	reset_game()
	for u in units:
		u.selected = u.team == PLAYER
	_issue_move(Vector2(300, 360), Vector2(305, 362))
	for i in 300:
		_step(1.0 / 30.0)
	print("  CLICKTEST first unit pos=(%d,%d)" % [units[0].pos.x, units[0].pos.y])


func _simulate(max_ticks: int, label: String) -> void:
	var ticks := 0
	while not over and ticks < max_ticks:
		_step(1.0 / 30.0)
		ticks += 1
	var bad := 0
	for u in units:
		if is_nan(u.pos.x) or is_nan(u.pos.y) or is_nan(u.facing):
			bad += 1
	print("SELFTEST %s ticks=%d result=%s player_alive=%d enemy_alive=%d fired=%d hits=%d nan_units=%d" % [
		label, ticks, result if over else "TIMEOUT", _count_alive(PLAYER), _count_alive(ENEMY), shots_fired, shots_hit, bad])
	if not over:
		for u in units:
			if u.alive:
				print("  unit team=%d pos=(%d,%d) state=%d ammo=%d hp=%d dest=%s has_dest=%s facing=%.2f" % [u.team, u.pos.x, u.pos.y, u.state, u.ammo, u.hp, u.dest, u.has_dest, u.facing])
