extends Node3D

@export var tank_capacity = 100
@export var tank_progress = 0


var player_in = false
var fuel_in = false
var fuel_node

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	$Node3D.scale.y = tank_progress / tank_capacity
	
func _physics_process(delta: float) -> void:
	
	if player_in and fuel_in and Input.is_action_just_pressed("use"):
		if tank_progress + fuel_node.fuel_value <= tank_capacity:
			tank_progress += fuel_node.fuel_value
			fuel_node.fuel_value = 0


func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.name == "MainCharacter":
		player_in = true
	if body.name.begins_with("Fuel"):
		fuel_in = true
		fuel_node = body

func _on_area_3d_body_exited(body: Node3D) -> void:
	if body.name == "MainCharacter":
		player_in = false
	if body.name.begins_with("Fuel"):
		fuel_in = false
