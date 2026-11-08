# PROTOTYPE - NOT FOR PRODUCTION
# Question: Does the planned MVP (deterministic command-driven simulation, viewer projection, art-bible look) play as intended?
# Date: 2026-11-08
extends RefCounted

# Objective-priority planner. Reads ONLY its faction's viewer projection; acts ONLY through sim.issue().
# Armor drives for the Crossroads; infantry split across unowned objectives; everyone gets WITHDRAW as a standing order.

const Region = preload("res://region.gd")
const Sim = preload("res://sim.gd")

var f := 1
var cadence := 20
var assigned := {}       # unit id -> objective index
var started := false


func _init(faction_id: int = 1) -> void:
	f = faction_id


func think(sim: RefCounted, vp: RefCounted) -> void:
	if sim.tick % cadence != (f * 7) % cadence or sim.winner != -2:
		return
	var v: Dictionary = vp.view(sim, f)
	var own: Array = v.own
	if own.is_empty():
		return
	if not started:
		started = true
		var ids: Array = []
		for u in own:
			ids.append(u.id)
		sim.issue({"type": Sim.C_STANDING, "faction": f, "units": ids, "mode": Sim.S_WITHDRAW})
	var base: Vector2i = Region.BASE0 if f == 0 else Region.BASE1
	var groups := {}
	for u in own:
		var want: int = int(assigned.get(u.id, -1))
		if want < 0 or v.objectives[want].owner == f:
			want = _assign(u, v, base)
		var moved_on: bool = assigned.get(u.id, -1) != want
		var idle_far: bool = u.order == 0 and u.standing != Sim.S_ADVANCE and _far_from(u, want)
		if moved_on or idle_far:
			assigned[u.id] = want
			if not groups.has(want):
				groups[want] = []
			groups[want].append(u.id)
	for o in groups.keys():
		var ids: Array = groups[o]
		var c: Vector2i = Region.OBJ[o]
		var dirx := signi(base.x - c.x)
		var cx := c.x + dirx * 30000
		var half := (ids.size() - 1) * 15000 + 1000
		var fc := 0 if f == 0 else 180
		if ids.size() == 1:
			sim.issue({"type": Sim.C_MOVE, "faction": f, "units": ids, "x": cx, "y": c.y, "face": fc})
		else:
			sim.issue({"type": Sim.C_FRONT, "faction": f, "units": ids, "x": cx, "y": c.y - half, "x2": cx, "y2": c.y + half, "face": fc})


func _far_from(u: Dictionary, o: int) -> bool:
	var c: Vector2i = Region.OBJ[o]
	var dx: int = u.x - c.x
	var dy: int = u.y - c.y
	return dx * dx + dy * dy > 120000 * 120000


func _assign(u: Dictionary, v: Dictionary, base: Vector2i) -> int:
	var objs: Array = v.objectives
	var cands: Array = []
	for o in 3:
		if objs[o].owner != f:
			cands.append(o)
	if cands.is_empty():
		return 1
	if u.kind == Sim.K_ARM and cands.has(1):
		return 1
	var bx: int = u.x
	var by: int = u.y
	cands.sort_custom(func(a: int, b: int) -> bool:
		var da: int = (Region.OBJ[a].x - bx) * (Region.OBJ[a].x - bx) + (Region.OBJ[a].y - by) * (Region.OBJ[a].y - by)
		var db: int = (Region.OBJ[b].x - bx) * (Region.OBJ[b].x - bx) + (Region.OBJ[b].y - by) * (Region.OBJ[b].y - by)
		return da < db if da != db else a < b)
	if u.id % 2 == 1 and cands.size() > 1:
		return cands[1]
	return cands[0]
