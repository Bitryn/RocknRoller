extends RigidBody3D

var player_pos
var world

var running = false
var speed = 0
var force = 0


func _physics_process(delta: float) -> void:
	force = move_toward(force, speed, 15 * delta)
	apply_central_force(transform.basis.x * force)
	pass


func _on_area_3d_body_entered(body: CharacterBody3D) -> void:
	print(body)
	#if body.name == "MainCharacter":
		#player_pos = body.global_transform
		#world = body.get_parent()
		#body.get_parent().remove_child(body)
		#$".".add_child(body)
		#body.global_transform = player_pos
		

#func _on_area_3d_body_exited(body: CharacterBody3D) -> void:
	#if body.name == "MainCharacter":
		#player_pos = body.global_transform
		#body.get_parent().remove_child(body)
		#world.add_child(body)
		#body.global_transform = player_pos
