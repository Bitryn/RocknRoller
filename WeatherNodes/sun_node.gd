extends Node3D

@export var  Rotation := Vector2(0,0)
@export var Size := 1.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	rotation_degrees = Vector3(Rotation.y, - Rotation.x,0) # positives give right and up
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func SunSetter():
	pass # recalibrates sun parameters according to position on the map
