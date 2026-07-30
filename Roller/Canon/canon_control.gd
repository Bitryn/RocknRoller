extends Node3D

@export var canon:Node3D

var player_in = false


func _physics_process(delta: float) -> void:
	
	print($MeshInstance3D2.rotation.x)
	
	if player_in and Input.is_action_pressed("ui_right") and $MeshInstance3D2.rotation.x  < 11.6:
		$MeshInstance3D2.rotation.x += 0.1
		canon.rotationZ = $MeshInstance3D2.rotation.x
		
	if player_in and Input.is_action_pressed("ui_left") and $MeshInstance3D2.rotation.x > -11.6:
		$MeshInstance3D2.rotation.x -= 0.1
		canon.rotationZ = $MeshInstance3D2.rotation.x


func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.name == "MainCharacter":
		player_in = true


func _on_area_3d_body_exited(body: Node3D) -> void:
	if body.name == "MainCharacter":
		player_in = false
