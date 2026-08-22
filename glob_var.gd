extends Node

var RollerPos = Vector3(0,0,0)
var PlayerPos = Vector3(0,0,0)

const DEFcamDISTANCE = 20
const SPYcamDISTANCE = 26

var PlayerInRoller = false

var InputDir = Vector2(0,0)

var CurrRoutePoints = ["from", "to"] # points in between of which Current route is located on the map
var CurrRoute = ""

var PlayerActionMode = 4 # 1 - 4

var WSAD = true
var ARROW = false
var PAD = false

var block_pop = false

# position of elements enemy can damage
var attackable_parts = [0,1,2] # 0-leftWheel 1-rightWheel 2-canon

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if WSAD:
		InputDir = Input.get_vector("move_left_WSAD", "move_right_WSAD", "move_up_WSAD", "move_down_WSAD")
	if ARROW:
		InputDir = Input.get_vector("move_left_Arrow", "move_right_Arrow", "move_up_Arrow", "move_down_Arrow")
