
const SAVE_FILE = "user://highscore.save"

func get_score():
	var save_file = File.new()
	if not save_file.file_exists(SAVE_FILE):
		return 0
	save_file.open(SAVE_FILE, File.READ)
	var score = int(save_file.get_line())
	save_file.close()
	return score

func set_score(value):
	var save_file = File.new()
	save_file.open(SAVE_FILE, File.WRITE)
	save_file.store_line(str(value))
	save_file.close()

