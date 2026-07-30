extends RigidBody3D

var bullet_life = 0


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	bullet_life+=delta
	if bullet_life > 3:
		queue_free()
