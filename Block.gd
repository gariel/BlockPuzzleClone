tool
extends Node2D

export (bool) var Filled = true setget set_filled
export (bool) var Marked = false setget set_marked
export (bool) var Actived = true setget set_actived
export (String, "Cyan", "Blue", "Red", "Green", "Orange", "Yellow") var Paint = "Cyan" setget set_paint

func set_filled(value):
	Filled = value
	update_color()

func set_marked(value):
	Marked = value
	update_color()

func set_paint(value):
	Paint = value
	update_color()

func set_actived(value):
	Actived = value
	update_color()

func update_color():
	var color = "ffffff"
	if Actived:
		if Filled:
			if Paint == "Cyan": color = "00f9ff"
			elif Paint == "Blue": color = "0081ff"
			elif Paint == "Red": color = "ff0000"
			elif Paint == "Green": color = "14ff00"
			elif Paint == "Orange": color = "ffad00"
			elif Paint == "Yellow": color = "f1ff00"
			elif Paint == "Black": color = "000000"
		elif Marked:
			color = "4a180e"
		else:
			color = "cccccc"
	else:
		color = "888888"
	
	modulate = color
