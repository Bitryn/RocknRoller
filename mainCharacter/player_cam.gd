extends Camera3D


var ZoomDist = 0 #BIT distance of camera from a players 'plane' changes for drama and spyglass usage
var Cam2PlayerPos = Vector3(0,0,0) #BIT difference of positions Player <-> Camera
var CamSpeed = 3
var CamMode = "track" 
var InputDir = Vector2(0,0)
var spyglass = false
####Modes:   #####
#  track -- camera going after the player
#  spy -- camera is in manual control

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	ZoomDist = 20
	Teleport()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	Cam2PlayerPos = GlobVar.PlayerPos - position
	match CamMode:
		"track":
			position +=  Vector3(Cam2PlayerPos.x * CamSpeed * delta, Cam2PlayerPos.y * CamSpeed * delta + .5,0)
		"spy":
			InputDir.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
			InputDir.y = Input.get_action_strength("ui_up") - Input.get_action_strength("ui_down")
			position += Vector3( InputDir.x , InputDir.y,0)*delta  * 50


func Teleport():
	position = Vector3(GlobVar.PlayerPos.x, GlobVar.PlayerPos.y, ZoomDist)
