extends Node

# Level completion timer
var level_time = 0.0
var level_completed = false

# Tile Map Layer Variables
@onready var BlueTiles = $BlueTiles
@onready var OrangeTiles = $OrangeTiles
@onready var GreenZoneTiles = $"CPZ-Tiles"
@onready var TimerTiles = $"TAZ-Tiles"
@onready var InvisibleTiles = $INVISIBLE

@onready var player = $Player

var blue_tile_phase = GameConfig.tile_phase["blue"]
var orange_tile_phase = GameConfig.tile_phase["orange"]

func format_time(seconds):
	var mins = int(seconds) / 60
	var secs = int(seconds) % 60
	var msecs = int((seconds - int(seconds)) * 1000)
	return "%02d:%02d.%03d" % [mins, secs, msecs]

# Toggles Phase of Blue and Orange tiles
func toggle_tiles(initialize = false):
	# On Initialization, only collision and opacity needs updates
	
	# Update variables except on initialization
	if not initialize:
		blue_tile_phase = not blue_tile_phase
		orange_tile_phase = not orange_tile_phase
	
	# Update collision of tiles
	BlueTiles.collision_enabled = blue_tile_phase
	OrangeTiles.collision_enabled = orange_tile_phase
	
	# Update Opaqueness of tiles
	if blue_tile_phase:
		BlueTiles.modulate.a = 1.0
		OrangeTiles.modulate.a = 0.3
	else:
		BlueTiles.modulate.a = 0.3
		OrangeTiles.modulate.a = 1.0

func _ready():
	# Initialize state of Blue and Orange Tiles
	toggle_tiles(true)
	# Turn Timer Zone and Invisible tiles transparent
	TimerTiles.modulate.a = 0.0
	InvisibleTiles.modulate.a = 0.0

func _physics_process(delta):
	# Level Completion Time
	if not level_completed:
		level_time += delta
		$LevelCompletionTime/Label.text = format_time(level_time)
	
	# Controlled Player Zone detection
	var player_cell = GreenZoneTiles.local_to_map(player.global_position)
	var player_in_green = GreenZoneTiles.get_cell_source_id(player_cell) != -1

	# Timer Zone detection
	var timer_cell = TimerTiles.local_to_map(player.global_position)
	var player_in_timer_zone = TimerTiles.get_cell_source_id(timer_cell) != -1
	
	# Toggle Phase shift on button press
	if Input.is_action_just_pressed("toggle_phases"):
		if player_in_green:
			toggle_tiles()
			#reset timer
		# FIXME: Make this an elif once the above is implemented
		elif GameConfig.debug_phase_override:
			toggle_tiles()
	
	# Toggle phase shift at timer end
	# FIXME see above


func _on_level_finished():
	level_completed = true
	print("Level finished in: ", level_time, " seconds")
