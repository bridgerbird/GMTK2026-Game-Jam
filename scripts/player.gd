extends CharacterBody2D

@onready var animated_sprite = $AnimatedSprite2D

var jumps = GameConfig.number_of_jumps

# Updates and Starts playing the correct animation
func update_animation(animation_state):
	# Flip directions
	if velocity.x < 0:
		animated_sprite.flip_h = true
	elif velocity.x > 0:
		animated_sprite.flip_h = false
	
	# Only calls .play() on change, not every frame
	if animated_sprite.animation != animation_state:
		animated_sprite.play(animation_state)

func handle_normal_movement(delta):
	# Add gravity to player.
	if not is_on_floor():
		# Beginning of jump, use ascend_gravity
		if velocity.y < -GameConfig.float_threshold:
			velocity.y += GameConfig.ascend_gravity * delta
			update_animation("jump")
		# End of jump (the fall), use descend_gravity
		elif velocity.y > GameConfig.float_threshold:
			velocity.y += GameConfig.descend_gravity * delta
			update_animation("fall")
		# Middle of jump (between negative and positive float_threshold)
		#	use float_gravity
		else:
			velocity.y += GameConfig.float_gravity * delta
			update_animation("jump_peak")
	
	# Remove a jump if fell off edge
	#	without it, you can still jump after falling
	if not is_on_floor() and jumps == GameConfig.number_of_jumps:
		jumps -= 1
	
	# Restore jumps on ground impact
	if is_on_floor() and jumps != GameConfig.number_of_jumps:
		jumps = GameConfig.number_of_jumps
		update_animation("land_on_ground")
	# Handle player jump.
	if Input.is_action_just_pressed("jump") and jumps > 0:
		jumps -= 1
		velocity.y = GameConfig.jump_velocity
	
	# Handle partial jump.
	# multiply jump velocity toward 0 after releasing jump button
	if Input.is_action_just_released("jump") and velocity.y < 0:
		velocity.y *= GameConfig.jump_cut_multiplier
	
	# Get input direction
	var direction = Input.get_axis("move_left", "move_right")
	# Handle movement
	var target_speed
	if Input.is_action_pressed("run"):
		target_speed = direction * GameConfig.run_speed
	else:
		target_speed = direction * GameConfig.walk_speed
	# Switch directions mid-movement
	if direction != 0 and velocity.x * direction < 0:
		velocity.x = direction * GameConfig.turn_speed
	# Accelerate towards target_speed if movement button is being pressed
	elif direction != 0:
		velocity.x = move_toward(velocity.x, target_speed, GameConfig.acceleration * delta)
	# Deceleration
	else:
		velocity.x = move_toward(velocity.x, target_speed, GameConfig.deceleration * delta)
	
	# Handle walking and standing animations excluding while jumping
	if velocity.y == 0 && velocity.x == GameConfig.run_speed:
		update_animation("run")
	elif velocity.y == 0 && velocity.x != 0:
		update_animation("walk")
	elif velocity.y == 0 && velocity.x == 0:
		update_animation("idle")

func _physics_process(delta: float) -> void:
	handle_normal_movement(delta)

	move_and_slide()
