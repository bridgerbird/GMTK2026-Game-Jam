extends CanvasLayer

const ConfigFieldScene = preload("res://scenes/ConfigField.tscn")

# text displays
var fields = [
	{ "property": "walk_speed", "label": "Walk Speed", "tab": "Movement" },
	{ "property": "run_speed", "label": "Run Speed", "tab": "Movement" },
	{ "property": "acceleration", "label": "Acceleration", "tab": "Movement" },
	{ "property": "deceleration", "label": "Deceleration", "tab": "Movement" },	
	{ "property": "turn_speed", "label": "Turn Speed", "tab": "Movement" },	
	{ "property": "jump_velocity", "label": "Jump Velocity", "tab": "Jump" },
	{ "property": "ascend_gravity", "label": "Ascend Gravity", "tab": "Jump" },
	{ "property": "descend_gravity", "label": "Descend Gravity", "tab": "Jump" },
	{ "property": "float_gravity", "label": "Float Gravity", "tab": "Jump" },
	{ "property": "float_threshold", "label": "Float Threshold", "tab": "Jump" },
	{ "property": "jump_cut_multiplier", "label": "Jump Cut Multiplier", "tab": "Jump" },
	{ "property": "number_of_jumps", "label": "Number of Jumps", "tab": "Jump" },
	{ "property": "zoom_in", "label": "Zoom In", "tab": "Camera" },
	{ "property": "initial_lerp_speed", "label": "Initial Lerp Speed", "tab": "Camera" },
	{ "property": "zoom_out", "label": "Zoom Out", "tab": "Camera" },
	{ "property": "zoom_lerp_speed", "label": "Zoom Lerp Speed", "tab": "Camera" },
	{ "property": "zoom_in_wait", "label": "Zoom In Wait", "tab": "Camera" },
	{ "property": "chase_vertical_wait", "label": "Chase Vertical Wait", "tab": "Camera" },
	{ "property": "chase_lerp_speed", "label": "Chase Lerp Speed", "tab": "Camera" }
]

# show the text
func _ready():
	for field in fields:
		var container = get_node("Panel/TabContainer/" + field["tab"])
		var instance = ConfigFieldScene.instantiate()
		container.add_child(instance)
		instance.setup(field["label"], GameConfig.get(field["property"]))
		instance.value_submitted.connect(_on_field_submitted.bind(field["property"]))

func _on_field_submitted(text, property_name):
	GameConfig.set(property_name, float(text))

# Toggle Panel visibility
func _process(_delta):
	if Input.is_action_just_pressed("toggle_debug"):
		visible = !visible
