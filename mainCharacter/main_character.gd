extends CharacterBody3D


const SPEED = 5.0
const JUMP_VELOCITY = 4.5

var input_dir

func _process(delta: float) -> void:
	GlobVar.PlayerPos = position
	input_dir = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	
	if input_dir.x >0.4:
		$spr.flip_h = false
	elif input_dir.x <-0.4:
		$spr.flip_h = true

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	#var input_dir := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	
	#input_dir := Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	
	velocity.x = input_dir*delta *400
	
	move_and_slide()
