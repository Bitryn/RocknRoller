extends Camera3D


var ZoomDist = 0 #BIT distance of camera from a players 'plane' changes for drama and spyglass usage
var Cam2PlayerPos = Vector3(0,0,0) #BIT difference of positions Player <-> Camera
var CamSpeed = 3
var CamMode = "track" 
var InputDir = Vector2(0,0)
var spyglass = false

var player_pos = [0,0]

####Modes:   #####
#  track -- camera going after the player
#  spy -- camera is in manual control

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	ZoomDist = 18
	Teleport()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	
	Cam2PlayerPos = GlobVar.PlayerPos - position
	
	match CamMode:
		"track":
			position +=  Vector3(Cam2PlayerPos.x * CamSpeed * delta, Cam2PlayerPos.y * CamSpeed * delta + .2,0) # przesuniecie wyskosci tutaj w Y
		"spy":
			if player_pos[0] - 70 < global_position.x: #check distance
				if Input.is_action_pressed("ui_left"): # BTN press check
					InputDir.x = -Input.get_action_strength("ui_left") # add minus to move left
			elif InputDir.x < 0: # while BTN not holding nothing moving
				InputDir.x = 0
					
			if  global_position.x < player_pos[0] + 70: #check distance
				if Input.is_action_pressed("ui_right"): # BTN press check
					InputDir.x = Input.get_action_strength("ui_right") # move right
			elif InputDir.x > 0: # while BTN not holding nothing moving
				InputDir.x = 0
			
			# while nothing or both BTN pressed 
			if !Input.get_action_strength("ui_left") and !Input.get_action_strength("ui_right") or Input.get_action_strength("ui_left") and Input.get_action_strength("ui_right"):
				InputDir.x = 0
				
			if player_pos[1] < global_position.y: #check distance
				if Input.is_action_pressed("ui_down"): # BTN press check
					InputDir.y = -Input.get_action_strength("ui_down") # add minus to move down
			elif InputDir.y < 0: # while BTN not holding nothing moving
				InputDir.y = 0
			
			if global_position.y < player_pos[1] + 40: #check distance
				if Input.is_action_pressed("ui_up"): # BTN press check
					InputDir.y = Input.get_action_strength("ui_up") # move up
			elif InputDir.y > 0: # while BTN not holding nothing moving
				InputDir.y = 0
			
			# while nothing or both BTN pressed 
			if !Input.get_action_strength("ui_up") and !Input.get_action_strength("ui_down") or Input.get_action_strength("ui_up") and Input.get_action_strength("ui_down"):
				InputDir.y = 0
			
			# moving cam
			position += Vector3( InputDir.x , InputDir.y,0)*delta  * 50


func Teleport():
	position = Vector3(GlobVar.PlayerPos.x, GlobVar.PlayerPos.y, ZoomDist)
