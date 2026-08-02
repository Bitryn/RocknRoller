extends Area3D

# code for ladder

var can_climb = false
var climb = false
var player

func _on_body_entered(body: Node3D) -> void:
	if body.name == "MainCharacter": # check is player on ladder
		player = body # save player node
		can_climb = true # bool variable
		player.climbing +=1# set player is now climbing
		print("wspina")


func _on_body_exited(body: Node3D) -> void:
	if body.name == "MainCharacter": # check is player leave ladder
		can_climb = false # bool variable
		player.climbing -=1# set player is not climbing
		print("przestaje")

#func _physics_process(delta: float) -> void:
	#if Input.is_action_just_released("use") and can_climb:
		#climb = true
		#player.position.x = position.x
	#elif Input.is_action_just_released("use") and climb:
		#climb = false
