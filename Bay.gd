extends Node2D

var touch = Vector2(0, 0)
var down = false

func _input(ev):
	if ev is InputEventScreenDrag or ev is InputEventScreenTouch:
		touch = ev.position * 2 - self.position * 2

func _ready():
	_new_piece(0)
	_new_piece(1)
	_new_piece(2)
	
	get_node("AnimationPlayer").play("enter")
	set_process(true)

func _new_piece(index):
	var p = get_node("Pieces/p" + str(index))
	p.do_random()
	
	set_piece_scale(p)

func set_piece_scale(p):
	var size = max(p.Size, 2)
	var scale = 2.0 / size
	var bscale = 1 / scale
	p.scale = Vector2(scale, scale)
	p.get_node("button").scale = Vector2(bscale, bscale)

func reset_piece_scale(p):
	p.scale = Vector2(1, 1)
	p.get_node("button").scale = Vector2(1, 1)
	
func get_pieces():
	return get_node("Pieces").get_children()

export (bool) var Enable = true

signal Hover
signal Position
var collisioned = -1
var dragging = false

# warning-ignore:unused_argument
func _process(delta):
	if not dragging:
		if collisioned > -1 and down:
			var node = get_node("Pieces/p" + str(collisioned))
			if Enable and node.Active:
				dragging = true
				reset_piece_scale(node)
	
	if dragging:
		var node = get_node("Pieces/p" + str(collisioned))
		var pos = to_middle(node, touch)
		
		if down:
			node.set_position(pos)
			emit_signal("Hover", node)
		else:
			dragging = false
			set_piece_scale(node)
			emit_signal("Position", node)
			collisioned = -1

func to_middle(node, pos):
	var middle = node.Size * 110 / 2
	return Vector2(pos.x - middle, pos.y - middle)

func _on_button_down(index):
	down = true
	collisioned = index

# warning-ignore:unused_argument
func _on_button_up(index):
	down = false

func fail_position():
	collisioned = -1
	get_node("AnimationPlayer").play("return")

func success_position():
	if collisioned == 0:
		_swap_block(0, 1)
	if collisioned <= 1:
		_swap_block(1, 2)
	_new_piece(2)
	var new_node = get_node("Pieces/p2")
	new_node.position = Vector2(1200, get_node("Pieces/p0").position.y)
	get_node("AnimationPlayer").play("return")

func _swap_block(index1, index2):
	var piece1 = get_node("Pieces/p" + str(index1))
	var piece2 = get_node("Pieces/p" + str(index2))
	
	piece1.position = piece2.position
	piece1.Kind = piece2.Kind
	piece1.Rotation = piece2.Rotation

	set_piece_scale(piece1)
