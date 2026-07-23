extends CharacterBody2D

@onready var animated_sprite = $AnimatedSprite2D
var jumps = GameConfig.number_of_jumps

# Updates and Starts playing the correct animation
func update_animation(animation_state):
	print(animation_state)
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
		velocity.y *= GameConfig.jump_cut_multipier
	
	# Get input direction
	var direction = Input.get_axis("move_left", "move_right")
	# Handle movement
	velocity.x = direction * GameConfig.move_speed
	# Handle walking and standing animations excluding while jumping
	if velocity.y == 0 && velocity.x != 0:
		update_animation("walk")
	elif velocity.y == 0 && velocity.x == 0:
		update_animation("idle")

func _physics_process(delta: float) -> void:
	handle_normal_movement(delta)

	move_and_slide()
