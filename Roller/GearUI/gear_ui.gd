extends Sprite3D

var g = 1
var Maxg = 3
var Ming = -1
# ^^^ Gear related values


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if get_parent().using:
		visible = true
	else : visible = false
	g = get_parent().gear
	
	$a.text = str(g+1)
	$a.visible = !(g>=Maxg)
	$b.text = str(g+0)
	$c.text = str(g-1)
	$c.visible = !(g<=Ming)
