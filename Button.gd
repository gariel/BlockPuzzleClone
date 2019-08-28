tool
extends TextureButton

export (String) var Text = "Text" setget set_text, get_text

func set_text(value):
	var label = get_node_or_null("Label")
	if label:
		label.text = value

func get_text():
	var label = get_node("Label")
	if label:
		return label.text
	return ""
