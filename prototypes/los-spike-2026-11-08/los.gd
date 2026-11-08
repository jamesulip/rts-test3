# PROTOTYPE - NOT FOR PRODUCTION
# Question: Can a heightfield-plus-cover line-of-sight query in GDScript over a hand-authored-style grid be fast enough for hundreds of units and accurate against a supersampled reference?
# Date: 2026-11-08
extends RefCounted

# Heights are integer centimetres, positions are integer millimetres. No floats in the query path.

const EYE := 170

var w := 0
var cell_mm := 0
var height := PackedInt32Array()
var cover := PackedByteArray()
var obs_h := PackedInt32Array([0, 150, 300, 800])   # cm added by cover class: none, hedge, low building, tall


func _hash(x: int, y: int, salt: int) -> int:
	var h := (x * 374761393 + y * 668265263 + salt * 2246822519) & 0xFFFFFFFF
	h = ((h ^ (h >> 13)) * 1274126177) & 0xFFFFFFFF
	return (h ^ (h >> 16)) & 255


func build_fine(w_cells: int, cell: int, seed_value: int) -> void:
	w = w_cells
	cell_mm = cell
	height.resize(w * w)
	cover.resize(w * w)
	var periods := [128, 48, 16]
	var amps := [3000, 1000, 300]
	var lat: Array = []
	for o in 3:
		var p: int = periods[o]
		var lw := w / p + 2
		var arr := PackedInt32Array()
		arr.resize(lw * lw)
		for ly in lw:
			for lx in lw:
				arr[ly * lw + lx] = _hash(lx, ly, seed_value + o)
		lat.append(arr)
	for y in w:
		for x in w:
			var hsum := 0
			for o in 3:
				var p: int = periods[o]
				var lw := w / p + 2
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
			height[y * w + x] = hsum
	cover.fill(0)
	var r := seed_value & 0xFFFFFFFF
	for k in 900:
		r = (r * 1664525 + 1013904223) & 0xFFFFFFFF
		var cx := (r >> 8) % w
		r = (r * 1664525 + 1013904223) & 0xFFFFFFFF
		var cy := (r >> 8) % w
		r = (r * 1664525 + 1013904223) & 0xFFFFFFFF
		var cw := 1 + (r >> 8) % 6
		r = (r * 1664525 + 1013904223) & 0xFFFFFFFF
		var ch := 1 + (r >> 8) % 6
		r = (r * 1664525 + 1013904223) & 0xFFFFFFFF
		var cls := 1 + (r >> 8) % 3
		for yy in range(cy, mini(cy + ch, w)):
			for xx in range(cx, mini(cx + cw, w)):
				cover[yy * w + xx] = cls


func downsample() -> Object:
	# half resolution over the same area: average height, maximum cover class (conservative)
	var half: int = w / 2
	var nh := PackedInt32Array()
	var nc := PackedByteArray()
	nh.resize(half * half)
	nc.resize(half * half)
	for y in half:
		for x in half:
			var i00: int = (2 * y) * w + 2 * x
			nh[y * half + x] = (height[i00] + height[i00 + 1] + height[i00 + w] + height[i00 + w + 1]) / 4
			nc[y * half + x] = maxi(maxi(cover[i00], cover[i00 + 1]), maxi(cover[i00 + w], cover[i00 + w + 1]))
	var s: Object = get_script().new()
	s.w = half
	s.cell_mm = cell_mm * 2
	s.height = nh
	s.cover = nc
	return s


func memory_bytes() -> int:
	return height.size() * 4 + cover.size()


func los(ax: int, ay: int, bx: int, by: int) -> bool:
	var x0 := clampi(ax / cell_mm, 0, w - 1)
	var y0 := clampi(ay / cell_mm, 0, w - 1)
	var x1 := clampi(bx / cell_mm, 0, w - 1)
	var y1 := clampi(by / cell_mm, 0, w - 1)
	var ah := height[y0 * w + x0] + EYE
	var bh := height[y1 * w + x1] + EYE
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
			var ci := y0 * w + x0
			if height[ci] + obs_h[cover[ci]] > ah + (bh - ah) * k / steps:
				return false
	return true


func los_reference(ax: int, ay: int, bx: int, by: int) -> bool:
	# supersampled ray march: 4 samples per cell along the longer axis, skipping the two end cells
	var xa := clampi(ax / cell_mm, 0, w - 1)
	var ya := clampi(ay / cell_mm, 0, w - 1)
	var xb := clampi(bx / cell_mm, 0, w - 1)
	var yb := clampi(by / cell_mm, 0, w - 1)
	var ah := height[ya * w + xa] + EYE
	var bh := height[yb * w + xb] + EYE
	var n := maxi(absi(bx - ax), absi(by - ay)) * 4 / cell_mm
	if n <= 4:
		return true
	for i in range(1, n):
		var x := clampi((ax + (bx - ax) * i / n) / cell_mm, 0, w - 1)
		var y := clampi((ay + (by - ay) * i / n) / cell_mm, 0, w - 1)
		if (x == xa and y == ya) or (x == xb and y == yb):
			continue
		var ci := y * w + x
		if height[ci] + obs_h[cover[ci]] > ah + (bh - ah) * i / n:
			return false
	return true
