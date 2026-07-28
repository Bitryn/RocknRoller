extends CharacterBody3D


const speed_array = [6,25]
const JUMP_VELOCITY = 6

var speed = 10
var input_dir
var climbing = false
var player_z = 0
var linear_x = 0

var can_pick = null
var picked = false

@export var Player_Sprite: AnimatedSprite3D

func _ready() -> void:
	player_z = position.z
	
func _process(delta: float) -> void:
	GlobVar.PlayerPos = position
	#input_dir = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	
	if Input.is_action_just_pressed("move_right") :
		Player_Sprite.flip_h = false
	elif Input.is_action_just_pressed("move_left") :
		Player_Sprite.flip_h = true
		
	position.z = player_z

func _physics_process(delta: float) -> void:
	
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("move_left", "move_right", "move_up", "move_down")
	var direction := (transform.basis * Vector3(input_dir.x, 0, 0)).normalized()
	if direction and is_on_floor() and not climbing:
		velocity.x = direction.x  * speed
	elif direction and is_on_floor() and  climbing:
			velocity.x = direction.x * speed 
	elif direction and climbing and !is_on_floor():
			velocity.x = direction.x  * speed/3 
	elif is_on_floor() or climbing:
		velocity.x = move_toward(velocity.x , 0,  0.11*speed)
	
	# Add the gravity.
	if not is_on_floor():
		if not climbing:
			velocity.y += get_gravity().y * delta
			
		
	
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
		velocity.y = 3
	
	if Input.is_action_pressed("move_down") and climbing:
		velocity.y = -2
	
	if !Input.is_action_pressed("move_up") and !Input.is_action_pressed("move_down") and climbing:
		velocity.y = 0
	elif Input.is_action_pressed("move_up") and Input.is_action_pressed("move_down") and climbing:
		velocity.y = 0
	if climbing and !Input.is_action_pressed("move_left") and !Input.is_action_pressed("move_right"):
		velocity.x = linear_x
	
	if Input.is_action_just_pressed("use") and not can_pick == null and !picked:
		picked = true
	elif picked and not can_pick == null:
		can_pick.global_transform.origin.x = global_transform.origin.x
		can_pick.global_transform.origin.y = global_transform.origin.y
	
	if Input.is_action_just_pressed("drop") and picked:
		picked = false
	
	move_and_slide()


func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.name.begins_with("Fuel") and can_pick == null:
		can_pick = body
		
func _on_area_3d_body_exited(body: Node3D) -> void:
	if body.name.begins_with("Fuel"):
		can_pick = null
