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
	
	# stop using c0anon
	if GlobVar.WSAD:
		if player_in and Input.is_action_just_pressed("move_down_WSAD") and player.interact:
			player_using = false # player not usnig canon
			player.can_move = true # can move when not using canon
			GlobVar.block_pop = false # unlock pop menu
	if GlobVar.ARROW:
		if player_in and Input.is_action_just_pressed("move_down_Arrow") and player.interact:
			player_using = false # player not usnig canon
			player.can_move = true # can move when not using canon
			GlobVar.block_pop = false # unlock pop menu
	
	# canon rotation right
	if GlobVar.WSAD:
		if player_in and player_using and Input.is_action_pressed("move_right_WSAD") and $MeshInstance3D2.rotation.x  < 11.6 and !broken :
			$MeshInstance3D2.rotation.x += 0.1
			canon.rotationZ = $MeshInstance3D2.rotation.x
	if GlobVar.ARROW:
		if player_in and player_using and Input.is_action_pressed("move_right_Arrow") and $MeshInstance3D2.rotation.x  < 11.6 and !broken :
			$MeshInstance3D2.rotation.x += 0.1
			canon.rotationZ = $MeshInstance3D2.rotation.x
			
	# canon rotation left
	if GlobVar.WSAD:
		if player_in and player_using and Input.is_action_pressed("move_left_WSAD") and $MeshInstance3D2.rotation.x > -11.6 and !broken:
			$MeshInstance3D2.rotation.x -= 0.1
			canon.rotationZ = $MeshInstance3D2.rotation.x
	if GlobVar.ARROW:
		if player_in and player_using and Input.is_action_pressed("move_left_Arrow") and $MeshInstance3D2.rotation.x > -11.6 and !broken:
			$MeshInstance3D2.rotation.x -= 0.1
			canon.rotationZ = $MeshInstance3D2.rotation.x
		
	if GlobVar.WSAD:
		if  Input.is_action_just_pressed("use_WSAD") and player_in and player_using and player.interact and !broken and !reload:
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
	if GlobVar.ARROW:
		if Input.is_action_just_pressed("use_Arrow") and player_in and player_using and player.interact and !broken and !reload:
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
	if GlobVar.WSAD:
		if player_in and Input.is_action_just_pressed("use_WSAD") and player.interact:
			player_using = true # set player is using
			player.can_move = false # cant move while using canon
			GlobVar.block_pop = true # lock pop menu
	if GlobVar.ARROW:
		if player_in and Input.is_action_just_pressed("use_Arrow") and player.interact:
			player_using = true # set player is usi
			player.can_move = false # cant move while using canon
			GlobVar.block_pop = true # lock pop menu
	
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
		


func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.name == "MainCharacter":
		player_in = true
		player = body


func _on_area_3d_body_exited(body: Node3D) -> void:
	if body.name == "MainCharacter":
		player_in = false
