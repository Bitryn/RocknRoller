extends Node3D

@export var canon:Node3D
@onready var bullet_scene = preload("res://Roller/Canon/bullet.tscn")
var bullet_spawn 

var player_in = false
var player


func _physics_process(delta: float) -> void:
	
	bullet_spawn = canon.bullet_spawn
	
	if player_in and Input.is_action_pressed("ui_right") and $MeshInstance3D2.rotation.x  < 11.6:
		$MeshInstance3D2.rotation.x += 0.1
		canon.rotationZ = $MeshInstance3D2.rotation.x
		
	if player_in and Input.is_action_pressed("ui_left") and $MeshInstance3D2.rotation.x > -11.6:
		$MeshInstance3D2.rotation.x -= 0.1
		canon.rotationZ = $MeshInstance3D2.rotation.x
		
	if player_in and Input.is_action_just_pressed("use") and player.interact:
		print("BOOM")
		# create object
		var bullet = bullet_scene.instantiate()
		add_sibling(bullet)
		bullet.global_transform = bullet_spawn
		var direct = bullet_spawn.basis * Vector3.FORWARD
		bullet.linear_velocity = direct * 10
		# apply force to object
		# set status to reload
		pass
	


func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.name == "MainCharacter":
		player_in = true
		player = body


func _on_area_3d_body_exited(body: Node3D) -> void:
	if body.name == "MainCharacter":
		player_in = false
