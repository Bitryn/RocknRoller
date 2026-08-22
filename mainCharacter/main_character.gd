extends CharacterBody3D

# player movement
const speed_array = [6,10]
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
	camera = $"../PlayerCam" # get 
	GlobVar.PlayerPos = global_position
	
	GlobSig.ActionModeSwitch.connect(MultiVarSwitch)


func _process(delta: float) -> void:
	GlobVar.PlayerPos = global_position # player position in global
	
	bullet_spawnpoimt = $bullet_spawn.global_transform # get bullet spawnpoint
	
	
	# fliping sprite to move direction
	if GlobVar.WSAD:
		flip_sprite("move_left_WSAD","move_right_WSAD")
	if GlobVar.ARROW:
		flip_sprite("move_left_Arrow","move_right_Arrow")
		
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
	if Input.is_action_just_pressed("Jump") and is_on_floor() and can_move:
		velocity.y = JUMP_VELOCITY
		velocity.x = direction.x * speed/1.8 # slow down player when is in air
	
	if GlobVar.WSAD: # for WSAD controls
		climb("move_up_WSAD","move_down_WSAD","move_left_WSAD","move_right_WSAD") # Climbing
		pick_up("use_WSAD") # pick up item || use item/machine
		use_arbalest("use_WSAD", delta) # shot rock || arbalest
		use_spyglass("use_WSAD") # spyglass
		use_repair("use_WSAD") # repair
	if GlobVar.ARROW: # for ARROW controls
		climb("move_up_Arrow","move_down_Arrow","move_left_Arrow","move_right_Arrow") # Climbing
		pick_up("use_Arrow") # pick up item || use item/machine
		use_arbalest("use_Arrow", delta) # shot rock || arbalest
		use_spyglass("use_Arrow") # spyglass
		use_repair("use_Arrow") # repair
	
	# drop item
	if Input.is_action_just_pressed("drop") and picked:
		picked = false # now is not holding anything
	
	# stop climb when cant move
	if !can_move and (velocity.y > 0 or velocity.y < 0) and climbing:
		velocity.y = 0
	
	move_and_slide()

func MultiVarSwitch():
	repair   = false
	arbalest = false
	spyglass = false
	interact = false
	print("Interacton mode reset")
	match GlobVar.PlayerActionMode: #fix arba spy inter
		1: repair   = true
		2: arbalest = true
		3: spyglass = true
		4: interact = true
	print("Interacton mode set: ", GlobVar.PlayerActionMode)
	
# Fclimbing
func climb(up:String,down:String,left:String,right:String):
		if Input.is_action_pressed(up) and climbing and can_move: # climb up
			velocity.y = 3
		if Input.is_action_pressed(down) and climbing and can_move: # climb down
			velocity.y = -2
		if !Input.is_action_pressed(up) and !Input.is_action_pressed(down) and climbing : # stay on ladder
			velocity.y = 0
		elif Input.is_action_pressed(up) and Input.is_action_pressed(down) and climbing : # stay when 2 buttons is pressed
			velocity.y = 0
		if climbing and !Input.is_action_pressed(left) and !Input.is_action_pressed(right) : # when roller moving player stay in one place when on ladder
			velocity.x = linear_x

# Checking player picking/use zone
func _on_area_3d_body_entered(body: Node3D) -> void:
	# Checking is canister in picking zone
	if body.name.begins_with("Fuel") and can_pick == null: # only take first item in zone
		can_pick = body # set canister node
		
func _on_area_3d_body_exited(body: Node3D) -> void:
	# Checking is canister leave zone
	if body.name.begins_with("Fuel"):
		can_pick = null # nothing to pick

# Fpick up item || use item/machine
func pick_up(input:String):
	if Input.is_action_just_pressed(input) and not can_pick == null and !picked and interact:
		picked = true # set is pickerd
	elif picked and not can_pick == null:
		# setting global position of player to picked item
		can_pick.global_transform.origin.x = global_transform.origin.x
		can_pick.global_transform.origin.y = global_transform.origin.y

# Farbalest
func use_arbalest(input:String,delta):
		if Input.is_action_just_pressed(input) and arbalest and !reload:
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

# Fspyglass
func use_spyglass(input:String):
		if Input.is_action_just_pressed(input) and spyglass:
			if !camera.spyglass: # check spyglass is off
				camera.spyglass = true # set spyglass is on
				camera.CamMode = 'spy' # change camera mode
				camera.ZoomDist = GlobVar.SPYcamDISTANCE # set camera zoom
				camera.Teleport() # move camera to player
				can_move = false # player cant move
				camera.player_pos = [global_position.x,global_position.y] # send player pos for cam borders
			elif camera.spyglass: # if spyglass is on
				camera.spyglass = false # turn off 
				camera.CamMode = "track" # set to follow player
				camera.ZoomDist = GlobVar.DEFcamDISTANCE # set camera zoom
				camera.Teleport() # move camera to player
				can_move = true # player can move
		elif !spyglass and camera.spyglass: # when state for F is change and spyglass is on
			camera.spyglass = false # turn off
			camera.CamMode = "track" # set to follow player
			camera.ZoomDist = GlobVar.DEFcamDISTANCE # set camera zoom
			camera.Teleport() # move camera to player
			can_move = true # player can move

# Frepair
func use_repair(input:String):
		if Input.is_action_pressed(input) and repair:
			# get durability controler
			var dur = $"../Roller/RepairZones" 
			dur.repair(1,$RepairProgress) # repair(power, progressBar)   more power = repair quickly
		else:
			$RepairProgress.visible = false

# Flip sprite
func flip_sprite(left: String, right:String):
		if Input.is_action_just_pressed(right):
			Player_Sprite.flip_h = false
		elif Input.is_action_just_pressed(left):
			Player_Sprite.flip_h = true
