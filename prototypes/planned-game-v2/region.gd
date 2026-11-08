# PROTOTYPE - NOT FOR PRODUCTION
# Question: Does the planned MVP (deterministic command-driven simulation, viewer projection, art-bible look) play as intended?
# Date: 2026-11-08
extends RefCounted

# SYNTHETIC PLACEHOLDER REGION ("Test Region"). It is NOT a real place. The real MVP region is still to be chosen and traced by the user.
# 8 m cells, integer centimetre heights, one cover-class byte per cell. No floats in the query path.

const CELL := 8000
const GRID := 512
const PCELL := 32000
const PGRID := 128
const REGION := 4096000
const EYE := 170
const WATER_CM := 500

const BASE0 := Vector2i(500000, 2048000)
const BASE1 := Vector2i(3596000, 2048000)
const OBJ := [Vector2i(2048000, 900000), Vector2i(2048000, 2048000), Vector2i(2048000, 3196000)]
const OBJ_NAMES := ["NORTH RIDGE", "CROSSROADS", "SOUTH FORD"]

var seed_value := 0
var height := PackedInt32Array()
var cover := PackedByteArray()      # 0 none, 1 hedge, 2 low building, 3 tall building
var road := PackedByteArray()
var passable := PackedByteArray()
var cpass := PackedByteArray()      # coarse 64x64
var obs_h := PackedInt32Array([0, 150, 300, 800])

# A* scratch (reused)
var _g := PackedInt32Array()
var _parent := PackedInt32Array()
var _closed := PackedByteArray()
var _heap := PackedInt64Array()


func _hash(x: int, y: int, salt: int) -> int:
	var h := (x * 374761393 + y * 668265263 + salt * 2246822519) & 0xFFFFFFFF
	h = ((h ^ (h >> 13)) * 1274126177) & 0xFFFFFFFF
	return (h ^ (h >> 16)) & 255


func build(seed_val: int) -> void:
	seed_value = seed_val
	height.resize(GRID * GRID)
	cover.resize(GRID * GRID)
	road.resize(GRID * GRID)
	passable.resize(GRID * GRID)
	road.fill(0)
	cover.fill(0)
	var periods := [64, 24, 8]
	var amps := [3000, 1000, 300]
	var lat: Array = []
	for o in 3:
		var p: int = periods[o]
		var lw := GRID / p + 2
		var arr := PackedInt32Array()
		arr.resize(lw * lw)
		for ly in lw:
			for lx in lw:
				arr[ly * lw + lx] = _hash(lx, ly, seed_val + o)
		lat.append(arr)
	for y in GRID:
		for x in GRID:
			var hsum := 0
			for o in 3:
				var p: int = periods[o]
				var lw := GRID / p + 2
				var arr: PackedInt32Array = lat[o]
				var x0 := x / p
				var y0 := y / p
				var fx := x % p
				var fy := y % p
				var v00 := arr[y0 * lw + x0]
				var v10 := arr[y0 * lw + x0 + 1]
				var v01 := arr[(y0 + 1) * lw + x0]
				var v11 := arr[(y0 + 1) * lw + x0 + 1]
				var v := ((v00 * (p - fx) + v10 * fx) * (p - fy) + (v01 * (p - fx) + v11 * fx) * fy) / (p * p)
				hsum += v * int(amps[o]) / 255
			height[y * GRID + x] = hsum
	var r := seed_val & 0xFFFFFFFF
	for k in 520:
		r = (r * 1664525 + 1013904223) & 0xFFFFFFFF
		var cx := (r >> 8) % GRID
		r = (r * 1664525 + 1013904223) & 0xFFFFFFFF
		var cy := (r >> 8) % GRID
		r = (r * 1664525 + 1013904223) & 0xFFFFFFFF
		var cw := 1 + (r >> 8) % 4
		r = (r * 1664525 + 1013904223) & 0xFFFFFFFF
		var ch := 1 + (r >> 8) % 4
		r = (r * 1664525 + 1013904223) & 0xFFFFFFFF
		var cls := 1 + (r >> 8) % 3
		for yy in range(cy, mini(cy + ch, GRID)):
			for xx in range(cx, mini(cx + cw, GRID)):
				cover[yy * GRID + xx] = cls
	# roads connect the key points; clearings keep objectives and bases usable
	var keys: Array = [BASE0, BASE1, OBJ[0], OBJ[1], OBJ[2]]
	var links := [[0, 3], [1, 3], [3, 2], [3, 4], [0, 2], [1, 4]]
	for l in links:
		_carve_road(keys[l[0]], keys[l[1]])
	for kp in keys:
		_clear_disc(kp, 32 if (kp == BASE0 or kp == BASE1) else 16)
	for i in GRID * GRID:
		var water := height[i] < WATER_CM and road[i] == 0
		if water:
			cover[i] = 0
		passable[i] = 1 if (road[i] == 1 or (not water and cover[i] < 2)) else 0
	_build_coarse()
	_g.resize(PGRID * PGRID)
	_parent.resize(PGRID * PGRID)
	_closed.resize(PGRID * PGRID)


func _carve_road(a: Vector2i, b: Vector2i) -> void:
	var x0 := a.x / CELL
	var y0 := a.y / CELL
	var x1 := b.x / CELL
	var y1 := b.y / CELL
	var dx := absi(x1 - x0)
	var dy := -absi(y1 - y0)
	var sx := 1 if x0 < x1 else -1
	var sy := 1 if y0 < y1 else -1
	var err := dx + dy
	while true:
		for oy in range(-1, 2):
			for ox in range(-1, 2):
				var xx := clampi(x0 + ox, 0, GRID - 1)
				var yy := clampi(y0 + oy, 0, GRID - 1)
				road[yy * GRID + xx] = 1
				cover[yy * GRID + xx] = 0
		if x0 == x1 and y0 == y1:
			break
		var e2 := 2 * err
		if e2 >= dy:
			err += dy
			x0 += sx
		if e2 <= dx:
			err += dx
			y0 += sy


func _clear_disc(c: Vector2i, rad: int) -> void:
	var cx := c.x / CELL
	var cy := c.y / CELL
	for yy in range(maxi(cy - rad, 0), mini(cy + rad + 1, GRID)):
		for xx in range(maxi(cx - rad, 0), mini(cx + rad + 1, GRID)):
			if (xx - cx) * (xx - cx) + (yy - cy) * (yy - cy) <= rad * rad:
				road[yy * GRID + xx] = 1
				cover[yy * GRID + xx] = 0


func _build_coarse() -> void:
	cpass.resize(PGRID * PGRID)
	var per := GRID / PGRID
	for cy in PGRID:
		for cx in PGRID:
			var n := 0
			for yy in per:
				for xx in per:
					n += passable[(cy * per + yy) * GRID + cx * per + xx]
			# conservative: a coarse cell is walkable only if every fine cell in it is, so any segment between
			# adjacent walkable cell centres stays on walkable ground
			cpass[cy * PGRID + cx] = 1 if n == per * per else 0


func is_passable(x: int, y: int) -> bool:
	return passable[clampi(y / CELL, 0, GRID - 1) * GRID + clampi(x / CELL, 0, GRID - 1)] == 1


func cover_at(x: int, y: int) -> int:
	return cover[clampi(y / CELL, 0, GRID - 1) * GRID + clampi(x / CELL, 0, GRID - 1)]


func is_water(x: int, y: int) -> bool:
	var i := clampi(y / CELL, 0, GRID - 1) * GRID + clampi(x / CELL, 0, GRID - 1)
	return height[i] < WATER_CM and road[i] == 0


func los(ax: int, ay: int, bx: int, by: int) -> bool:
	# evaluate each pair in a canonical order so A-sees-B always equals B-sees-A
	if ax > bx or (ax == bx and ay > by):
		var tx := ax
		var ty := ay
		ax = bx
		ay = by
		bx = tx
		by = ty
	var x0 := clampi(ax / CELL, 0, GRID - 1)
	var y0 := clampi(ay / CELL, 0, GRID - 1)
	var x1 := clampi(bx / CELL, 0, GRID - 1)
	var y1 := clampi(by / CELL, 0, GRID - 1)
	var ah := height[y0 * GRID + x0] + EYE
	var bh := height[y1 * GRID + x1] + EYE
	var dx := absi(x1 - x0)
	var dy := -absi(y1 - y0)
	var steps := maxi(dx, -dy)
	if steps <= 1:
		return true
	var sx := 1 if x0 < x1 else -1
	var sy := 1 if y0 < y1 else -1
	var err := dx + dy
	var k := 0
	while not (x0 == x1 and y0 == y1):
		var e2 := 2 * err
		if e2 >= dy:
			err += dy
			x0 += sx
		if e2 <= dx:
			err += dx
			y0 += sy
		k += 1
		if not (x0 == x1 and y0 == y1):
			var ci := y0 * GRID + x0
			if height[ci] + obs_h[cover[ci]] > ah + (bh - ah) * k / steps:
				return false
	return true


# ---- pathfinding on the coarse grid (A*, 8 neighbours, no corner cutting) ----

func _heap_push(v: int) -> void:
	_heap.append(v)
	var i := _heap.size() - 1
	while i > 0:
		var p := (i - 1) / 2
		if _heap[p] <= _heap[i]:
			break
		var t := _heap[p]
		_heap[p] = _heap[i]
		_heap[i] = t
		i = p


func _heap_pop() -> int:
	var top := _heap[0]
	var last := _heap[_heap.size() - 1]
	_heap.resize(_heap.size() - 1)
	if _heap.size() > 0:
		_heap[0] = last
		var i := 0
		var n := _heap.size()
		while true:
			var l := 2 * i + 1
			var rr := l + 1
			var m := i
			if l < n and _heap[l] < _heap[m]:
				m = l
			if rr < n and _heap[rr] < _heap[m]:
				m = rr
			if m == i:
				break
			var t := _heap[m]
			_heap[m] = _heap[i]
			_heap[i] = t
			i = m
	return top


func _nearest_coarse_passable(cx: int, cy: int) -> int:
	if cpass[cy * PGRID + cx] == 1:
		return cy * PGRID + cx
	for rad in range(1, PGRID):
		for yy in range(maxi(cy - rad, 0), mini(cy + rad + 1, PGRID)):
			for xx in range(maxi(cx - rad, 0), mini(cx + rad + 1, PGRID)):
				if maxi(absi(xx - cx), absi(yy - cy)) == rad and cpass[yy * PGRID + xx] == 1:
					return yy * PGRID + xx
	return cy * PGRID + cx


func find_path(x0: int, y0: int, x1: int, y1: int) -> PackedInt64Array:
	# returns flattened mm waypoints [x, y, x, y, ...]; the last one is the (possibly snapped) destination
	var sc := clampi(y0 / PCELL, 0, PGRID - 1) * PGRID + clampi(x0 / PCELL, 0, PGRID - 1)
	var goal := _nearest_coarse_passable(clampi(x1 / PCELL, 0, PGRID - 1), clampi(y1 / PCELL, 0, PGRID - 1))
	var out := PackedInt64Array()
	var dest_x := x1
	var dest_y := y1
	if not is_passable(x1, y1):
		dest_x = (goal % PGRID) * PCELL + PCELL / 2
		dest_y = (goal / PGRID) * PCELL + PCELL / 2
	if sc == goal:
		out.append(dest_x)
		out.append(dest_y)
		return out
	_g.fill(0x7fffffff)
	_closed.fill(0)
	_parent.fill(-1)
	_heap.resize(0)
	_g[sc] = 0
	_heap_push(_octile(sc, goal) * 32768 + sc)
	var found := false
	while _heap.size() > 0:
		var cur := _heap_pop() & 32767
		if _closed[cur] == 1:
			continue
		_closed[cur] = 1
		if cur == goal:
			found = true
			break
		var cx := cur % PGRID
		var cy := cur / PGRID
		for oy in range(-1, 2):
			for ox in range(-1, 2):
				if ox == 0 and oy == 0:
					continue
				var nx := cx + ox
				var ny := cy + oy
				if nx < 0 or ny < 0 or nx >= PGRID or ny >= PGRID:
					continue
				var ni := ny * PGRID + nx
				if cpass[ni] == 0 or _closed[ni] == 1:
					continue
				var step := 10
				if ox != 0 and oy != 0:
					if cpass[cy * PGRID + nx] == 0 or cpass[ny * PGRID + cx] == 0:
						continue
					step = 14
				var ng := _g[cur] + step
				if ng < _g[ni]:
					_g[ni] = ng
					_parent[ni] = cur
					_heap_push((ng + _octile(ni, goal)) * 32768 + ni)
	if not found:
		out.append(dest_x)
		out.append(dest_y)
		return out
	var cells: Array = []
	var c := goal
	while c != sc and c != -1:
		cells.append(c)
		c = _parent[c]
	cells.reverse()
	for i in cells.size() - 1:
		var cc: int = cells[i]
		var sp := _snap(cc)
		out.append(sp.x)
		out.append(sp.y)
	out.append(dest_x)
	out.append(dest_y)
	return out


func snap_dest(px_: int, py_: int) -> Vector2i:
	# a destination inside a blocked coarse cell moves to the centre of the nearest walkable one (within ~8 cells)
	var cx := clampi(px_ / PCELL, 0, PGRID - 1)
	var cy := clampi(py_ / PCELL, 0, PGRID - 1)
	if cpass[cy * PGRID + cx] == 1:
		return Vector2i(px_, py_)
	var best := -1
	var bd := 1 << 30
	for yy in range(maxi(cy - 8, 0), mini(cy + 9, PGRID)):
		for xx in range(maxi(cx - 8, 0), mini(cx + 9, PGRID)):
			if cpass[yy * PGRID + xx] == 1:
				var d := (xx - cx) * (xx - cx) + (yy - cy) * (yy - cy)
				if d < bd:
					bd = d
					best = yy * PGRID + xx
	if best < 0:
		return Vector2i(px_, py_)
	return Vector2i((best % PGRID) * PCELL + PCELL / 2, (best / PGRID) * PCELL + PCELL / 2)


func _snap(cc: int) -> Vector2i:
	# the passable fine cell closest to the centre of a coarse cell (waypoints must be standable)
	var per := GRID / PGRID
	var fx0 := (cc % PGRID) * per
	var fy0 := (cc / PGRID) * per
	var mid := per / 2
	var best := -1
	var bd := 1 << 30
	for yy in per:
		for xx in per:
			var i := (fy0 + yy) * GRID + fx0 + xx
			if passable[i] == 1:
				var d := (xx - mid) * (xx - mid) + (yy - mid) * (yy - mid)
				if road[i] == 1:
					d -= 6
				if d < bd:
					bd = d
					best = i
	if best < 0:
		return Vector2i((cc % PGRID) * PCELL + PCELL / 2, (cc / PGRID) * PCELL + PCELL / 2)
	return Vector2i((best % GRID) * CELL + CELL / 2, (best / GRID) * CELL + CELL / 2)


func _octile(a: int, b: int) -> int:
	var dx := absi(a % PGRID - b % PGRID)
	var dy := absi(a / PGRID - b / PGRID)
	return 10 * (dx + dy) - 6 * mini(dx, dy)
