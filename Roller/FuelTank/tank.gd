extends Node3D

@export var tank_capacity = 100
@export var tank_progress = 0

var player

var player_in = false
var fuel_in = false
var fuel_node

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# visualizing remaining fuel in tank
	$Node3D.scale.y = tank_progress / tank_capacity
	
func _physics_process(delta: float) -> void:
	
	# use canister to add fuel to tank
	if GlobVar.WSAD:
		pour_into_tank("use_WSAD")
	if GlobVar.ARROW:
		pour_into_tank("use_Arrow")


func pour_into_tank(input:String):
	if player_in and fuel_in and Input.is_action_just_pressed(input) and player.interact: # check player and cainster in zone | player use 
			if tank_progress + fuel_node.fuel_value <= tank_capacity: # check is added fuel not overflow tank
				tank_progress += fuel_node.fuel_value # add fuel fron canister
				fuel_node.fuel_value = 0 # set canister fuel value

# check what is in tank zone
func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.name == "MainCharacter": # check player is in zone
		player_in = true
		player = body
	if body.name.begins_with("Fuel"): # check canister is in zone
		fuel_in = true
		fuel_node = body # get canister node

func _on_area_3d_body_exited(body: Node3D) -> void:
	if body.name == "MainCharacter": # player leave zone
		player_in = false
	if body.name.begins_with("Fuel"):  # canister leave zone
		fuel_in = false
