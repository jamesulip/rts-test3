# PROTOTYPE - NOT FOR PRODUCTION
# Question: Can a heightfield-plus-cover line-of-sight query in GDScript over a hand-authored-style grid be fast enough for hundreds of units and accurate against a supersampled reference?
# Date: 2026-11-08
extends SceneTree

const LosScript = preload("res://los.gd")
const REGION_MM := 4096000   # 4,096 m square region
const MAX_RANGE_MM := 300000


func _init() -> void:
	print("SPIKE start  engine=", Engine.get_version_info().string)
	var t0 := Time.get_ticks_usec()
	var g4: Object = LosScript.new()
	g4.build_fine(1024, 4000, 77)
	print("SPIKE build  cell=4m  grid=1024x1024  build_s=", snappedf(float(Time.get_ticks_usec() - t0) / 1000000.0, 0.1), "  memory_kb=", g4.memory_bytes() / 1024)
	var g8: Object = g4.downsample()
	var g16: Object = g8.downsample()
	print("SPIKE build  cell=8m  grid=512x512  memory_kb=", g8.memory_bytes() / 1024, "   cell=16m  grid=256x256  memory_kb=", g16.memory_bytes() / 1024)
	for g in [g4, g8, g16]:
		_accuracy(g)
	for g in [g4, g8, g16]:
		_cost(g)
	print("SPIKE done")
	quit(0)


func _pairs(count: int, seed_value: int) -> Array:
	var out: Array = []
	var r := seed_value & 0xFFFFFFFF
	for i in count:
		r = (r * 1664525 + 1013904223) & 0xFFFFFFFF
		var ax := 400000 + (r >> 8) % (REGION_MM - 800000)
		r = (r * 1664525 + 1013904223) & 0xFFFFFFFF
		var ay := 400000 + (r >> 8) % (REGION_MM - 800000)
		r = (r * 1664525 + 1013904223) & 0xFFFFFFFF
		var dist := 20000 + (r >> 8) % (MAX_RANGE_MM - 20000)
		r = (r * 1664525 + 1013904223) & 0xFFFFFFFF
		var ang := float((r >> 8) % 3600) * TAU / 3600.0
		var bx := clampi(ax + int(cos(ang) * dist), 1000, REGION_MM - 1000)
		var by := clampi(ay + int(sin(ang) * dist), 1000, REGION_MM - 1000)
		out.append([ax, ay, bx, by])
	return out


func _accuracy(g: Object) -> void:
	var pairs := _pairs(5000, 11)
	var mismatch := 0
	var blocked := 0
	for p in pairs:
		var a: bool = g.los(p[0], p[1], p[2], p[3])
		var b: bool = g.los_reference(p[0], p[1], p[2], p[3])
		if a != b:
			mismatch += 1
		if not b:
			blocked += 1
	var pct := 100.0 * mismatch / pairs.size()
	var verdict := "PASS" if pct <= 1.0 else ("MARGINAL" if pct <= 3.0 else "FAIL")
	print("SPIKE accuracy  cell=", g.cell_mm / 1000, "m  pairs=", pairs.size(), "  mismatch_pct=", snappedf(pct, 0.01), "  reference_blocked_pct=", snappedf(100.0 * blocked / pairs.size(), 0.1), "  verdict=", verdict)


func _time_queries(g: Object, pairs: Array, repeats: int) -> float:
	var t0 := Time.get_ticks_usec()
	var sink := 0
	for r in repeats:
		for p in pairs:
			if g.los(p[0], p[1], p[2], p[3]):
				sink += 1
	var us := float(Time.get_ticks_usec() - t0)
	return us / float(repeats * pairs.size())   # microseconds per query


func _cost(g: Object) -> void:
	var pairs4 := _pairs(1200, 23)   # 300 units x 4 candidates
	var pairs1 := _pairs(300, 29)    # 300 units x 1 candidate
	var us4 := _time_queries(g, pairs4, 5)
	var us1 := _time_queries(g, pairs1, 20)
	var full_ms := us4 * 1200.0 / 1000.0                 # every tick, 4 candidates, 300 units
	var q_ms := full_ms / 4.0                            # refreshed every 4th tick
	var one_ms := us1 * 300.0 / 1000.0                   # every tick, 1 candidate
	var one_q_ms := one_ms / 4.0
	var verdict := "PASS" if full_ms <= 4.0 else ("MARGINAL" if q_ms <= 4.0 else "FAIL")
	var big_ms := us4 * 2400.0 / 1000.0                  # 600 units x 4 candidates every tick
	print("SPIKE cost  cell=", g.cell_mm / 1000, "m  us_per_query=", snappedf(us4, 0.1), "  300u_x4cand_every_tick_ms=", snappedf(full_ms, 0.01), "  every_4th_tick_ms=", snappedf(q_ms, 0.01), "  300u_x1cand_every_tick_ms=", snappedf(one_ms, 0.01), "  1cand_every_4th_ms=", snappedf(one_q_ms, 0.01), "  600u_x4cand_every_tick_ms=", snappedf(big_ms, 0.01), "  verdict=", verdict)
