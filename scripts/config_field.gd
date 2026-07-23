extends HBoxContainer

signal value_submitted(text)

@onready var name_label = $NameLabel
@onready var value_edit = $ValueLineEdit

func setup(display_name, initial_value):
	name_label.text = display_name
	value_edit.text = str(initial_value)

func _on_value_line_edit_text_submitted(text):
	value_submitted.emit(text)
	value_edit.release_focus()
