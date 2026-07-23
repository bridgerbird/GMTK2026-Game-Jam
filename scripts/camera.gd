extends Camera2D

# Config Conversions
var zoom_in = Vector2(GameConfig.zoom_in, GameConfig.zoom_in)
var zoom_out = Vector2(GameConfig.zoom_out, GameConfig.zoom_out)

# Extra zoom effect at the start
# FIXME: Just apply to tutorial stage and maybe a town stage
var initial_zoom_flag = true

# Timer variables
var idle_timer = 0.0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# Zoom out from initial zoom to zoom_in variable
	if initial_zoom_flag:
		zoom = zoom.lerp(zoom_in, GameConfig.initial_lerp_speed)
		if zoom <= zoom_in:
			initial_zoom_flag = false
	
	# Handle Zoom Out for faster speeds
	if abs(get_parent().velocity.x) >= GameConfig.move_speed * 0.6 && zoom > zoom_out:
		zoom = zoom.lerp(zoom_out, GameConfig.zoom_lerp_speed)
	elif get_parent().velocity.x == 0:
		idle_timer += delta

	# Handle Zoom In for idleness
	if idle_timer > GameConfig.zoom_in_wait && zoom < zoom_in:
		zoom = zoom.lerp(zoom_in, GameConfig.zoom_lerp_speed)

	# FIXME: refactor -> better way to implement below
	## every frame, regardless of state, ease actual zoom toward whatever target is currently set
	#camera.zoom = camera.zoom.lerp(target_zoom, zoom_lerp_speed * delta)
