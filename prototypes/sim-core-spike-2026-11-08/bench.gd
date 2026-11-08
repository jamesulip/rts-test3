# PROTOTYPE - NOT FOR PRODUCTION
# Question: Can a plain-data, fixed-point, fixed-tick simulation core written in GDScript run hundreds of units headless fast enough and deterministically?
# Date: 2026-11-08
extends SceneTree

const SimScript = preload("res://sim.gd")

const PER_BATCH := 20
var hour_ticks := 36000
var quick := false


func _init() -> void:
	for a in OS.get_cmdline_user_args():
		if a.begins_with("--hour-ticks="):
			hour_ticks = int(a.substr(13))
		elif a == "--quick":
			quick = true
	print("SPIKE start  engine=", Engine.get_version_info().string, "  hour_ticks=", hour_ticks, "  quick=", quick)
	_determinism()
	_throughput()
	_scaling()
	print("SPIKE done")
	quit(0)


func _make(seed_value: int, n_units: int, total_ticks: int) -> Object:
	var s: Object = SimScript.new()
	s.setup(seed_value, n_units)
	s.load_commands(total_ticks, seed_value + 7, PER_BATCH)
	return s


func _run(s: Object, ticks: int) -> void:
	for t in ticks:
		s.step()


func _determinism() -> void:
	var ticks := 3000 if quick else 6000
	var hashes: Array = []
	for r in 5:
		var s := _make(1234, 300, ticks)
		_run(s, ticks)
		hashes.append(s.state_hash())
	var same := true
	for h in hashes:
		if h != hashes[0]:
			same = false
	var other := _make(4321, 300, ticks)
	_run(other, ticks)
	print("SPIKE determinism  runs=5  ticks=", ticks, "  identical=", same, "  hash=", hashes[0], "  different_seed_hash_differs=", other.state_hash() != hashes[0])

	# save/load round trip through bytes
	var a := _make(1234, 300, ticks)
	_run(a, ticks / 2)
	var hash_at_snapshot: int = a.state_hash()
	var bytes: PackedByteArray = var_to_bytes(a.snapshot())
	_run(a, ticks - ticks / 2)
	var uninterrupted: int = a.state_hash()
	var b := _make(1234, 300, ticks)
	b.restore(bytes_to_var(bytes))
	var restored_hash: int = b.state_hash()
	_run(b, ticks - ticks / 2)
	var resumed: int = b.state_hash()
	print("SPIKE saveload  snapshot_bytes=", bytes.size(), "  restored_matches_snapshot=", restored_hash == hash_at_snapshot, "  resumed_matches_uninterrupted=", resumed == uninterrupted)
	print("SPIKE sim_activity  shots=", a.shots, "  hits=", a.hits, "  kills=", a.kills, "  workload_has_combat=", a.shots > 0 and a.kills > 0)


func _throughput() -> void:
	var s := _make(99, 300, hour_ticks)
	var t0 := Time.get_ticks_usec()
	_run(s, hour_ticks)
	var wall := float(Time.get_ticks_usec() - t0) / 1000000.0
	var verdict := "PASS" if wall <= 30.0 else ("MARGINAL" if wall <= 90.0 else "FAIL")
	print("SPIKE throughput  units=300  ticks=", hour_ticks, "  world_time_s=", hour_ticks / 10, "  wall_s=", snappedf(wall, 0.01), "  ticks_per_s=", int(hour_ticks / wall), "  speedup=", snappedf(float(hour_ticks / 10) / wall, 0.1), "x  verdict_vs_30s=", verdict)
	print("SPIKE throughput_activity  shots=", s.shots, "  hits=", s.hits, "  kills=", s.kills, "  workload_has_combat=", s.shots > 0 and s.kills > 0)
	print("SPIKE projection  8h_skip_ticks=288000  projected_wall_s=", snappedf(wall * 288000.0 / float(hour_ticks), 0.1), "  (VS-A catch-up, 300 units; not pass/fail)")

	# per-tick latency and phase cost on a fresh run
	var p := _make(99, 300, 3000)
	p.prof = true
	var samples: Array = []
	for t in 2000:
		var a := Time.get_ticks_usec()
		p.step()
		samples.append(Time.get_ticks_usec() - a)
	samples.sort()
	var sum := 0
	for v in samples:
		sum += v
	var mean_ms := float(sum) / float(samples.size()) / 1000.0
	var p99_ms := float(samples[int(samples.size() * 0.99)]) / 1000.0
	var ok := mean_ms <= 1.0 and p99_ms <= 3.0
	print("SPIKE tick_latency  units=300  mean_ms=", snappedf(mean_ms, 0.001), "  p99_ms=", snappedf(p99_ms, 0.001), "  verdict_vs_1ms_3ms=", "PASS" if ok else "FAIL")
	print("SPIKE phase_cost  hash_rebuild_pct=", snappedf(100.0 * p.t_hash / float(p.t_hash + p.t_units), 0.1), "  unit_update_pct=", snappedf(100.0 * p.t_units / float(p.t_hash + p.t_units), 0.1))


func _scaling() -> void:
	var ticks := 1500 if quick else 6000
	for n_units in [100, 300, 600, 1000]:
		var s := _make(5, n_units, ticks)
		var t0 := Time.get_ticks_usec()
		_run(s, ticks)
		var wall := float(Time.get_ticks_usec() - t0) / 1000000.0
		print("SPIKE scaling  units=", n_units, "  ticks=", ticks, "  wall_s=", snappedf(wall, 0.01), "  ms_per_tick=", snappedf(wall * 1000.0 / ticks, 0.001), "  ticks_per_s=", int(ticks / wall))
