extends CharacterBody2D

var jumps = GameConfig.number_of_jumps

func handle_normal_movement(delta):
	# Add gravity to player.
	if not is_on_floor():
		# Beginning of jump, use ascend_gravity
		if velocity.y < -GameConfig.float_threshold:
			velocity.y += GameConfig.ascend_gravity * delta
		# End of jump (the fall), use descend_gravity
		elif velocity.y > GameConfig.float_threshold:
			velocity.y += GameConfig.descend_gravity * delta
		# Middle of jump (between negative and positive float_threshold)
		#	use float_gravity
		else:
			velocity.y += GameConfig.float_gravity * delta
	
	# Restore jumps on ground impact
	if is_on_floor() and jumps != GameConfig.number_of_jumps:
		jumps = GameConfig.number_of_jumps
	# Handle player jump.
	if Input.is_action_just_pressed("jump") and jumps > 0:
		jumps -= 1
		velocity.y = GameConfig.jump_velocity
	
	# Handle partial jump.
	# multiply jump velocity toward 0 after releasing jump button
	if Input.is_action_just_released("jump") and velocity.y < 0:
		velocity.y *= GameConfig.jump_cut_multipier
	
	# Get input direction
	var direction = Input.get_axis("move_left", "move_right")
	# Handle movement
	velocity.x = direction * GameConfig.move_speed

func _physics_process(delta: float) -> void:
	handle_normal_movement(delta)

	move_and_slide()
