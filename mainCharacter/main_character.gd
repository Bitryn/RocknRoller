extends CharacterBody3D


const speed_array = [10,25]
const JUMP_VELOCITY = 4.5

var speed = 10
var input_dir
@export var Player_Sprite: AnimatedSprite3D

func _process(delta: float) -> void:
	GlobVar.PlayerPos = position
	#input_dir = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	
	if Input.is_action_just_pressed("move_right") :
		Player_Sprite.flip_h = false
	elif Input.is_action_just_pressed("move_left") :
		Player_Sprite.flip_h = true

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity.y += get_gravity().y * delta
	
	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		
	# sprint
	if Input.is_action_pressed("sprint"):
		speed = speed_array[1]
	else:
		speed = speed_array[0]
		
		
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("move_left", "move_right", "move_up", "move_down")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction and is_on_floor():
		velocity.x = direction.x * speed
	elif is_on_floor():
		velocity.x = move_toward(velocity.x, 0, speed)
	
	move_and_slide()
