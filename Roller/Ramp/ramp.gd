extends CollisionPolygon3D

@export var close = false
@export var left_ramp = false

var end = false

var time = 0


func _physics_process(delta: float) -> void:
	
	if close and !end:  # ramp close
		if left_ramp:
			rotation.z -= .01
		else:
			rotation.z += .01
	elif !close and !end: # ramp open
		if left_ramp:
			rotation.z += .01
		else:
			rotation.z -= .01

func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.name == "MainCharacter": # check is player touch ramp
		if close: # open ramp when close
			close = false
			end = false
	else: # ramp stop closing
		end = true
		
# Clse ramp
func close_ramp(): 
	if !close:
		close = true
		end = false
		time = 0
