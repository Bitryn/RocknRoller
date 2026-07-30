extends CharacterBody3D


const speed_array = [6,25]
const JUMP_VELOCITY = 6

var speed = 10
var input_dir
var climbing = false
var player_z = 0
var linear_x = 0
var velx = 0

var can_pick = null
var picked = false

@export var Player_Sprite: AnimatedSprite3D

func _ready() -> void:
	player_z = position.z
	
func _process(delta: float) -> void:
	GlobVar.PlayerPos = position # player position
	
	# fliping sprite to move direction
	if Input.is_action_just_pressed("move_right") :
		Player_Sprite.flip_h = false
	elif Input.is_action_just_pressed("move_left") :
		Player_Sprite.flip_h = true
		
	position.z = player_z

func _physics_process(delta: float) -> void:
	velx = velocity.x
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("move_left", "move_right", "move_up", "move_down")
	var direction := (transform.basis * Vector3(input_dir.x, 0, 0)).normalized()
	if direction and is_on_floor() and not climbing: # when normally walking 
		velocity.x = direction.x  * speed
	elif direction and is_on_floor() and  climbing: # when normally walking next to ladder
		velocity.x = direction.x  * speed
	elif direction and climbing and !is_on_floor(): # when climbing on ladder
		velocity.x = direction.x * speed/3 + linear_x
	elif is_on_floor() or climbing: # when not moving
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
		velocity.x = direction.x * speed/1.8 # slow down player when is in air
		
	
	# Climbing
	if Input.is_action_pressed("move_up") and climbing: # climb up
		velocity.y = 3
	
	if Input.is_action_pressed("move_down") and climbing: # climb down
		velocity.y = -2
	
	if !Input.is_action_pressed("move_up") and !Input.is_action_pressed("move_down") and climbing: # stay on ladder
		velocity.y = 0
	elif Input.is_action_pressed("move_up") and Input.is_action_pressed("move_down") and climbing: # stay when 2 buttons is pressed
		velocity.y = 0
	if climbing and !Input.is_action_pressed("move_left") and !Input.is_action_pressed("move_right"): # when roller moving player stay in one place when on ladder
		velocity.x = linear_x
	
	# pick up item || use item/machine
	if Input.is_action_just_pressed("use") and not can_pick == null and !picked:
		picked = true # set is pickerd
	elif picked and not can_pick == null:
		# setting global position of player to picked item
		can_pick.global_transform.origin.x = global_transform.origin.x
		can_pick.global_transform.origin.y = global_transform.origin.y
	
	# drop item
	if Input.is_action_just_pressed("drop") and picked:
		picked = false # now is not holding anything
	
	if Input.is_action_just_pressed("Switch"):
		pass
	
	move_and_slide()

# Checking player picking/use zone
func _on_area_3d_body_entered(body: Node3D) -> void:
	# Checking is canister in picking zone
	if body.name.begins_with("Fuel") and can_pick == null: # only take first item in zone
		can_pick = body # set canister node
		
func _on_area_3d_body_exited(body: Node3D) -> void:
	# Checking is canister leave zone
	if body.name.begins_with("Fuel"):
		can_pick = null # nothing to pick
