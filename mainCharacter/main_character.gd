extends CharacterBody3D

# player movement
const speed_array = [6,25]
const JUMP_VELOCITY = 6
var speed = 10
var can_move = true
var input_dir
var climbing = 0
var player_z = 0
var linear_x = 0
var velx = 0

# for pick items 
var can_pick = null
var picked = false

#player state on key F
var interact = true
var spyglass = false
var repair = false
var arbalest = false

# shoot variables
var reload = false
var reload_timer = 0
var bullet_spawnpoimt
@onready var bullet_scene = preload("res://Roller/Canon/bullet.tscn")

# camera
var camera

# Player Sprite
@export var Player_Sprite: AnimatedSprite3D

# on start
func _ready() -> void:
	player_z = position.z # get player Z pos
	interact = true # set state for F key
	camera = $"../PlayerCam" # get camera
	
func _process(delta: float) -> void:
	GlobVar.PlayerPos = position # player position in global
	
	bullet_spawnpoimt = $bullet_spawn.global_transform # get bullet spawnpoint
	
	var camera: Camera3D = get_viewport().get_camera_3d() 
	var screen_pos: Vector2 = camera.unproject_position($Node3D.global_position)
	$Control/ColorRect.position = screen_pos
	
	
	# fliping sprite to move direction
	if GlobVar.WSAD:
		if Input.is_action_just_pressed("move_right_WSAD"):
			Player_Sprite.flip_h = false
		elif Input.is_action_just_pressed("move_left_WSAD"):
			Player_Sprite.flip_h = true
	if GlobVar.ARROW:
		if Input.is_action_just_pressed("move_right_Arrow"):
			Player_Sprite.flip_h = false
		elif Input.is_action_just_pressed("move_left_Arrow") :
			Player_Sprite.flip_h = true
		
	position.z = player_z
	
	
	$DEBUG.text = "Ladders collide: " + str(climbing)

func _physics_process(delta: float) -> void:
	velx = velocity.x
	
	
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	if GlobVar.WSAD:
		input_dir = Input.get_vector("move_left_WSAD", "move_right_WSAD", "move_up_WSAD", "move_down_WSAD")
	if GlobVar.ARROW:
		input_dir = Input.get_vector("move_left_Arrow", "move_right_Arrow", "move_up_Arrow", "move_down_Arrow")
	var direction := (transform.basis * Vector3(input_dir.x, 0, 0)).normalized()
	if direction and is_on_floor() and not climbing and can_move : # when normally walking 
		velocity.x = direction.x  * speed
	elif direction and is_on_floor() and  climbing and can_move : # when normally walking next to ladder
		velocity.x = direction.x  * speed
	elif direction and climbing and !is_on_floor() and can_move : # when climbing on ladder
		velocity.x = direction.x * speed/3 + linear_x
	elif is_on_floor() or climbing: # when not moving
		velocity.x = move_toward(velocity.x , 0,  0.11*speed)
	
	# Add the gravity.
	if not is_on_floor():
		if not climbing:
			velocity.y += get_gravity().y * delta
			
		
	
	# sprint
	if reload and arbalest:
		speed = speed_array[0] * .5	
	else:	
		if Input.is_action_pressed("sprint"):
			speed = speed_array[1]
		else:
			speed = speed_array[0]
	
		
	# Handle jump.
	if Input.is_action_just_pressed("Jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		velocity.x = direction.x * speed/1.8 # slow down player when is in air
		
	
	# Climbing
	if GlobVar.WSAD:
		if Input.is_action_pressed("move_up_WSAD") and climbing: # climb up
			velocity.y = 3
		if Input.is_action_pressed("move_down_WSAD") and climbing : # climb down
			velocity.y = -2
		if !Input.is_action_pressed("move_up_WSAD") and !Input.is_action_pressed("move_down_WSAD") and climbing : # stay on ladder
			velocity.y = 0
		elif Input.is_action_pressed("move_up_WSAD") and Input.is_action_pressed("move_down_WSAD") and climbing : # stay when 2 buttons is pressed
			velocity.y = 0
		if climbing and !Input.is_action_pressed("move_left_WSAD") and !Input.is_action_pressed("move_right_WSAD") : # when roller moving player stay in one place when on ladder
			velocity.x = linear_x
	if GlobVar.ARROW:
		if Input.is_action_pressed("move_up_Arrow") and climbing: # climb up
			velocity.y = 3
		if Input.is_action_pressed("move_down_Arrow") and climbing: # climb down
			velocity.y = -2
		if !Input.is_action_pressed("move_up_Arrow") and !Input.is_action_pressed("move_down_Arrow") and climbing: # stay on ladder
			velocity.y = 0
		elif Input.is_action_pressed("move_up_Arrow") and Input.is_action_pressed("move_down_Arrow") and climbing: # stay when 2 buttons is pressed
			velocity.y = 0
		if climbing and !Input.is_action_pressed("move_left_Arrow") and !Input.is_action_pressed("move_right_Arrow"): # when roller moving player stay in one place when on ladder
			velocity.x = linear_x
	
	# pick up item || use item/machine
	if GlobVar.WSAD:
		if Input.is_action_just_pressed("use_WSAD") and not can_pick == null and !picked and interact:
			picked = true # set is pickerd
		elif picked and not can_pick == null:
			# setting global position of player to picked item
			can_pick.global_transform.origin.x = global_transform.origin.x
			can_pick.global_transform.origin.y = global_transform.origin.y
	if GlobVar.ARROW:
		if Input.is_action_just_pressed("use_Arrow") and not can_pick == null and !picked and interact:
			picked = true # set is pickerd
		elif picked and not can_pick == null:
			# setting global position of player to picked item
			can_pick.global_transform.origin.x = global_transform.origin.x
			can_pick.global_transform.origin.y = global_transform.origin.y
	
	# drop item
	if Input.is_action_just_pressed("drop") and picked:
		picked = false # now is not holding anything
	
	
	# arbalest
	if GlobVar.WSAD:
		if Input.is_action_just_pressed("use_WSAD") and arbalest and !reload:
			# shoot 
			var bullet = bullet_scene.instantiate() # get bullet scene
			add_sibling(bullet) # add bullet to world scene
			bullet.global_transform = bullet_spawnpoimt # get position
			var direct = bullet_spawnpoimt.basis * Vector3.FORWARD # get direction
			if Player_Sprite.flip_h == true: # left direction
				direct *= -1
			if Player_Sprite.flip_h == false: # right direction
				direct = abs(direct)
			bullet.linear_velocity = direct * 20 # speed of shooted rock
			reload = true # reload state
		# when reload
		elif reload and arbalest:
			reload_timer += delta # timer
			if reload_timer > 2 : # after 2 sec reloaded
				reload_timer = 0
				reload = false
	if GlobVar.ARROW:
		if Input.is_action_just_pressed("use_Arrow") and arbalest and !reload:
			# shoot 
			var bullet = bullet_scene.instantiate() # get bullet scene
			add_sibling(bullet) # add bullet to world scene
			bullet.global_transform = bullet_spawnpoimt # get position
			var direct = bullet_spawnpoimt.basis * Vector3.FORWARD # get direction
			if Player_Sprite.flip_h == true: # left direction
				direct *= -1
			if Player_Sprite.flip_h == false: # right direction
				direct = abs(direct)
			bullet.linear_velocity = direct * 20 # speed of shooted rock
			reload = true # reload state
		# when reload
		elif reload and arbalest:
			reload_timer += delta # timer
			if reload_timer > 2 : # after 2 sec reloaded
				reload_timer = 0
				reload = false
		
	# spyglass
	if GlobVar.WSAD:
		if Input.is_action_just_pressed("use_WSAD") and spyglass:
			if !camera.spyglass: # check spyglass is off
				camera.spyglass = true # set spyglass is on
				camera.CamMode = 'spy' # change camera mode
				camera.ZoomDist = 24 # set camera zoom
				camera.Teleport() # move camera to player
				can_move = false # player cant move
				camera.player_pos = [global_position.x,global_position.y] # send player pos for cam borders
			elif camera.spyglass: # if spyglass is on
				camera.spyglass = false # turn off 
				camera.CamMode = "track" # set to follow player
				camera.ZoomDist = 18 # set camera zoom
				camera.Teleport() # move camera to player
				can_move = true # player can move
		elif !spyglass and camera.spyglass: # when state for F is change and spyglass is on
			camera.spyglass = false # turn off
			camera.CamMode = "track" # set to follow player
			camera.ZoomDist = 18 # set camera zoom
			camera.Teleport() # move camera to player
			can_move = true # player can move
	if GlobVar.ARROW:
		if Input.is_action_just_pressed("use_Arrow") and spyglass:
			if !camera.spyglass: # check spyglass is off
				camera.spyglass = true # set spyglass is on
				camera.CamMode = 'spy' # change camera mode
				camera.ZoomDist = 24 # set camera zoom
				camera.Teleport() # move camera to player
				can_move = false # player cant move
				camera.player_pos = [global_position.x,global_position.y] # send player pos for cam borders
			elif camera.spyglass: # if spyglass is on
				camera.spyglass = false # turn off 
				camera.CamMode = "track" # set to follow player
				camera.ZoomDist = 18 # set camera zoom
				camera.Teleport() # move camera to player
				can_move = true # player can move
		elif !spyglass and camera.spyglass: # when state for F is change and spyglass is on
			camera.spyglass = false # turn off
			camera.CamMode = "track" # set to follow player
			camera.ZoomDist = 18 # set camera zoom
			camera.Teleport() # move camera to player
			can_move = true # player can move
		
	# repair 
	if GlobVar.WSAD:
		if Input.is_action_pressed("use_WSAD") and repair:
			# get durability controler
			var dur = $"../Roller/RepairZones" 
			dur.repair(1) # repair(power)   more power = repair quickly
	if GlobVar.ARROW:
		if Input.is_action_pressed("use_Arrow") and repair:
			# get durability controler
			var dur = $"../Roller/RepairZones" 
			dur.repair(1) # repair(power)   more power = repair quickly
		
		
	
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

func changeFoption(opt:int) -> void:
	match opt:
		1:
			interact = false
			spyglass = false
			repair = true
			arbalest = false
		2:
			interact = false
			spyglass = false
			repair = false
			arbalest = true
		3:
			interact = false
			spyglass = true
			repair = false
			arbalest = false
		4:
			interact = true
			spyglass = false
			repair = false
			arbalest = false
