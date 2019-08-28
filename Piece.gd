tool
extends Node2D

export (String, "1x1", "2x2", "3x3", "Corner", "BigCorner", "L", "RL", "2Line", "3Line", "4Line", "5Line") var Kind = "1x1" setget set_kind
export (String, "0", "90", "180", "270") var Rotation = "0" setget set_rotation
export (String) var Paint = "Cyan"

var kinds = ["1x1", "2x2", "3x3", "Corner", "BigCorner", "L", "RL", "2Line", "3Line", "4Line", "5Line"]
var rotations = ["0", "90", "180", "270"]
var Size = 1
var Active = true setget set_activate

func set_kind(kind):
	Kind = kind
	draw()

func set_rotation(rotation):
	Rotation = rotation
	draw()

func set_activate(value):
	Active = value
	draw()

func do_random():
	var k = randi() % len(kinds)
	var r = randi() % len(rotations)
	self.set_kind(kinds[k])
	self.set_rotation(rotations[r])

func draw():
	var format = ""
	
	if Kind == "1x1":
		format = "x"
		Paint = "Cyan"
	
	elif Kind == "2x2":
		format = "xx_xx";
		Paint = "Green"
	
	elif Kind == "3x3":
		format = "xxx_xxx_xxx";
		Paint = "Blue"
	
	elif Kind == "Corner":
		format = "xx_xo"
		Paint = "Red"
	
	elif Kind == "BigCorner":
		format = "xxx_oox_oox"
		Paint = "Black"
	
	elif Kind == "L":
		format = "ooo_xxx_xoo"
		Paint = "Orange"
	
	elif Kind == "RL":
		format = "ooo_xxx_oox"
		Paint = "Orange"
	
	elif Kind == "2Line":
		format = "ooo_xxo_ooo"
		Paint = "Orange"
	
	elif Kind == "3Line":
		format = "ooo_xxx_ooo"
		Paint = "Blue"
	
	elif Kind == "4Line":
		format = "ooooo_ooooo_xxxxo_ooooo_ooooo"
		Paint = "Red"

	elif Kind == "5Line":
		format = "ooooo_ooooo_xxxxx_ooooo_ooooo"
		Paint = "Yellow"

	var lines = format.split("_")
	Size = len(lines)
	var p = Size - 1
	
	for x in range(5):
		for y in range(5):
			var xx = x
			var yy = y
			if x <= p and y <= p:
				if Rotation == "90":
					xx = p - y
					yy = x
				elif Rotation == "180":
					xx = p -x
					yy = p -y
				elif Rotation == "270":
					xx = y
					yy = p - x

			var enabled = y < len(lines) and x < len(lines[y]) and lines[y][x] == "x"
			block_enabled(xx, yy, enabled, Paint)

func block_enabled(x, y, b, c):
	var block = get_node_or_null("Blocks/b" + str(x) + str(y))
	if not block:
		return
	block.set_visible(b)
	block.set_filled(b)
	block.set_paint(c)
	block.set_actived(Active)

func _ready():
	randomize()
