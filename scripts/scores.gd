extends Control

@onready var label1 = $VBoxContainer/Level1Score
@onready var label2 = $VBoxContainer/Level2Score
@onready var label3 = $VBoxContainer/Level3Score

func format_display_time(seconds):
	var mins = int(seconds) / 60
	var secs = int(seconds) % 60
	var msecs = int((seconds - int(seconds)) * 1000)
	return "%02d:%02d.%02d" % [mins, secs, msecs]

func _ready():
	# Display times
	label1.text = "Level 1: " + format_display_time(GameConfig.level_times.get("Level 1", 0.0))
	label2.text = "Level 2: " + format_display_time(GameConfig.level_times.get("Level 2", 0.0))
	label3.text = "Level 3: " + format_display_time(GameConfig.level_times.get("Level 3", 0.0))
	
	# Adjust font size and color
	label1.add_theme_font_size_override("font_size", 100)
	label1.add_theme_color_override("font_color", Color.GOLD)

	label2.add_theme_font_size_override("font_size", 100)
	label2.add_theme_color_override("font_color", Color.GOLD)

	label3.add_theme_font_size_override("font_size", 100)
	label3.add_theme_color_override("font_color", Color.GOLD)
