# PROTOTYPE - NOT FOR PRODUCTION
# Question: Does the planned MVP (deterministic command-driven simulation, viewer projection, art-bible look) play as intended?
# Date: 2026-11-08
extends RefCounted

# Viewer Projection (C4): the ONLY read path for UI and AI.
# Own units: full detail. Enemy units: position, kind, facing only, and only while an own unit has line of sight.
# Out of sight: last-known marks (stale, with age) and coarse force-aggregate markers (public by design).
# Never exposed about enemies: hp, ammo, orders, standing orders, targets, hold-fire.

const Sim = preload("res://sim.gd")
const MARKER_CELL := 1024000
const STALE_TTL := 600
const OBSERVE_EVERY := 3

const ENEMY_KEYS := ["id", "kind", "x", "y", "heading"]
const STALE_KEYS := ["id", "kind", "x", "y", "age"]

var visible: Array = [[], []]       # per faction: ids of enemies visible at last observation
var memory: Array = [{}, {}]        # per faction: enemy id -> {kind, x, y, seen}
var last_observed := -1


func reset() -> void:
	visible = [[], []]
	memory = [{}, {}]
	last_observed = -1


func observe(sim: RefCounted) -> void:
	if sim.tick - last_observed < OBSERVE_EVERY and last_observed >= 0:
		return
	last_observed = sim.tick
	for f in 2:
		var vis: Array = []
		for j in sim.n:
			if sim.alive[j] == 1 and sim.faction[j] != f:
				for i in sim.n:
					if sim.alive[i] == 1 and sim.faction[i] == f:
						var dx: int = sim.x[j] - sim.x[i]
						var dy: int = sim.y[j] - sim.y[i]
						var s: int = Sim.SIGHT_MM[sim.kind[i]]
						if dx * dx + dy * dy <= s * s and sim.region.los(sim.x[i], sim.y[i], sim.x[j], sim.y[j]):
							vis.append(j)
							break
		visible[f] = vis
		var mem: Dictionary = memory[f]
		for j in vis:
			mem[j] = {"kind": int(sim.kind[j]), "x": int(sim.x[j]), "y": int(sim.y[j]), "seen": sim.tick}
		# a visible death clears the memory entry; an unseen death does not
		for e in sim.events:
			if e.t == "death" and e.f != f and mem.has(e.id) and vis.has(e.id) == false and _was_seen_dying(sim, e.id, f):
				mem.erase(e.id)
		for id in mem.keys():
			if vis.has(id):
				continue
			if sim.tick - int(mem[id].seen) > STALE_TTL or (sim.alive[id] == 0 and _was_seen_dying(sim, id, f)):
				mem.erase(id)


func _was_seen_dying(sim: RefCounted, id: int, f: int) -> bool:
	# the death location must be inside an own unit's sight, otherwise the viewer does not know it died
	for i in sim.n:
		if sim.alive[i] == 1 and sim.faction[i] == f:
			var dx: int = sim.x[id] - sim.x[i]
			var dy: int = sim.y[id] - sim.y[i]
			var s: int = Sim.SIGHT_MM[sim.kind[i]]
			if dx * dx + dy * dy <= s * s and sim.region.los(sim.x[i], sim.y[i], sim.x[id], sim.y[id]):
				return true
	return false


func view(sim: RefCounted, f: int) -> Dictionary:
	var own: Array = []
	for i in sim.n:
		if sim.alive[i] == 1 and sim.faction[i] == f:
			own.append({
				"id": i, "kind": int(sim.kind[i]), "x": int(sim.x[i]), "y": int(sim.y[i]),
				"px": int(sim.px[i]), "py": int(sim.py[i]),
				"heading": int(sim.heading[i]), "hp": int(sim.hp[i]), "ammo": int(sim.ammo[i]),
				"order": int(sim.order[i]), "standing": int(sim.standing[i]), "holdfire": int(sim.holdfire[i]),
				"target": int(sim.target[i]), "fired": int(sim.fired_tick[i]),
				"dest_x": int(sim.dest_x[i]), "dest_y": int(sim.dest_y[i]), "sx": int(sim.sx[i]), "sy": int(sim.sy[i]),
			})
	var enemies: Array = []
	for j in visible[f]:
		if sim.alive[j] == 1:
			enemies.append({"id": j, "kind": int(sim.kind[j]), "x": int(sim.x[j]), "y": int(sim.y[j]), "heading": int(sim.heading[j]), "px": int(sim.px[j]), "py": int(sim.py[j])})
	var stale: Array = []
	var mem: Dictionary = memory[f]
	for id in mem.keys():
		if not visible[f].has(id):
			var m: Dictionary = mem[id]
			stale.append({"id": id, "kind": m.kind, "x": m.x, "y": m.y, "age": sim.tick - int(m.seen)})
	# coarse aggregate markers: enemy force counts per 1 km cell, bucketed, positions not exact
	var cells := {}
	for j in sim.n:
		if sim.alive[j] == 1 and sim.faction[j] != f and not visible[f].has(j):
			var key: Vector2i = Vector2i(int(sim.x[j]) / MARKER_CELL, int(sim.y[j]) / MARKER_CELL)
			cells[key] = int(cells.get(key, 0)) + 1
	var markers: Array = []
	for key in cells.keys():
		var c: int = cells[key]
		markers.append({"cx": key.x * MARKER_CELL + MARKER_CELL / 2, "cy": key.y * MARKER_CELL + MARKER_CELL / 2, "bucket": 1 if c <= 2 else (2 if c <= 5 else 3)})
	var objs: Array = []
	for o in 3:
		objs.append({"owner": int(sim.obj_owner[o]), "control": int(sim.obj_control[o])})
	return {"faction": f, "tick": sim.tick, "own": own, "enemies": enemies, "stale": stale, "markers": markers, "objectives": objs}
