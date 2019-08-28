extends Control

var highscore = load("res://highscore.gd").new()

func _ready():
	var score = highscore.get_score()
	get_node("Score").text = str(score)

func _on_NewGame_pressed():
	get_tree().change_scene("res://Game.tscn")
