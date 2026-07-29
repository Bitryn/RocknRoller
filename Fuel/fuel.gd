extends RigidBody3D


@export var fuel_value = 0 # fuel inside

# canister script

func _physics_process(delta: float) -> void:
	linear_velocity.y -= 5 * delta # gravity 
