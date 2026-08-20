extends Node3D

# durability [max,current]
var left_wheel_dur = [500,100] # 1
var right_wheel_dur = [500,100] # 2 
var canon_dur = [500,100] # 3 
var ster_dur = [500,100] # 4

var opt = 0

#func _physics_process(delta: float) -> void:
	#print(left_wheel_dur,"  ",right_wheel_dur,"  ",canon_dur,"  ",ster_dur)

func repair(rep_strng: float, progressNode):
	match opt:
		0:
			progressNode.visible = false
			pass
		1:
			if left_wheel_dur[1] <= left_wheel_dur[0]:
				left_wheel_dur[1] += rep_strng
			elif left_wheel_dur[1] > left_wheel_dur[0]:
				left_wheel_dur[1] = left_wheel_dur[0]
			progressNode.max_value = left_wheel_dur[0]
			progressNode.value = left_wheel_dur[1]
			progressNode.visible = true
		2:
			if right_wheel_dur[1] <= right_wheel_dur[0]:
				right_wheel_dur[1] += rep_strng
			elif right_wheel_dur[1] > right_wheel_dur[0]:
				right_wheel_dur[1] = right_wheel_dur[0]
			progressNode.max_value = right_wheel_dur[0]
			progressNode.value = right_wheel_dur[1]
			progressNode.visible = true
		3:
			if canon_dur[1] <= canon_dur[0]:
				canon_dur[1] += rep_strng
			elif canon_dur[1] > canon_dur[0]:
				canon_dur[1] = canon_dur[0]
			progressNode.max_value = canon_dur[0]
			progressNode.value = canon_dur[1]
			progressNode.visible = true
		4:
			if ster_dur[1] <= ster_dur[0]:
				ster_dur[1] += rep_strng
			elif ster_dur[1] > ster_dur[0]:
				ster_dur[1] = ster_dur[0]
			progressNode.max_value = ster_dur[0]
			progressNode.value = ster_dur[1]
			progressNode.visible = true


func _on_left_wheel_body_entered(body: Node3D) -> void:
	if body.name == "MainCharacter":
		opt = 1

func _on_right_wheel_body_entered(body: Node3D) -> void:
	if body.name == "MainCharacter":
		opt = 2

func _on_canon_body_entered(body: Node3D) -> void:
	if body.name == "MainCharacter":
		opt = 3

func _on_ster_body_entered(body: Node3D) -> void:
	if body.name == "MainCharacter":
		opt = 4



func _on_left_wheel_body_exited(body: Node3D) -> void:
	if body.name == "MainCharacter":
		opt = 0

func _on_right_wheel_body_exited(body: Node3D) -> void:
	if body.name == "MainCharacter":
		opt = 0

func _on_canon_body_exited(body: Node3D) -> void:
	if body.name == "MainCharacter":
		opt = 0

func _on_ster_body_exited(body: Node3D) -> void:
	if body.name == "MainCharacter":
		opt = 0
