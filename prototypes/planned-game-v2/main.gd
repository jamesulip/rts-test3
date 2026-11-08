# PROTOTYPE - NOT FOR PRODUCTION
# Question: Does the planned MVP (deterministic command-driven simulation, viewer projection, art-bible look) play as intended?
# Date: 2026-11-08
extends Node2D

# Presentation + input for the planned-game prototype. Unit and enemy data is read through the viewer projection (vproj.gd)
# and the world is changed ONLY through sim.issue(). Shortcut: tracers/death rings read sim.events, the HUD reads objective
# and hold counters, and the end screen reads sim.stats (a deliberate post-game reveal). Look follows design/art/art-bible.md ("Living Radar").
# NOTE: the author could not see this output (headless only); the look is UNVERIFIED by a human eye until the user runs it.

const Region = preload("res://region.gd")
const Sim = preload("res://sim.gd")
const VProj = preload("res://vproj.gd")
const AI = preload("res://ai.gd")

const SEA := Color("0B1620")
const LAND := Color("2B2F2E")
const AZURE := Color("2E9BE0")
const AMBER := Color("FFC247")
const WHITE := Color("F5F8FA")
const GREY := Color("5E6D72")
const PAPER := Color("E6D9B8")
const INK := Color("101A22")
const MIST := Color("9AA8AC")
const AZURE_S := Color("247FB9")
const AMBER_S := Color("D29F39")

const PLAYER := 0
const ZOOMS := [0.16, 0.4, 0.9, 1.8]
const TACTICAL_ZOOM := 0.9
const MAX_STEPS_PER_FRAME := 8
const MINI := 180.0

enum Phase { BRIEF, PLAY, END }

var region := Region.new()
var sim := Sim.new()
var vp := VProj.new()
var ai0 := AI.new(0)
var ai1 := AI.new(1)
var auto := false
var smoke := false
var shot_path := ""
var frame := 0
var opt_ff := 0
var opt_zoom := -1
var opt_cam := Vector2(-1, -1)
var opt_select := false
var opt_brief := false

var phase := Phase.BRIEF
var seed_val := 77
var terrain_tex: ImageTexture
var cam := Vector2(1100, 2048)
var zoom_i := 1
var zoom := 0.4
var accum := 0.0
var alpha := 0.0
var speed := 1
var paused := false
var view: Dictionary = {}
var prev_visible_ids: Array = []
var callsign_n := PackedInt32Array()

var selected: Array = []
var lmb := false
var lmb_start := Vector2.ZERO
var rmb := false
var rmb_start_s := Vector2.ZERO
var rmb_start_w := Vector2.ZERO
var mouse := Vector2.ZERO
var pan_drag := false

var tracers: Array = []
var projectiles: Array = []
var flashes: Array = []
var impacts: Array = []
var scroll_acc := 0.0
var mini_drag := false
var rings: Array = []
var feed: Array = []
var plog: Array = []


func _ready() -> void:
	for a in OS.get_cmdline_user_args():
		if a == "--smoke":
			smoke = true
		elif a == "--auto":
			auto = true
		elif a.begins_with("--shot="):
			shot_path = a.substr(7)
		elif a.begins_with("--seed="):
			seed_val = int(a.substr(7))
		elif a.begins_with("--ff="):
			opt_ff = int(a.substr(5))
		elif a.begins_with("--zoom="):
			opt_zoom = int(a.substr(7))
		elif a.begins_with("--cam="):
			var p := a.substr(6).split(",")
			opt_cam = Vector2(float(p[0]), float(p[1]))
		elif a == "--select":
			opt_select = true
		elif a == "--brief":
			opt_brief = true
	_new_game(seed_val)
	if smoke or shot_path != "":
		phase = Phase.BRIEF if opt_brief else Phase.PLAY
		speed = 4 if smoke else 1
	if shot_path != "":
		auto = true
		phase = Phase.PLAY
		for t in opt_ff:
			if phase == Phase.PLAY:
				_do_tick()
				_advance_projectiles(0.03 / float(speed))
		if opt_brief:
			phase = Phase.BRIEF
		if opt_zoom >= 0:
			zoom_i = opt_zoom
			zoom = ZOOMS[zoom_i]
		if opt_cam.x >= 0.0:
			cam = opt_cam
		if opt_select:
			vp.observe(sim)
			for u in vp.view(sim, PLAYER).own:
				selected.append(u.id)


func _new_game(sd: int) -> void:
	seed_val = sd
	region.build(sd)
	sim.setup(sd, 8, 4, region)
	vp.reset()
	ai0 = AI.new(0)
	ai1 = AI.new(1)
	selected.clear()
	tracers.clear()
	projectiles.clear()
	flashes.clear()
	impacts.clear()
	rings.clear()
	feed.clear()
	plog.clear()
	prev_visible_ids = []
	accum = 0.0
	callsign_n.resize(sim.n)
	var counters := [0, 0]
	for i in sim.n:
		counters[sim.faction[i]] += 1
		callsign_n[i] = counters[sim.faction[i]]
	_build_terrain_texture()
	vp.observe(sim)
	view = vp.view(sim, PLAYER)
	cam = Vector2(780, 2048)
	zoom_i = 2
	zoom = ZOOMS[zoom_i]
	_log("session seed=%d units=%d per side, engine=%s" % [sd, sim.count_alive(0), Engine.get_version_info().string])


func _build_terrain_texture() -> void:
	var img := Image.create(Region.GRID, Region.GRID, false, Image.FORMAT_RGBA8)
	for yy in Region.GRID:
		for xx in Region.GRID:
			var i := yy * Region.GRID + xx
			var water := region.height[i] < Region.WATER_CM and region.road[i] == 0
			var c := SEA
			if not water:
				var k := clampf(float(region.height[i]) / 8000.0, 0.0, 1.0)
				c = LAND.lightened(0.10 * k)
				match int(region.cover[i]):
					1:
						c = c.lerp(GREY, 0.30)
					2:
						c = GREY.darkened(0.15)
					3:
						c = MIST.darkened(0.25)
				if region.road[i] == 1:
					c = c.lerp(MIST, 0.22)
			img.set_pixel(xx, yy, c)
	terrain_tex = ImageTexture.create_from_image(img)


# ---------------- coordinates ----------------
func vsize() -> Vector2:
	return get_viewport_rect().size


func w2s(m: Vector2) -> Vector2:
	return (m - cam) * zoom + vsize() * 0.5


func s2w(s: Vector2) -> Vector2:
	return (s - vsize() * 0.5) / zoom + cam


func tactical() -> bool:
	return zoom >= TACTICAL_ZOOM


func fcol(f: int) -> Color:
	return AZURE if f == 0 else AMBER


func fname(f: int) -> String:
	return "AZURE FORCE" if f == 0 else "AMBER FORCE"


func callsign(id: int) -> String:
	return "%s-%02d" % ["A" if sim.faction[id] == 0 else "B", callsign_n[id]]


func _log(s: String) -> void:
	plog.append("[tick %d] %s" % [sim.tick, s])


# ---------------- loop ----------------
func _process(delta: float) -> void:
	frame += 1
	mouse = get_viewport().get_mouse_position()
	if phase == Phase.PLAY:
		if not paused:
			accum += delta * 1000.0 * speed
			var steps := 0
			while accum >= Sim.TICK_MS and steps < MAX_STEPS_PER_FRAME and phase == Phase.PLAY:
				_do_tick()
				accum -= Sim.TICK_MS
				steps += 1
			if steps == MAX_STEPS_PER_FRAME:
				accum = 0.0
		alpha = clampf(accum / float(Sim.TICK_MS), 0.0, 1.0) if not paused else 1.0
		if not paused:
			_advance_projectiles(delta)
		_pan_keys(delta)
	else:
		alpha = 1.0
	view = vp.view(sim, PLAYER)
	selected = selected.filter(func(id: int) -> bool: return sim.alive[id] == 1)
	_expire_fx()
	if smoke:
		_smoke_script()
	if shot_path != "" and frame == 12:
		_save_shot()
	queue_redraw()


func _do_tick() -> void:
	vp.observe(sim)
	if auto:
		ai0.think(sim, vp)
	ai1.think(sim, vp)
	sim.step()
	var now := Time.get_ticks_msec()
	for e in sim.events:
		match String(e.t):
			"shot":
				# visual only: the sim resolved this shot at fire time; the projectile just travels to where it landed
				var p1 := Vector2(e.x1, e.y1) / 1000.0
				var p2 := Vector2(e.x2, e.y2) / 1000.0
				var sk: int = sim.kind[e.a]
				if not e.hit:
					var dd := p2 - p1
					var dn := dd.normalized()
					var off := float((sim.tick * 7 + int(e.a) * 13) % 9 - 4) * 5.0
					p2 = p2 + dn * 40.0 + Vector2(-dn.y, dn.x) * off
				var spd := 380.0 if sk == Sim.K_INF else 480.0
				if projectiles.size() < 400:
					projectiles.append({"p1": p1, "p2": p2, "f": e.f, "hit": e.hit, "k": sk, "t": 0.0, "dur": maxf(0.05, p1.distance_to(p2) / spd)})
				flashes.append({"p": p1, "f": e.f, "t": 0.0, "k": sk})
			"death":
				rings.append({"x": e.x / 1000.0, "y": e.y / 1000.0, "f": e.f, "start": now, "until": now + 900})
				if e.f == PLAYER:
					feed.append("T%s  LOST %s %s" % [_clock(), Sim.KIND_NAME[e.k], callsign(e.id)])
				elif prev_visible_ids.has(e.id):
					feed.append("T%s  ENEMY %s DESTROYED" % [_clock(), Sim.KIND_NAME[e.k]])
				_log("death %s %s" % [fname(e.f), callsign(e.id)])
			"capture":
				var who := "NEUTRAL" if e.owner < 0 else fname(e.owner)
				feed.append("T%s  %s  ->  %s" % [_clock(), Region.OBJ_NAMES[e.obj], who])
				_log("capture %s -> %s" % [Region.OBJ_NAMES[e.obj], who])
			"withdraw":
				if e.f == PLAYER:
					feed.append("T%s  %s WITHDRAWING" % [_clock(), callsign(e.id)])
	if feed.size() > 7:
		feed = feed.slice(feed.size() - 7)
	prev_visible_ids = vp.visible[PLAYER].duplicate()
	if sim.winner != -2:
		phase = Phase.END
		_log("END winner=%d reason=%s alive=%d v %d held=%d v %d shots=%s hits=%s" % [sim.winner, sim.win_reason, sim.count_alive(0), sim.count_alive(1), sim.held(0), sim.held(1), str(sim.stats.shots), str(sim.stats.hits)])
		_write_log()


func _clock() -> String:
	var s := sim.tick / 10
	return "+%02d:%02d" % [s / 60, s % 60]


func _advance_projectiles(delta: float) -> void:
	var now := Time.get_ticks_msec()
	var keep: Array = []
	for p in projectiles:
		p.t += delta * float(speed)
		if p.t >= p.dur:
			if p.hit:
				impacts.append({"p": p.p2, "f": p.f, "until": now + 280, "k": p.k})
		else:
			keep.append(p)
	projectiles = keep
	var fk: Array = []
	for f in flashes:
		f.t += delta * float(speed)
		if f.t < 0.12:
			fk.append(f)
	flashes = fk


func _expire_fx() -> void:
	var now := Time.get_ticks_msec()
	impacts = impacts.filter(func(t: Dictionary) -> bool: return t.until > now)
	tracers = tracers.filter(func(t: Dictionary) -> bool: return t.until > now)
	rings = rings.filter(func(r: Dictionary) -> bool: return r.until > now)


func _write_log() -> void:
	var f := FileAccess.open("user://playtest-v2.log", FileAccess.WRITE)
	if f:
		for l in plog:
			f.store_line(l)


func _notification(what: int) -> void:
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		_log("window closed at phase %d" % phase)
		_write_log()


func _pan_keys(delta: float) -> void:
	var d := Vector2.ZERO
	if Input.is_key_pressed(KEY_LEFT):
		d.x -= 1
	if Input.is_key_pressed(KEY_RIGHT):
		d.x += 1
	if Input.is_key_pressed(KEY_UP):
		d.y -= 1
	if Input.is_key_pressed(KEY_DOWN):
		d.y += 1
	if d != Vector2.ZERO:
		cam += d.normalized() * 700.0 / zoom * delta
		_clamp_cam()


func _clamp_cam() -> void:
	cam.x = clampf(cam.x, 0.0, 4096.0)
	cam.y = clampf(cam.y, 0.0, 4096.0)


# ---------------- input ----------------
func _unhandled_input(event: InputEvent) -> void:
	_handle_event(event)


func _handle_event(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and not event.echo:
		_key(event as InputEventKey)
		return
	if phase != Phase.PLAY:
		return
	if event is InputEventMagnifyGesture:
		var mg := event as InputEventMagnifyGesture
		mouse = mg.position
		scroll_acc += (mg.factor - 1.0) * 6.0
		while scroll_acc >= 1.0:
			_zoom_step(1)
			scroll_acc -= 1.0
		while scroll_acc <= -1.0:
			_zoom_step(-1)
			scroll_acc += 1.0
		return
	if event is InputEventPanGesture:
		var pg := event as InputEventPanGesture
		mouse = pg.position
		scroll_acc += pg.delta.y
		while scroll_acc <= -1.0:
			_zoom_step(1)
			scroll_acc += 1.0
		while scroll_acc >= 1.0:
			_zoom_step(-1)
			scroll_acc -= 1.0
		return
	if event is InputEventMouseMotion:
		var m := event as InputEventMouseMotion
		mouse = m.position
		if mini_drag:
			_minimap_to_cam(m.position)
			return
		if pan_drag:
			cam -= m.relative / zoom
			_clamp_cam()
		return
	if event is InputEventMouseButton:
		var b := event as InputEventMouseButton
		mouse = b.position
		match b.button_index:
			MOUSE_BUTTON_WHEEL_UP:
				if b.pressed:
					_zoom_step(1)
			MOUSE_BUTTON_WHEEL_DOWN:
				if b.pressed:
					_zoom_step(-1)
			MOUSE_BUTTON_MIDDLE:
				pan_drag = b.pressed
			MOUSE_BUTTON_LEFT:
				if not b.pressed and mini_drag:
					mini_drag = false
				elif b.pressed and _minimap_rect().has_point(b.position):
					mini_drag = true
					_minimap_to_cam(b.position)
				elif b.pressed and _hud_action(b.position) != "":
					_do_action(_hud_action(b.position))
				elif b.pressed:
					lmb = true
					lmb_start = b.position
				elif lmb:
					lmb = false
					_finish_select(b.position, b.shift_pressed)
			MOUSE_BUTTON_RIGHT:
				if b.pressed:
					rmb = true
					rmb_start_s = b.position
					rmb_start_w = s2w(b.position)
				elif rmb:
					rmb = false
					_finish_order(b.position)


func _minimap_rect() -> Rect2:
	var vs := vsize()
	return Rect2(vs.x - MINI - 8, vs.y - MINI - 8, MINI, MINI)


func _minimap_to_cam(pos: Vector2) -> void:
	var r := _minimap_rect()
	var k := (MINI - 4.0) / 4096.0
	cam = (pos - r.position - Vector2(2, 2)) / k
	_clamp_cam()


func _buttons() -> Array:
	return [
		{"id": "zout", "r": Rect2(58, 41, 24, 20), "t": "-"},
		{"id": "zin", "r": Rect2(86, 41, 24, 20), "t": "+"},
		{"id": "zmap", "r": Rect2(114, 41, 40, 20), "t": "MAP"},
		{"id": "pause", "r": Rect2(222, 41, 58, 20), "t": "PAUSE"},
		{"id": "s1", "r": Rect2(284, 41, 28, 20), "t": "1x"},
		{"id": "s2", "r": Rect2(316, 41, 28, 20), "t": "2x"},
		{"id": "s4", "r": Rect2(348, 41, 28, 20), "t": "4x"},
	]


func _hud_action(pos: Vector2) -> String:
	for b in _buttons():
		if b.r.has_point(pos):
			return b.id
	return ""


func _do_action(id: String) -> void:
	match id:
		"zin":
			_zoom_center(1)
		"zout":
			_zoom_center(-1)
		"zmap":
			zoom_i = 0
			zoom = ZOOMS[0]
			cam = Vector2(2048, 2048)
		"pause":
			paused = not paused
			_log("pause=%s" % str(paused))
		"s1":
			speed = 1
		"s2":
			speed = 2
		"s4":
			speed = 4


func _zoom_center(dir: int) -> void:
	var keep := mouse
	mouse = vsize() * 0.5
	_zoom_step(dir)
	mouse = keep


func _zoom_step(dir: int) -> void:
	var before := s2w(mouse)
	zoom_i = clampi(zoom_i + dir, 0, ZOOMS.size() - 1)
	zoom = ZOOMS[zoom_i]
	cam += before - s2w(mouse)
	_clamp_cam()


func _key(k: InputEventKey) -> void:
	if phase == Phase.BRIEF:
		if k.keycode == KEY_ENTER or k.keycode == KEY_KP_ENTER or k.keycode == KEY_SPACE:
			phase = Phase.PLAY
			_log("briefing dismissed")
		return
	if phase == Phase.END:
		if k.keycode == KEY_ENTER or k.keycode == KEY_KP_ENTER:
			_new_game(seed_val + 1)
			phase = Phase.PLAY
		return
	match k.keycode:
		KEY_SPACE:
			paused = not paused
			_log("pause=%s" % str(paused))
		KEY_1:
			speed = 1
		KEY_2:
			speed = 2
		KEY_3:
			speed = 4
		KEY_EQUAL, KEY_PLUS, KEY_KP_ADD:
			_zoom_center(1)
		KEY_MINUS, KEY_KP_SUBTRACT:
			_zoom_center(-1)
		KEY_ESCAPE:
			selected.clear()
		KEY_HOME:
			zoom_i = 0
			zoom = ZOOMS[0]
			cam = Vector2(2048, 2048)
		KEY_S:
			_cmd({"type": Sim.C_STOP}, "stop")
		KEY_H:
			_cmd({"type": Sim.C_STANDING, "mode": Sim.S_HOLD}, "standing HOLD")
		KEY_W:
			_cmd({"type": Sim.C_STANDING, "mode": Sim.S_WITHDRAW}, "standing WITHDRAW")
		KEY_A:
			if k.ctrl_pressed or k.meta_pressed:
				selected = []
				for u in view.own:
					selected.append(u.id)
			else:
				var w := s2w(mouse)
				_cmd({"type": Sim.C_STANDING, "mode": Sim.S_ADVANCE, "x": int(w.x * 1000), "y": int(w.y * 1000)}, "standing ADVANCE IF CLEAR")
		KEY_F:
			_cmd({"type": Sim.C_FREE}, "free (clear standing)")
		KEY_C:
			var on := false
			for id in selected:
				if sim.holdfire[id] == 0:
					on = true
			_cmd({"type": Sim.C_HOLDFIRE, "on": on}, "hold fire " + str(on))
		KEY_T:
			selected = []
			for u in view.own:
				if u.kind == Sim.K_ARM:
					selected.append(u.id)
		KEY_I:
			selected = []
			for u in view.own:
				if u.kind == Sim.K_INF:
					selected.append(u.id)


func _cmd(c: Dictionary, label: String) -> void:
	if selected.is_empty() or auto:
		return
	c["faction"] = PLAYER
	c["units"] = selected.duplicate()
	if sim.issue(c):
		_log("player cmd %s (%d units)" % [label, selected.size()])


func _unit_screen(u: Dictionary) -> Vector2:
	var m := Vector2(lerpf(u.px, u.x, alpha), lerpf(u.py, u.y, alpha)) / 1000.0
	return w2s(m)


func _finish_select(pos: Vector2, add: bool) -> void:
	var picked: Array = []
	if lmb_start.distance_to(pos) < 6.0:
		var best := 1e9
		var bid := -1
		for u in view.own:
			var d: float = _unit_screen(u).distance_to(pos)
			var r: float = _plate_size(u.kind).x * 0.8
			if d < r and d < best:
				best = d
				bid = u.id
		if bid >= 0:
			picked.append(bid)
	else:
		var rect := Rect2(lmb_start, pos - lmb_start).abs()
		for u in view.own:
			if rect.has_point(_unit_screen(u)):
				picked.append(u.id)
	if add:
		for id in picked:
			if not selected.has(id):
				selected.append(id)
	else:
		selected = picked


func _finish_order(pos: Vector2) -> void:
	if selected.is_empty() or auto:
		return
	var w := s2w(pos)
	var from := rmb_start_w
	var face_dir := 0
	if rmb_start_s.distance_to(pos) < 10.0:
		var cx := 0.0
		var cy := 0.0
		for u in view.own:
			if selected.has(u.id):
				cx += u.x
				cy += u.y
		var cnt := float(selected.size())
		face_dir = sim.heading_to(int(w.x * 1000.0 - cx / cnt), int(w.y * 1000.0 - cy / cnt))
		_cmd({"type": Sim.C_MOVE, "x": int(w.x * 1000), "y": int(w.y * 1000), "face": face_dir}, "move")
	else:
		var d := w - from
		var perp := Vector2(d.y, -d.x)
		if perp.x < 0.0:
			perp = -perp
		face_dir = sim.heading_to(int(perp.x * 1000.0), int(perp.y * 1000.0))
		_cmd({"type": Sim.C_FRONT, "x": int(from.x * 1000), "y": int(from.y * 1000), "x2": int(w.x * 1000), "y2": int(w.y * 1000), "face": face_dir}, "frontage line")


# ---------------- drawing helpers ----------------
func _plate_size(kind: int) -> Vector2:
	if tactical():
		return Vector2(28, 28) if kind == Sim.K_INF else Vector2(48, 32)
	return Vector2(16, 16)


func _plate_poly(f: int, sz: Vector2, k: float) -> PackedVector2Array:
	var hw := sz.x * 0.5 * k
	var hh := sz.y * 0.5 * k
	if f == 0:
		# Shield plate: flat top, pointed bottom
		return PackedVector2Array([Vector2(-hw, -hh), Vector2(hw, -hh), Vector2(hw, hh * 0.15), Vector2(0, hh), Vector2(-hw, hh * 0.15)])
	# Swallowtail plate: flat top, forked bottom
	return PackedVector2Array([Vector2(-hw, -hh), Vector2(hw, -hh), Vector2(hw, hh), Vector2(0, hh * 0.2), Vector2(-hw, hh)])


func _offset(p: PackedVector2Array, c: Vector2) -> PackedVector2Array:
	var out := PackedVector2Array()
	for v in p:
		out.append(v + c)
	return out


func _dashed_poly(p: PackedVector2Array, col: Color, w: float) -> void:
	for i in p.size():
		var a := p[i]
		var b := p[(i + 1) % p.size()]
		var seg_len := a.distance_to(b)
		var dirv := (b - a) / maxf(seg_len, 0.001)
		var t := 0.0
		while t < seg_len:
			var e := minf(t + 3.0, seg_len)
			draw_line(a + dirv * t, a + dirv * e, col, w)
			t += 6.0


func _draw_plate(c: Vector2, kind: int, f: int, filled: bool, standing: bool, a: float) -> void:
	var sz := _plate_size(kind)
	var fc := fcol(f)
	if filled:
		draw_colored_polygon(_offset(_plate_poly(f, sz, 1.16), c), Color(INK, a))
		var body := fc
		if standing:
			body = AZURE_S if f == 0 else AMBER_S
		draw_colored_polygon(_offset(_plate_poly(f, sz, 1.0), c), Color(body, a))
		if standing:
			_dashed_poly(_offset(_plate_poly(f, sz, 0.66), c), Color(WHITE, 0.85 * a), 1.5)
	else:
		var outer := _offset(_plate_poly(f, sz, 1.0), c)
		outer.append(outer[0])
		draw_polyline(outer, Color(INK, a), 4.0)
		draw_polyline(outer, Color(fc, a), 2.0)
	var gcol := Color(INK, a) if filled else Color(fc, a)
	if kind == Sim.K_INF:
		draw_circle(c + Vector2(0, -sz.y * 0.05), sz.x * 0.14, gcol)
	else:
		draw_rect(Rect2(c + Vector2(-sz.x * 0.26, -sz.y * 0.16), Vector2(sz.x * 0.52, sz.y * 0.26)), gcol)
		draw_rect(Rect2(c + Vector2(-sz.x * 0.04, -sz.y * 0.36), Vector2(sz.x * 0.08, sz.y * 0.24)), gcol)


func _text(pos: Vector2, s: String, size: int, col: Color) -> void:
	draw_string(ThemeDB.fallback_font, pos, s, HORIZONTAL_ALIGNMENT_LEFT, -1, size, col)


func _panel(r: Rect2) -> void:
	draw_rect(r, INK)
	draw_rect(r, GREY, false, 1.0)


func _tag(pos: Vector2, s: String) -> void:
	var w := float(s.length()) * 7.0 + 8.0
	draw_rect(Rect2(pos, Vector2(w, 16)), INK)
	_text(pos + Vector2(4, 12), s, 12, PAPER)


func _brackets(c: Vector2, sz: Vector2) -> void:
	var hw := sz.x * 0.5 + 6.0
	var hh := sz.y * 0.5 + 6.0
	var l := 7.0
	for sx in [-1.0, 1.0]:
		for sy in [-1.0, 1.0]:
			var corner := c + Vector2(hw * sx, hh * sy)
			draw_line(corner, corner + Vector2(-l * sx, 0), WHITE, 2.0)
			draw_line(corner, corner + Vector2(0, -l * sy), WHITE, 2.0)


# ---------------- drawing ----------------
func _draw() -> void:
	var vs := vsize()
	draw_rect(Rect2(Vector2.ZERO, vs), SEA)
	draw_texture_rect(terrain_tex, Rect2(w2s(Vector2.ZERO), Vector2(4096, 4096) * zoom), false)
	_draw_territory()
	_draw_objectives()
	_draw_selected_overlays()
	_draw_stale_and_markers()
	_draw_enemies()
	_draw_own()
	_draw_fx()
	_draw_drag()
	_draw_hud()
	if phase == Phase.BRIEF:
		_draw_brief()
	elif phase == Phase.END:
		_draw_end()


func _draw_territory() -> void:
	for o in 3:
		var ow: int = sim.obj_owner[o]
		if ow >= 0:
			var c := w2s(Vector2(Region.OBJ[o].x, Region.OBJ[o].y) / 1000.0)
			draw_circle(c, 650.0 * zoom, Color(fcol(ow), 0.10))
	for f in 2:
		var b: Vector2i = Region.BASE0 if f == 0 else Region.BASE1
		draw_circle(w2s(Vector2(b.x, b.y) / 1000.0), 500.0 * zoom, Color(fcol(f), 0.10))


func _draw_objectives() -> void:
	for f in 2:
		var b: Vector2i = Region.BASE0 if f == 0 else Region.BASE1
		var c := w2s(Vector2(b.x, b.y) / 1000.0)
		draw_rect(Rect2(c - Vector2(8, 8), Vector2(16, 16)), fcol(f), false, 2.0)
		_text(c + Vector2(-26, -16), "BASE" if f == PLAYER else "ENEMY BASE", 12, MIST)
	for o in 3:
		var c := w2s(Vector2(Region.OBJ[o].x, Region.OBJ[o].y) / 1000.0)
		var ow: int = sim.obj_owner[o]
		var col := GREY if ow < 0 else fcol(ow)
		draw_arc(c, Sim.CAPTURE_R / 1000.0 * zoom, 0.0, TAU, 48, col, 2.0)
		draw_rect(Rect2(c - Vector2(5, 5), Vector2(10, 10)), col)
		var ctrl: int = sim.obj_control[o]
		var txt := "%s  %s" % [Region.OBJ_NAMES[o], "NEUTRAL" if ctrl == 0 else ("%s %d%%" % ["AZURE" if ctrl > 0 else "AMBER", absi(ctrl)])]
		_tag(c + Vector2(-float(txt.length()) * 3.5, -Sim.CAPTURE_R / 1000.0 * zoom - 22), txt)


func _draw_selected_overlays() -> void:
	for u in view.own:
		if not selected.has(u.id):
			continue
		var c := _unit_screen(u)
		if selected.size() <= 2:
			draw_arc(c, Sim.SIGHT_MM[u.kind] / 1000.0 * zoom, 0.0, TAU, 64, Color(GREY, 0.45), 1.0)
			draw_arc(c, Sim.RANGE_MM[u.kind] / 1000.0 * zoom, 0.0, TAU, 64, Color(WHITE, 0.25), 1.0)
		if u.order != 0:
			var d := w2s(Vector2(u.dest_x, u.dest_y) / 1000.0)
			draw_line(c, d, Color(WHITE, 0.18), 1.0)
			draw_line(d + Vector2(-4, -4), d + Vector2(4, 4), Color(WHITE, 0.7), 1.5)
			draw_line(d + Vector2(-4, 4), d + Vector2(4, -4), Color(WHITE, 0.7), 1.5)
		if u.standing == Sim.S_ADVANCE:
			var g := w2s(Vector2(u.sx, u.sy) / 1000.0)
			draw_line(c, g, Color(AZURE_S, 0.5), 1.0)


func _draw_stale_and_markers() -> void:
	for m in view.markers:
		var c := w2s(Vector2(m.cx, m.cy) / 1000.0)
		var r: float = 28.0 + 10.0 * m.bucket
		draw_arc(c, r, 0.0, TAU, 32, Color(AMBER_S, 0.7), 2.0)
		for k in m.bucket:
			draw_line(c + Vector2(-8 + 8 * k, 4), c + Vector2(-8 + 8 * k, -4), Color(AMBER_S, 0.9), 2.0)
		_text(c + Vector2(-20, r + 14), "FORCE ~" + ["", "1-2", "3-5", "6+"][m.bucket], 11, Color(AMBER_S, 0.9))
	for s in view.stale:
		var c := w2s(Vector2(s.x, s.y) / 1000.0)
		_draw_plate(c, s.kind, 1, false, false, 0.8)
		_text(c + Vector2(10, 4), "T-%ds" % (s.age / 10), 11, Color(AMBER_S, 0.9))


func _draw_enemies() -> void:
	for e in view.enemies:
		var m := Vector2(lerpf(e.px, e.x, alpha), lerpf(e.py, e.y, alpha)) / 1000.0
		var c := w2s(m)
		_draw_plate(c, e.kind, 1, true, false, 1.0)
		var h := Vector2.from_angle(deg_to_rad(float(e.heading)))
		var sz := _plate_size(e.kind)
		draw_line(c + h * (sz.x * 0.62), c + h * (sz.x * 0.62 + 7.0), AMBER, 2.0)


func _draw_own() -> void:
	for u in view.own:
		var c := _unit_screen(u)
		_draw_plate(c, u.kind, PLAYER, true, u.standing != Sim.S_NONE, 1.0)
		var h := Vector2.from_angle(deg_to_rad(float(u.heading)))
		var sz := _plate_size(u.kind)
		draw_line(c + h * (sz.x * 0.62), c + h * (sz.x * 0.62 + 7.0), AZURE, 2.0)
		var mx: int = Sim.HP_MAX[u.kind]
		if u.hp < mx:
			var w := sz.x
			draw_rect(Rect2(c + Vector2(-w * 0.5, sz.y * 0.62), Vector2(w, 3)), INK)
			draw_rect(Rect2(c + Vector2(-w * 0.5, sz.y * 0.62), Vector2(w * float(u.hp) / float(mx), 3)), AZURE)
		if u.holdfire == 1:
			_text(c + Vector2(sz.x * 0.55, -sz.y * 0.4), "HF", 11, WHITE)
		if selected.has(u.id):
			_brackets(c, sz)
			_tag(c + Vector2(-16, -sz.y * 0.5 - 24), callsign(u.id))
		elif tactical():
			_text(c + Vector2(-12, -sz.y * 0.5 - 6), callsign(u.id), 11, MIST)


func _draw_fx() -> void:
	var now := Time.get_ticks_msec()
	for f in flashes:
		var k: float = 1.0 - f.t / 0.12
		draw_circle(w2s(f.p), (7.0 if f.k == Sim.K_ARM else 4.5) * k + 1.0, Color(WHITE, 0.85 * k))
	for p in projectiles:
		var u: float = clampf(p.t / p.dur, 0.0, 1.0)
		var s1 := w2s(p.p1)
		var s2 := w2s(p.p2)
		var head := s1.lerp(s2, u)
		var dirv := (s2 - s1).normalized()
		var armor: bool = p.k == Sim.K_ARM
		var tl := 30.0 if armor else 18.0
		var tail := head - dirv * minf(tl, s1.distance_to(head))
		var col := fcol(p.f)
		draw_line(tail, head, Color(col, 0.55), 7.0 if armor else 4.0)
		draw_line(tail.lerp(head, 0.35), head, Color(col, 1.0), 4.0 if armor else 2.5)
		draw_circle(head, 4.0 if armor else 3.0, WHITE)
	for t in impacts:
		var a := clampf(float(t.until - now) / 280.0, 0.0, 1.0)
		var c := w2s(t.p)
		var rr := (9.0 if t.k == Sim.K_ARM else 5.0) * (2.0 - a)
		draw_arc(c, rr, 0.0, TAU, 20, Color(WHITE, a), 2.0)
		draw_line(c + Vector2(-4, -4), c + Vector2(4, 4), Color(WHITE, a), 1.5)
		draw_line(c + Vector2(-4, 4), c + Vector2(4, -4), Color(WHITE, a), 1.5)
	for r in rings:
		var k := clampf(float(now - r.start) / 900.0, 0.0, 1.0)
		draw_arc(w2s(Vector2(r.x, r.y)), 10.0 + 26.0 * k, 0.0, TAU, 32, Color(fcol(r.f), 1.0 - k), 2.0)


func _draw_drag() -> void:
	if lmb and lmb_start.distance_to(mouse) > 6.0:
		var r := Rect2(lmb_start, mouse - lmb_start).abs()
		draw_rect(r, Color(WHITE, 0.07))
		draw_rect(r, Color(WHITE, 0.8), false, 1.0)
	if rmb and rmb_start_s.distance_to(mouse) >= 10.0 and not selected.is_empty():
		var a := rmb_start_s
		var b := mouse
		draw_line(a, b, Color(WHITE, 0.75), 2.0)
		var cnt := selected.size()
		var perp := Vector2((b - a).y, -(b - a).x)
		if perp.x < 0.0:
			perp = -perp
		perp = perp.normalized()
		for k in cnt:
			var t := 0.5 if cnt == 1 else float(k) / float(cnt - 1)
			var p := a.lerp(b, t)
			draw_circle(p, 3.0, WHITE)
			draw_line(p, p + perp * 12.0, Color(WHITE, 0.6), 1.5)


func _objective_line() -> String:
	var s := ""
	for o in 3:
		var ow: int = sim.obj_owner[o]
		s += "%s: %s    " % [Region.OBJ_NAMES[o], "NEUTRAL" if ow < 0 else ("AZURE" if ow == 0 else "AMBER")]
	return s


func _draw_hud() -> void:
	var vs := vsize()
	# top bar
	_panel(Rect2(0, 0, vs.x, 30))
	_text(Vector2(10, 20), "T%s" % _clock(), 14, PAPER)
	var sp := "PAUSED" if paused else ("%dx" % speed)
	_text(Vector2(86, 20), sp, 14, WHITE if paused else MIST)
	_text(Vector2(150, 20), _objective_line(), 13, PAPER)
	var h0 := sim.hold_ticks[0]
	var h1 := sim.hold_ticks[1]
	var hold := "NO SIDE HOLDS 2 OF 3"
	if h0 > 0:
		hold = "AZURE HOLDS 2 OF 3   %d / %d" % [h0 / 10, Sim.HOLD_TICKS / 10]
	elif h1 > 0:
		hold = "AMBER HOLDS 2 OF 3   %d / %d" % [h1 / 10, Sim.HOLD_TICKS / 10]
	_text(Vector2(vs.x - 370, 20), hold, 13, AZURE if h0 > 0 else (AMBER if h1 > 0 else MIST))
	# force summary (own counts only; enemy counts are not public)
	_text(Vector2(vs.x - 500, 20), "AZURE UNITS %d" % view.own.size(), 13, AZURE)
	# zoom / speed controls
	_panel(Rect2(8, 36, 376, 30))
	_text(Vector2(16, 56), "ZOOM", 12, MIST)
	_text(Vector2(176, 56), "SPEED", 12, MIST)
	for b in _buttons():
		var on: bool = (b.id == "pause" and paused) or (b.id == "s1" and speed == 1 and not paused) or (b.id == "s2" and speed == 2) or (b.id == "s4" and speed == 4)
		var hover: bool = b.r.has_point(mouse)
		draw_rect(b.r, Color(GREY, 0.55 if hover else 0.3))
		draw_rect(b.r, WHITE if on else MIST, false, 1.5 if on else 1.0)
		_text(b.r.position + Vector2(5, 15), b.t, 12, WHITE if on else PAPER)
	# selection panel
	var pr := Rect2(8, vs.y - 128, 340, 120)
	_panel(pr)
	if selected.is_empty():
		_text(pr.position + Vector2(10, 22), "NO SELECTION", 13, MIST)
		_text(pr.position + Vector2(10, 44), "LMB / DRAG select    CTRL+A all", 12, MIST)
		_text(pr.position + Vector2(10, 62), "T armor    I infantry", 12, MIST)
	else:
		_text(pr.position + Vector2(10, 20), "SELECTED %d" % selected.size(), 14, WHITE)
		var shown := 0
		for u in view.own:
			if selected.has(u.id) and shown < 5:
				var st: String = Sim.STANDING_NAME[u.standing]
				var line := "%s %-8s HP %3d%%  AMMO %2d  %s%s" % [callsign(u.id), Sim.KIND_NAME[u.kind], 100 * u.hp / Sim.HP_MAX[u.kind], u.ammo, ("MOVING " if u.order != 0 else ""), st]
				_text(pr.position + Vector2(10, 40 + shown * 16), line, 11, PAPER)
				shown += 1
		if selected.size() > 5:
			_text(pr.position + Vector2(10, 40 + 5 * 16), "+ %d more" % (selected.size() - 5), 11, MIST)
	# feed
	if feed.size() > 0:
		var fr := Rect2(vs.x - 290, 38, 282, 10 + feed.size() * 16)
		_panel(fr)
		for i in feed.size():
			_text(fr.position + Vector2(8, 16 + i * 16), feed[i], 11, PAPER)
	# controls strip
	_text(Vector2(360, vs.y - 24), "RMB MOVE   RMB-DRAG LINE   S STOP   H HOLD   W WITHDRAW   A ADVANCE IF CLEAR   F FREE   C HOLD FIRE", 11, MIST)
	_text(Vector2(360, vs.y - 8), "SPACE PAUSE   1/2/3 SPEED   + / - ZOOM (also wheel, pinch, two-finger scroll)   ARROWS, MIDDLE-DRAG, MINIMAP: PAN   HOME MAP", 11, MIST)
	# minimap
	var mr := Rect2(vs.x - MINI - 8, vs.y - MINI - 8, MINI, MINI)
	_panel(mr)
	draw_texture_rect(terrain_tex, mr.grow(-2), false)
	var k := (MINI - 4.0) / 4096.0
	var o0 := mr.position + Vector2(2, 2)
	for u in view.own:
		draw_rect(Rect2(o0 + Vector2(u.x, u.y) / 1000.0 * k - Vector2(2, 2), Vector2(4, 4)), AZURE)
	for e in view.enemies:
		draw_rect(Rect2(o0 + Vector2(e.x, e.y) / 1000.0 * k - Vector2(2, 2), Vector2(4, 4)), AMBER)
	for o in 3:
		var ow: int = sim.obj_owner[o]
		draw_rect(Rect2(o0 + Vector2(Region.OBJ[o].x, Region.OBJ[o].y) / 1000.0 * k - Vector2(3, 3), Vector2(6, 6)), GREY if ow < 0 else fcol(ow), false, 1.5)
	var tl := o0 + cam * k - vs * 0.5 / zoom * k
	draw_rect(Rect2(tl, vs / zoom * k).intersection(Rect2(o0, Vector2(MINI - 4, MINI - 4))), WHITE, false, 1.0)


func _draw_brief() -> void:
	var vs := vsize()
	draw_rect(Rect2(Vector2.ZERO, vs), Color(SEA, 1.0))
	var r := Rect2(vs.x * 0.5 - 380, 60, 760, vs.y - 120)
	_panel(r)
	var y := r.position.y + 34.0
	var x0 := r.position.x + 26.0
	_text(Vector2(x0, y), "PHILIPPINE CONQUEST  -  PLANNED GAME  (PROTOTYPE V2)", 20, PAPER)
	y += 24.0
	_text(Vector2(x0, y), "Synthetic test region, not a real place.  Faction war RTS slice: you command the AZURE FORCE.", 13, MIST)
	y += 34.0
	var lines := [
		"GOAL    Hold 2 of 3 objectives for 60 seconds, or eliminate the AMBER FORCE.",
		"        Objectives: NORTH RIDGE, CROSSROADS, SOUTH FORD.  Stand a unit in the ring to capture.",
		"",
		"YOU SEE ONLY WHAT YOUR FORCE SEES.  Amber plates appear while your units have line of sight.",
		"Last-known contacts stay as hollow plates with an age.  Coarse FORCE rings show roughly where enemies are.",
		"",
		"SELECT   Left-click or drag a box.  Ctrl+A all, T armor, I infantry.",
		"MOVE     Right-click a point.  Right-drag draws a frontage line; units spread along it and face away from it.",
		"STANDING ORDERS (the few things units do on their own):",
		"         H hold    W withdraw when hurt or out of ammo    A advance if the way is clear    F clear",
		"OTHER    S stop    C toggle hold fire    SPACE pause (off by default)    1 / 2 / 3 speed (or the buttons top-left)",
		"ZOOM     + / - keys, the ZOOM buttons, mouse wheel, trackpad pinch or two-finger scroll.  Home = whole map.",
		"PAN      Arrow keys, middle-drag, or click / drag on the minimap.",
		"",
		"Plates: Azure SHIELD = yours.  Amber SWALLOWTAIL = enemy.  Dashed inner band = standing order active.",
		"Supply: units resupply ammo at your base and at objectives you own.",
	]
	for l in lines:
		_text(Vector2(x0, y), l, 13, PAPER if l.begins_with(" ") == false else MIST)
		y += 20.0
	y += 14.0
	_text(Vector2(x0, y), "PRESS ENTER TO BEGIN", 18, WHITE)
	_text(Vector2(x0, r.end.y - 18), "Playtest notes are written to user://playtest-v2.log when a game ends.", 11, MIST)


func _draw_end() -> void:
	var vs := vsize()
	var r := Rect2(vs.x * 0.5 - 250, vs.y * 0.5 - 150, 500, 300)
	_panel(r)
	var title := "DRAW"
	var col := PAPER
	if sim.winner == PLAYER:
		title = "VICTORY  -  AZURE FORCE"
		col = AZURE
	elif sim.winner == 1:
		title = "DEFEAT  -  AMBER FORCE WINS"
		col = AMBER
	var x0 := r.position.x + 24.0
	var y := r.position.y + 40.0
	_text(Vector2(x0, y), title, 22, col)
	y += 26.0
	_text(Vector2(x0, y), sim.win_reason + "   at T" + _clock(), 14, PAPER)
	y += 32.0
	var acc0 := 100 * int(sim.stats.hits[0]) / maxi(1, int(sim.stats.shots[0]))
	var acc1 := 100 * int(sim.stats.hits[1]) / maxi(1, int(sim.stats.shots[1]))
	_text(Vector2(x0, y), "AZURE   alive %d   kills %d   shots %d   hit %d%%" % [sim.count_alive(0), sim.stats.kills[0], sim.stats.shots[0], acc0], 13, AZURE)
	y += 22.0
	_text(Vector2(x0, y), "AMBER   alive %d   kills %d   shots %d   hit %d%%" % [sim.count_alive(1), sim.stats.kills[1], sim.stats.shots[1], acc1], 13, AMBER)
	y += 22.0
	_text(Vector2(x0, y), "Objectives held   AZURE %d   AMBER %d" % [sim.held(0), sim.held(1)], 13, PAPER)
	y += 40.0
	_text(Vector2(x0, y), "ENTER  play again on a new seed", 14, WHITE)


# ---------------- smoke / screenshot support ----------------
func _smoke_script() -> void:
	# simulated input through the same handler real input uses; ai0 also plays, so player commands are ignored in smoke mode
	var vs := vsize()
	match frame:
		5:
			var eb := InputEventKey.new()
			eb.keycode = KEY_ENTER
			eb.pressed = true
			_handle_event(eb)
		20:
			if opt_brief and phase != Phase.PLAY:
				print("SMOKE FAIL briefing did not advance to PLAY, phase=", phase)
				get_tree().quit(1)
			_press_mouse(MOUSE_BUTTON_LEFT, true, Vector2(-9000, -9000))
		24:
			_press_mouse(MOUSE_BUTTON_LEFT, false, Vector2(9000, 9000))
		30:
			print("SMOKE after box select: selected=", selected.size(), " own=", view.own.size(), " vsize=", vs, " first_screen=", _unit_screen(view.own[0]) if view.own.size() > 0 else "none")
		40:
			cam = Vector2(2048, 2048)
			zoom = 0.4
			_press_mouse(MOUSE_BUTTON_RIGHT, true, vs * 0.5)
		42:
			_press_mouse(MOUSE_BUTTON_RIGHT, false, vs * 0.5)
		44:
			_press_mouse(MOUSE_BUTTON_RIGHT, true, vs * 0.5)
		46:
			_press_mouse(MOUSE_BUTTON_RIGHT, false, vs * 0.5 + Vector2(0, 40))
		60:
			var e := InputEventKey.new()
			e.keycode = KEY_H
			e.pressed = true
			_handle_event(e)
		70:
			_zoom_step(1)
		80:
			_zoom_step(1)
		90:
			_zoom_step(-2)
		100:
			var e2 := InputEventKey.new()
			e2.keycode = KEY_SPACE
			e2.pressed = true
			_handle_event(e2)
		110:
			var e3 := InputEventKey.new()
			e3.keycode = KEY_SPACE
			e3.pressed = true
			_handle_event(e3)
		1500:
			var cmds := 0
			for l in plog:
				if String(l).contains("player cmd"):
					cmds += 1
			print("SMOKE done frames=", frame, " player_cmds=", cmds, " rejected=", sim.stats.rejected, " moving=", _moving_count(), " tick=", sim.tick, " phase=", phase, " alive=", sim.count_alive(0), "v", sim.count_alive(1), " selected=", selected.size(), " draw_ok=true")
			get_tree().quit(0)


func _moving_count() -> int:
	var c := 0
	for u in view.own:
		if u.order != 0:
			c += 1
	return c


func _press_mouse(btn: int, pressed: bool, pos: Vector2) -> void:
	var e := InputEventMouseButton.new()
	e.button_index = btn
	e.pressed = pressed
	e.position = pos
	_handle_event(e)


func _save_shot() -> void:
	var img := get_viewport().get_texture().get_image()
	var err := img.save_png(shot_path)
	print("SHOT saved ", shot_path, " err=", err, " size=", img.get_size())
	get_tree().quit(0)
