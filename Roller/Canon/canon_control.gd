extends Node3D

@export var canon:Node3D
@onready var bullet_scene = preload("res://Roller/Canon/bullet.tscn")
var bullet_spawn 

@onready var canon_durr = $"../RepairZones"
var broken = false

var player_in = false
var player
var player_using = false

var reload = false
var relaod_timer = 0

func _physics_process(delta: float) -> void:
	
	bullet_spawn = canon.bullet_spawn
	
	if GlobVar.WSAD: # for WSAD controls
		stop_use_cannon("move_down_WSAD") # stop using c0anon
		rotate_canon_right("move_right_WSAD") # canon rotation right
		rotate_canon_left("move_left_WSAD") # canon rotation left
		cannon_shot("use_WSAD") # shoot a cannon
		use_canon("use_WSAD")# start using canon
		
	if GlobVar.ARROW: # for ARROW controls
		stop_use_cannon("move_down_Arrow") # stop using c0anon
		rotate_canon_right("move_right_Arrow") # canon rotation right
		rotate_canon_left("move_left_Arrow") # canon rotation left
		cannon_shot("use_Arrow") # shoot a cannon
		use_canon("use_Arrow")# start using canon
	
	# when relaoding
	if reload:
		relaod_timer += delta
		if relaod_timer > 2.5: # atfter time
			reload = false # leave relaod state
			relaod_timer = 0 # set timer 0
	
	# canon broken
	if canon_durr.canon_dur[1] < 0 and !canon_durr.canon_dur[1] == 0:
		canon_durr.canon_dur[1] = 0
		broken = true # canon is broken
	elif broken and canon_durr.canon_dur[1] > 0:
		broken = false # canon repaired
		


# stop using c0anon
func stop_use_cannon(input:String):
		if player_in and Input.is_action_just_pressed(input) and player.interact:
			player_using = false # player not usnig canon
			player.can_move = true # can move when not using canon
			GlobVar.block_pop = false # unlock pop menu

# canon rotation right
func rotate_canon_right(input:String):
		if player_in and player_using and Input.is_action_pressed(input) and $MeshInstance3D2.rotation.x  < 11.6 and !broken :
			$MeshInstance3D2.rotation.x += 0.1
			canon.rotationZ = $MeshInstance3D2.rotation.x

	# canon rotation left
func rotate_canon_left(input:String):
		if player_in and player_using and Input.is_action_pressed(input) and $MeshInstance3D2.rotation.x > -11.6 and !broken:
			$MeshInstance3D2.rotation.x -= 0.1
			canon.rotationZ = $MeshInstance3D2.rotation.x
	
# cannon shot 
func cannon_shot(input:String):
			if  Input.is_action_just_pressed(input) and player_in and player_using and player.interact and !broken and !reload:
				print("BOOM")
				canon_durr.canon_dur[1] -= 10  # after shoot durability lose
				# create object
				var bullet = bullet_scene.instantiate() # get bullet scene
				add_sibling(bullet) # add to world scene 
				bullet.global_transform = bullet_spawn # set bullet position
				var direct = bullet_spawn.basis * Vector3.FORWARD # get direction to shoot
				bullet.linear_velocity = direct * 10 # apply force to object
				# set status to reload
				reload = true
				pass

# start using canon
func use_canon(input:String):
		if player_in and Input.is_action_just_pressed(input) and player.interact:
			player_using = true # set player is using
			player.can_move = false # cant move while using canon
			GlobVar.block_pop = true # lock pop menu

func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.name == "MainCharacter":
		player_in = true
		player = body


func _on_area_3d_body_exited(body: Node3D) -> void:
	if body.name == "MainCharacter":
		player_in = false
