extends Node2D

var highscore = load("res://highscore.gd").new()

func _ready():
	get_node("AnimationPlayer").play("GameStart")

func _on_Bay_Hover(node):
	var mouse = get_local_mouse_position()
	var board = get_node("Board")
	if mouse.x > board.position.x and \
		mouse.y > board.position.y and \
		mouse.x < board.position.x + 560 and \
		mouse.y < board.position.y + 560:
		board.hover(node)

func _on_Bay_Position(node):
	var board = get_node("Board")
	var bay = get_node("Bay")
	var success = board.set_piece(node)
	if success:
		bay.success_position()
		var points = board.validate()
		if points:
			var score = get_node("Hud/Score")
			score.text = str(int(score.text) + points)
		
		var any = false
		for p in bay.get_pieces():
			p.Active = board.can_position(p)
			any = any or p.Active
		if not any:
			game_over()
		
	else:
		bay.fail_position()

func game_over():
	var score = int(get_node("Hud/Score").text)
	var high = highscore.get_score()
	var bay = get_node("Bay")
	var player = get_node("AnimationPlayer")
	
	bay.Enable = false
	player.play("GameOver")
	if score > high:
		highscore.set_score(score)
		yield(player, "animation_finished")
		player.play("HighScore")

func _on_TextureButton_pressed():
	get_tree().change_scene("res://Menu.tscn")

func _on_GiveUp_pressed():
	get_node("AnimationPlayer").play("GiveUp")

func _on_GiveUp_Yes_pressed():
	game_over()

func _on_GiveUp_No_pressed():
	get_node("AnimationPlayer").play("NoGiveUp")
