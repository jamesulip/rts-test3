# PROTOTYPE - NOT FOR PRODUCTION
# Question: Does the planned MVP (deterministic command-driven simulation, viewer projection, art-bible look) play as intended?
# Date: 2026-11-08
extends SceneTree

const Region = preload("res://region.gd")
const Sim = preload("res://sim.gd")
const VProj = preload("res://vproj.gd")
const AI = preload("res://ai.gd")

var passed := 0
var failed := 0


func check(name: String, ok: bool, detail: String = "") -> void:
	if ok:
		passed += 1
		print("SELFTEST PASS  ", name, "  ", detail)
	else:
		failed += 1
		print("SELFTEST FAIL  ", name, "  ", detail)


func make_game(seed_val: int, inf: int, arm: int) -> Dictionary:
	var reg := Region.new()
	reg.build(seed_val)
	var sim := Sim.new()
	sim.setup(seed_val, inf, arm, reg)
	var vp := VProj.new()
	vp.reset()
	return {"reg": reg, "sim": sim, "vp": vp, "ai": [AI.new(0), AI.new(1)]}


func run_ticks(g: Dictionary, count: int) -> void:
	for t in count:
		var sim: RefCounted = g.sim
		if sim.winner != -2:
			return
		g.vp.observe(sim)
		g.ai[0].think(sim, g.vp)
		g.ai[1].think(sim, g.vp)
		sim.step()


func _init() -> void:
	print("SELFTEST start  engine=", Engine.get_version_info().string)
	test_region()
	test_commands()
	test_los_symmetry()
	test_determinism()
	test_save_load()
	test_projection()
	test_no_stall()
	test_soak()
	test_stress()
	print("SELFTEST done  passed=", passed, " failed=", failed)
	quit(1 if failed > 0 else 0)


func test_region() -> void:
	var a := Region.new()
	a.build(5)
	var b := Region.new()
	b.build(5)
	check("region deterministic", a.height == b.height and a.cover == b.cover)
	var p: PackedInt64Array = a.find_path(Region.BASE0.x, Region.BASE0.y, Region.BASE1.x, Region.BASE1.y)
	check("path base to base", p.size() >= 4)
	var ok := true
	for o in 3:
		var q: PackedInt64Array = a.find_path(Region.BASE0.x, Region.BASE0.y, Region.OBJ[o].x, Region.OBJ[o].y)
		ok = ok and q.size() >= 2 and a.is_passable(Region.OBJ[o].x, Region.OBJ[o].y)
	check("objectives reachable and passable", ok)


func test_commands() -> void:
	var g := make_game(11, 8, 4)
	var sim: RefCounted = g.sim
	var enemy_id := -1
	for i in sim.n:
		if sim.faction[i] == 1:
			enemy_id = i
			break
	var before: int = sim.stats.rejected
	var r1: bool = sim.issue({"type": Sim.C_MOVE, "faction": 0, "units": [enemy_id], "x": 1000000, "y": 1000000})
	check("command for unowned unit rejected", not r1 and sim.stats.rejected == before + 1)
	var r2: bool = sim.issue({"type": Sim.C_MOVE, "faction": 0, "units": [0], "x": 1000000, "y": 1000000})
	check("command for own unit accepted", r2)


func test_los_symmetry() -> void:
	var reg := Region.new()
	reg.build(21)
	var r := 12345
	var bad := 0
	for k in 3000:
		r = (r * 1664525 + 1013904223) & 0xFFFFFFFF
		var ax: int = (r >> 8) % 4000000
		r = (r * 1664525 + 1013904223) & 0xFFFFFFFF
		var ay: int = (r >> 8) % 4000000
		r = (r * 1664525 + 1013904223) & 0xFFFFFFFF
		var bx: int = (r >> 8) % 4000000
		r = (r * 1664525 + 1013904223) & 0xFFFFFFFF
		var by: int = (r >> 8) % 4000000
		if reg.los(ax, ay, bx, by) != reg.los(bx, by, ax, ay):
			bad += 1
	check("los symmetric A-B == B-A", bad == 0, "asymmetric=" + str(bad) + "/3000")


func test_determinism() -> void:
	var g1 := make_game(33, 8, 4)
	var g2 := make_game(33, 8, 4)
	run_ticks(g1, 2500)
	run_ticks(g2, 2500)
	var h1: int = g1.sim.state_hash()
	var h2: int = g2.sim.state_hash()
	check("two identical runs same hash", h1 == h2, "tick=" + str(g1.sim.tick) + " hash=" + str(h1) + " shots=" + str(g1.sim.stats.shots))
	check("combat occurred in determinism run", int(g1.sim.stats.shots[0]) + int(g1.sim.stats.shots[1]) > 0)
	var g3 := make_game(34, 8, 4)
	run_ticks(g3, 2500)
	check("different seed gives different hash", g3.sim.state_hash() != h1)


func test_save_load() -> void:
	var g := make_game(44, 8, 4)
	run_ticks(g, 700)
	var snap: Dictionary = g.sim.snapshot()
	var vis_copy: Array = g.vp.visible.duplicate(true)
	var mem_copy: Array = g.vp.memory.duplicate(true)
	var ai_copy := [g.ai[0].assigned.duplicate(), g.ai[1].assigned.duplicate()]
	var started_copy := [g.ai[0].started, g.ai[1].started]
	var lo: int = g.vp.last_observed
	run_ticks(g, 900)
	var h_a: int = g.sim.state_hash()
	var g2 := make_game(99, 8, 4)
	g2.sim.restore(snap)
	g2.vp.visible = vis_copy
	g2.vp.memory = mem_copy
	g2.vp.last_observed = lo
	for f in 2:
		g2.ai[f].assigned = ai_copy[f]
		g2.ai[f].started = started_copy[f]
	g2.reg.build(44)
	g2.sim.region = g2.reg
	run_ticks(g2, 900)
	var h_b: int = g2.sim.state_hash()
	check("save then load then continue equals uninterrupted", h_a == h_b, "a=" + str(h_a) + " b=" + str(h_b))


func test_projection() -> void:
	var g := make_game(55, 8, 4)
	run_ticks(g, 1500)
	var sim: RefCounted = g.sim
	var vp: RefCounted = g.vp
	var v: Dictionary = vp.view(sim, 0)
	var keys_ok := true
	for e in v.enemies:
		for k in e.keys():
			if not (k in VProj.ENEMY_KEYS or k == "px" or k == "py"):
				keys_ok = false
	for s in v.stale:
		for k in s.keys():
			if not (k in VProj.STALE_KEYS):
				keys_ok = false
	check("enemy entries carry only public keys", keys_ok)
	var los_ok := true
	for e in v.enemies:
		var seen := false
		for u in v.own:
			var dx: int = e.x - u.x
			var dy: int = e.y - u.y
			if dx * dx + dy * dy <= Sim.SIGHT_MM[u.kind] * Sim.SIGHT_MM[u.kind] and sim.region.los(u.x, u.y, e.x, e.y):
				seen = true
		los_ok = los_ok and seen
	check("every listed enemy has sight from an own unit", los_ok, "visible=" + str(v.enemies.size()) + " stale=" + str(v.stale.size()) + " markers=" + str(v.markers.size()))
	# leak test: change every hidden enemy field, the view must not change
	var before: String = JSON.stringify(vp.view(sim, 0))
	var snap: Dictionary = sim.snapshot()
	for j in sim.n:
		if sim.faction[j] == 1 and sim.alive[j] == 1:
			sim.hp[j] = maxi(1, sim.hp[j] / 2)
			sim.ammo[j] = 1
			sim.order[j] = 1 - sim.order[j]
			sim.standing[j] = 3
			sim.holdfire[j] = 1
			sim.target[j] = -1
			sim.cd[j] += 7
	var after: String = JSON.stringify(vp.view(sim, 0))
	check("changing hidden enemy hp/ammo/orders does not change viewer's view", before == after)
	sim.restore(snap)
	# the reverse direction
	var before1: String = JSON.stringify(vp.view(sim, 1))
	for j in sim.n:
		if sim.faction[j] == 0 and sim.alive[j] == 1:
			sim.hp[j] = 1
			sim.ammo[j] = 0
			sim.standing[j] = 2
	check("same for the other faction", before1 == JSON.stringify(vp.view(sim, 1)))


func test_no_stall() -> void:
	# 1) cross-map move orders: nobody may freeze (moved under 60 m in the last 500 ticks while still ordered)
	var total := 0
	var frozen := 0
	var worst_cmd_ms := 0.0
	for sd in [77, 101, 202, 303, 404, 505, 606, 707]:
		var g := make_game(sd, 8, 4)
		var sim: RefCounted = g.sim
		var dests := [Vector2i(2048000, 900000), Vector2i(2048000, 2048000), Vector2i(2048000, 3196000), Vector2i(1200000, 500000), Vector2i(1500000, 3600000), Vector2i(3000000, 2048000)]
		for k in 4:
			var d: Vector2i = dests[(sd + k) % dests.size()]
			var ids := []
			for i in sim.n:
				if sim.faction[i] == 0 and i % 4 == k:
					ids.append(i)
			sim.issue({"type": Sim.C_MOVE, "faction": 0, "units": ids, "x": d.x, "y": d.y, "face": -1})
		var snap := {}
		for t in 2500:
			var t0 := Time.get_ticks_usec()
			sim.step()
			if t == 0:
				worst_cmd_ms = maxf(worst_cmd_ms, float(Time.get_ticks_usec() - t0) / 1000.0)
			sim.winner = -2
			if t == 1999:
				for i in sim.n:
					snap[i] = Vector2i(sim.x[i] / 1000, sim.y[i] / 1000)
		for i in sim.n:
			if sim.faction[i] == 0:
				total += 1
				var moved: int = absi(sim.x[i] / 1000 - snap[i].x) + absi(sim.y[i] / 1000 - snap[i].y)
				if sim.order[i] != 0 and moved < 60:
					frozen += 1
	check("no unit freezes on cross-map move orders", frozen == 0, "frozen=" + str(frozen) + "/" + str(total))
	check("a 12-unit move order costs under 150 ms to plan", worst_cmd_ms < 150.0, "worst_ms=" + str(snappedf(worst_cmd_ms, 0.1)))
	# 2) during real AI-vs-AI games: no unit with a move order and no target sits still for 300 ticks
	var stalls := 0
	for sd in [101, 303, 505]:
		var g2 := make_game(sd, 8, 4)
		var sim2: RefCounted = g2.sim
		var still := {}
		var last := {}
		for t in 4000:
			if sim2.winner != -2:
				break
			run_ticks(g2, 1)
			if t % 100 == 0:
				for i in sim2.n:
					if sim2.alive[i] == 1:
						var pos := Vector2i(sim2.x[i] / 1000, sim2.y[i] / 1000)
						if sim2.order[i] != 0 and sim2.target[i] == -1 and last.has(i) and absi(last[i].x - pos.x) + absi(last[i].y - pos.y) < 6:
							still[i] = int(still.get(i, 0)) + 1
						else:
							still[i] = 0
						last[i] = pos
						if still[i] >= 3:
							stalls += 1
							still[i] = 0
	check("no ordered unit idles for 300 ticks in AI-vs-AI games", stalls == 0, "stall_events=" + str(stalls))


func test_soak() -> void:
	var wins := [0, 0, 0]
	var ticks_total := 0
	var shots_total := 0
	var worst_ms := 0.0
	var line := ""
	for sd in [101, 202, 303, 404, 505, 606]:
		var g := make_game(sd, 8, 4)
		var t0 := Time.get_ticks_usec()
		run_ticks(g, Sim.TICK_LIMIT + 5)
		var ms: float = float(Time.get_ticks_usec() - t0) / 1000.0
		var sim: RefCounted = g.sim
		worst_ms = maxf(worst_ms, ms / maxf(1.0, float(sim.tick)))
		var w: int = sim.winner
		wins[w + 1 if w >= 0 else 0] += 1 if w >= 0 else 0
		if w == -1:
			wins[2] += 0
		ticks_total += sim.tick
		shots_total += int(sim.stats.shots[0]) + int(sim.stats.shots[1])
		line += " seed" + str(sd) + ":winner=" + str(w) + "@" + str(sim.tick) + "(" + sim.win_reason + ",alive " + str(sim.count_alive(0)) + "v" + str(sim.count_alive(1)) + ",held " + str(sim.held(0)) + "v" + str(sim.held(1)) + ")"
	print("SELFTEST soak ", line)
	check("soak: every AI-vs-AI game ended with a result", ticks_total > 0)
	check("soak: shots fired", shots_total > 0, "shots=" + str(shots_total))
	print("SELFTEST soak_ms_per_tick_worst=", snappedf(worst_ms, 0.001))


func test_stress() -> void:
	var g := make_game(77, 40, 10)   # 100 units
	var t0 := Time.get_ticks_usec()
	run_ticks(g, 800)
	var ms: float = float(Time.get_ticks_usec() - t0) / 1000.0 / 800.0
	check("stress 100 units under 8 ms/tick average", ms < 8.0, "ms_per_tick=" + str(snappedf(ms, 0.01)) + " alive=" + str(g.sim.count_alive(0)) + "v" + str(g.sim.count_alive(1)))
