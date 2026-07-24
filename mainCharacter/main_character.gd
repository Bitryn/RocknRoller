extends CharacterBody3D


const speed_array = [10,25]
const JUMP_VELOCITY = 6

var speed = 10
var input_dir
var climbing = false

@export var Player_Sprite: AnimatedSprite3D

func _process(delta: float) -> void:
	GlobVar.PlayerPos = position
	#input_dir = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	
	if Input.is_action_just_pressed("move_right") :
		Player_Sprite.flip_h = false
	elif Input.is_action_just_pressed("move_left") :
		Player_Sprite.flip_h = true

func _physics_process(delta: float) -> void:
	
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("move_left", "move_right", "move_up", "move_down")
	var direction := (transform.basis * Vector3(input_dir.x, 0, 0)).normalized()
	if direction and is_on_floor() and not climbing:
		velocity.x = direction.x * speed
	elif direction and is_on_floor() and  climbing:
		velocity.x = direction.x * speed
	elif direction and climbing and !is_on_floor():
		velocity.x = direction.x * speed/3
	elif is_on_floor() or climbing:
		velocity.x = move_toward(velocity.x, 0,  0.11*speed)
	
	# Add the gravity.
	if not is_on_floor():
		if not climbing:
			velocity.y += get_gravity().y * delta
			print("dol")
		
	
	# sprint
	if Input.is_action_pressed("sprint"):
		speed = speed_array[1]
	else:
		speed = speed_array[0]
		
		
	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		velocity.x = direction.x * speed/1.8
		
	
	# Climbing
	if Input.is_action_pressed("move_up") and climbing:
		if velocity.y < 3:
			velocity.y += 1 
	if Input.is_action_pressed("move_down") and climbing:
		if velocity.y < 0.1:
			velocity.y -= 0.1
	if !Input.is_action_pressed("move_up") and !Input.is_action_pressed("move_down") and climbing:
		velocity.y = 0
	
	
	move_and_slide()
