extends CollisionPolygon3D

@export var close = false

var detected = 0
var end = false

var time = 0


func _physics_process(delta: float) -> void:
	
	if close and !detected and !end:
		rotation.z += .01
	elif !close and !detected and !end:
		rotation.z -= .01
	elif detected:
		rotation.z = rotation.z
		
	if detected and time >5:
		detected = 0
		time = 0
		end = true
	elif time  <= 5:
		time += delta
	elif detected < 0:
		detected += 1
		

func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.name == "MainCharacter": # check is player in roller
		if close:
			close = false
			end = false
		elif !close:
			close = true
			end = false
	else:
		detected +=1


func _on_area_3d_body_exited(body: Node3D) -> void:
	if body.name == "MainCharacter": # check is player in roller
		pass
	else: 
		detected -= 1
