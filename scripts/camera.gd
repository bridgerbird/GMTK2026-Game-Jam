extends Camera2D

# Config Conversions
var zoom_in = Vector2(GameConfig.zoom_in, GameConfig.zoom_in)
var zoom_out = Vector2(GameConfig.zoom_out, GameConfig.zoom_out)

# Extra zoom effect at the start
# FIXME: Just apply to tutorial stage and maybe a town stage
var initial_zoom_flag = true

# Timer variables
var idle_timer = 0.0

# Target variables
var target_zoom = zoom_in
var target_speed = GameConfig.initial_lerp_speed

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# Zoom out from initial zoom to zoom_in variable
	if initial_zoom_flag:
		target_zoom = zoom_in
		target_speed = GameConfig.initial_lerp_speed
		if zoom <= zoom_in:
			initial_zoom_flag = false
	
	# Handle Zoom Out for faster speeds
	# while moving, check if velocity > 60% of move speed,
	#	then zoom in
	if abs(get_parent().velocity.x) >= GameConfig.move_speed * 0.6:
		target_zoom = zoom_out
		target_speed = GameConfig.zoom_lerp_speed
		# Reset the idle timer here since this is where you start moving again
		idle_timer = 0.0
	# else if idle,
	# 	add to the timer
	elif get_parent().velocity.x == 0:
		idle_timer += delta
	
	# Handle Zoom In for idleness
	# if idle for long enough, then zoom in
	if idle_timer > GameConfig.zoom_in_wait:
		target_zoom = zoom_in
		target_speed = GameConfig.zoom_lerp_speed
	
	# Apply the zoom
	zoom = zoom.lerp(target_zoom, target_speed * delta)
