extends Node

# Level completion timer
var level_time = 0.0
var level_completed = false

# Tile Map Layer Variables
@onready var BlueTiles = $BlueTiles
@onready var OrangeTiles = $OrangeTiles
@onready var GreenZoneTiles = $"CPZ-Tiles"
@onready var TimerTiles = $"TAZ-Tiles"
@onready var Spikes = $SpikeTiles
@onready var InvisibleTiles = $INVISIBLE
@onready var FLAG = $FLAG
# Other Node Variables
@onready var tile_timer = $TilePhaseTimer
@onready var tile_time_label = $TilePhaseTime/Label
@onready var player = $Player

var blue_tile_phase = GameConfig.tile_phase["blue"]
var orange_tile_phase = GameConfig.tile_phase["orange"]

var was_in_timer_zone = false

var last_checkpoint = Vector2.ZERO

# Formats elapsed time into proper time stamp
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

# Respawns player to last checkpoint
func respawn_player():
	player.global_position = last_checkpoint
	player.velocity = Vector2.ZERO

func _ready():
	# Initialize state of Blue and Orange Tiles
	toggle_tiles(true)
	# Initialize Time Zone Label as invisible
	tile_time_label.modulate.a = 0.0
	# Turn Timer Zone and Invisible tiles transparent
	TimerTiles.modulate.a = 0.0
	InvisibleTiles.modulate.a = 0.0
	# Save starting position
	last_checkpoint = player.global_position

func _physics_process(delta):
	# Check for Level completion
	var flag_cell = FLAG.local_to_map(player.global_position)
	var player_at_flag = FLAG.get_cell_source_id(flag_cell) != -1
	
	if player_at_flag and not level_completed:
		#level_completed = true
		_on_level_finished()
	
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
	
	# Edge detection for time zones
	if player_in_timer_zone and not was_in_timer_zone:
		tile_timer.start()
	if not player_in_timer_zone and was_in_timer_zone:
		# Timer fade out effect
		var tween = create_tween()
		tween.tween_property(tile_time_label, "modulate:a", 0.0, 0.3)  # fade in over 0.3s
		# Stop the timer
		tile_timer.stop()
	was_in_timer_zone = player_in_timer_zone
	
	# Display Timer if in a Time zone
	if player_in_timer_zone:
		tile_time_label.modulate.a = 1.0
		tile_time_label.text = str(tile_timer.time_left).pad_decimals(2)
	
	# Pulse Effect on Timer
	var fractional = tile_timer.time_left - int(tile_timer.time_left)
	# fractional becomes anything between 0.999 and 0.0
	tile_time_label.modulate.a = fractional
	
	# Toggle Phase shift on button press
	if Input.is_action_just_pressed("toggle_phases"):
		if player_in_green:
			toggle_tiles()
			tile_timer.start()
		elif GameConfig.debug_phase_override:
			toggle_tiles()
			tile_timer.start()
	
	# Spike Zone detection
	var spike_cell = Spikes.local_to_map(player.global_position)
	var player_touch_spikes = Spikes.get_cell_source_id(spike_cell) != -1
	
	# Green zones reset checkpoint
	if player_in_green:
		last_checkpoint = player.global_position
	
	if player_touch_spikes:
		respawn_player()
	

# Triggers when level is completed
func _on_level_finished():
	level_completed = true
	tile_time_label.modulate.a = 1.0
	tile_time_label.text = str(level_time).pad_decimals(2)
	

# Triggers each time TilePhaseTimer reaches 0
func _on_tile_phase_timer_timeout():
	# Toggle phase shift at timer end
	toggle_tiles()
