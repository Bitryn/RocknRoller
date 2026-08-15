extends Area3D

# get ramps 
@onready var rampL = $"../LeftRamp"   
@onready var rampR = $"../RightRamp"

# player variables
var player_in = false
var player

func _physics_process(delta: float) -> void:
	
	# use BTN to close ramps
	if Input.is_action_just_pressed("use_WSAD") and player_in and player.interact or Input.is_action_just_pressed("use_Arrow") and player_in and player.interact:
		rampL.close_ramp()
		rampR.close_ramp()
		pass


func _on_body_entered(body: Node3D) -> void:
	if body.name == "MainCharacter": # check is player next to BTN
		player_in = true
		player = body
		


func _on_body_exited(body: Node3D) -> void:
	if body.name == "MainCharacter": # check is player leave BTN zone
		player_in = false
		
