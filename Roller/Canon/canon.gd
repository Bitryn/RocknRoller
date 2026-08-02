extends Node3D

var rotationZ = rotation.z

var bullet_spawn

func _physics_process(delta: float) -> void:
	bullet_spawn = $BulletSpawn.global_transform
	rotation.z = rotationZ * -1 * 0.1
