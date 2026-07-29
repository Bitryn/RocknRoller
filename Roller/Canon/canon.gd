extends Node3D

var rotationZ = rotation.z


func _physics_process(delta: float) -> void:
	rotation.z = rotationZ * -1 * 0.1
