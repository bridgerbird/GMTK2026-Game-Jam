extends Node

@onready var BlueTiles = $BlueTiles
@onready var OrangeTiles = $OrangeTiles

var blue_tile_phase = GameConfig.tile_phase["blue"]
var orange_tile_phase = GameConfig.tile_phase["orange"]

# Toggles Phase of Blue and Orange tiles
func toggle_tiles(initialize):
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
	toggle_tiles(true)
