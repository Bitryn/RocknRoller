extends Node3D

@export var canon:Node3D
@onready var bullet_scene = preload("res://Roller/Canon/bullet.tscn")
var bullet_spawn 

@onready var canon_durr = $"../RepairZones"
var broken = false

var player_in = false
var player

var reload = false
var relaod_timer = 0

func _physics_process(delta: float) -> void:
	
	bullet_spawn = canon.bullet_spawn
	
	# canon rotation right
	if player_in and Input.is_action_pressed("ui_right") and $MeshInstance3D2.rotation.x  < 11.6 and !broken:
		$MeshInstance3D2.rotation.x += 0.1
		canon.rotationZ = $MeshInstance3D2.rotation.x
		
	# canon rotation left
	if player_in and Input.is_action_pressed("ui_left") and $MeshInstance3D2.rotation.x > -11.6 and !broken:
		$MeshInstance3D2.rotation.x -= 0.1
		canon.rotationZ = $MeshInstance3D2.rotation.x
		
	if player_in and Input.is_action_just_pressed("use") and player.interact and !broken and !reload:
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
