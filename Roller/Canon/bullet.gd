extends RigidBody3D

var bullet_life = 0


func _ready() -> void:
	gravity_scale = 0 # gravity off

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	bullet_life+=delta
	if bullet_life > .7:  # roller length beetwen 0.7 , 0.9
		gravity_scale = 1 # gravilty turn on
	elif bullet_life > 3: # after time destroy bullet
		queue_free()


func _on_area_3d_body_entered(body: Node3D) -> void:
	# signal to body / take dmg or smthing like that
	queue_free() # hit destroy bullet
	
