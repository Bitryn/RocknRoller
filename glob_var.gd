extends Node

var RollerPos = Vector3(0,0,0)
var PlayerPos = Vector3(0,0,0)

var InputDir = Vector2(0,0)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	InputDir = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	InputDir = Input.get_vector("move_left", "move_right", "move_up", "move_down")
