extends Area3D

var can_climb = false
var climb = false
var player

func _on_body_entered(body: Node3D) -> void:
	if body.name == "MainCharacter":
		player = body
		can_climb = true


func _on_body_exited(body: Node3D) -> void:
	if body.name == "MainCharacter":
		can_climb = false

func _physics_process(delta: float) -> void:
	if Input.is_action_just_released("use") and can_climb:
		climb = true
		player.climbing = true
		player.position.x = position.x
	elif Input.is_action_just_released("use") and climb:
		climb = false
		player.climbing = false
