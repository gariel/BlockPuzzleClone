extends Node2D

var touch = Vector2(0, 0)

func _input(ev):
	if ev is InputEventScreenDrag or ev is InputEventScreenTouch:
		touch = ev.position * 2 - self.position * 2

const WH = 110
var hovering = null

func _ready():
	set_process(true)

# warning-ignore:unused_argument
func _process(delta):
	for b in get_node("Blocks").get_children():
		b.Marked = false
	
	if hovering:
		for m in _get_marked():
			m.Marked = true
				
func _get_marked():
	var half_size = hovering.Size / 2.0
	var bpx = int((touch.x / WH) - half_size)
	var bpy = int((touch.y / WH) - half_size)
	
	var marked = []
	for y in range(hovering.Size):
		for x in range(hovering.Size):
			var p = hovering.get_node("Blocks/b" + str(x) + str(y))
			var bx = bpx + x
			var by = bpy + y
			var b = get_node_or_null("Blocks/b" + str(bx) + str(by))
			if p.Filled and (not b or b.Filled):
				return []
			if p.Filled:
				marked.append(b)
	return marked
					

func hover(node):
	hovering = node

func set_piece(piece):
	if not hovering or hovering != piece:
		hovering = null
		return false
	
	var marked = _get_marked()
	hovering = null
	if not marked:
		return false
	
	for m in marked:
		m.Filled = true
		m.Paint = piece.Paint
	return true

func can_position(piece):
	var h = int(ceil(piece.Size / 2))
	var cells = {}
	for y in range(10 + h):
		for x in range(10 + h):
			var can = true
			for yp in range(piece.Size):
				if not can:
					break

				for xp in range(piece.Size):
					var b = piece.get_node("Blocks/b" + str(xp) + str(yp))
					var bx = x + xp
					var by = y + yp

					if not b.Filled:
						continue

					if bx < 0 or by < 0 or bx > 9 or by > 9:
						can = false
						break

					var k = [bx, by]
					if not k in cells:
						cells[k] = get_node("Blocks/b" + str(bx) + str(by))
					var c = cells[k]

					if c.Filled:
						can = false

			if can:
				return true
	return false

func validate():
	var win = []
	for y in range(10):
		var fills = []
		for x in range(10):
			var n = get_node("Blocks/b" + str(x) + str(y))
			if n.Filled:
				fills.append(n)
		if len(fills) == 10:
			win += fills
	for x in range(10):
		var fills = []
		for y in range(10):
			var n = get_node("Blocks/b" + str(x) + str(y))
			if n.Filled:
				fills.append(n)
		if len(fills) == 10:
			win += fills
	
	if not win:
		return 0
	
	for w in win:
		w.Filled = false	
	return int(len(win) * 10) + (len(win) - 10) * 5
