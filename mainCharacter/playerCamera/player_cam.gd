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
	Cam2PlayerPos = GlobVar.PlayerPos
	ZoomDist = 18
	
	Teleport()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	
	Cam2PlayerPos = GlobVar.PlayerPos - position
	Cam2PlayerPos.z = Cam2PlayerPos.z + ZoomDist
	#print(position)
	match CamMode:
		"track":
			position +=  Vector3(Cam2PlayerPos.x * CamSpeed * delta, Cam2PlayerPos.y * CamSpeed * delta + .2,Cam2PlayerPos.z) # przesuniecie wyskosci tutaj w Y
		"spy":
			
			if GlobVar.WSAD:
				spy_mode("move_left_WSAD","move_right_WSAD","move_up_WSAD","move_down_WSAD")
			if GlobVar.ARROW:
				spy_mode("move_left_ARROW","move_right_ARROW","move_up_ARROW","move_down_Arrow")
				
			# moving cam
			position += Vector3( InputDir.x , InputDir.y,0)*delta  * 50


func spy_mode(left:String,right:String,up:String,down:String):
			if player_pos[0] - 70 < global_position.x: #check distance
				if Input.is_action_pressed(left) : # BTN press check
					InputDir.x = -Input.get_action_strength(left) # add minus to move left
			elif InputDir.x < 0: # while BTN not holding nothing moving
				InputDir.x = 0
			
			if  global_position.x < player_pos[0] + 70: #check distance
				if Input.is_action_pressed(right) : # BTN press check
					InputDir.x = Input.get_action_strength(right) # move right
			elif InputDir.x > 0: # while BTN not holding nothing moving
				InputDir.x = 0
			
			# while nothing or both BTN pressed 
			if !Input.get_action_strength(left) and !Input.get_action_strength(right) or Input.get_action_strength(left) and Input.get_action_strength(right):
				InputDir.x = 0

			if player_pos[1] < global_position.y: #check distance
				if Input.is_action_pressed(down) : # BTN press check
					InputDir.y = -Input.get_action_strength(down) # add minus to move down
			elif InputDir.y < 0: # while BTN not holding nothing moving
				InputDir.y = 0
			
			if global_position.y < player_pos[1] + 40: #check distance
				if Input.is_action_pressed(up) : # BTN press check
					InputDir.y = Input.get_action_strength(up) # move up
			elif InputDir.y > 0: # while BTN not holding nothing moving
				InputDir.y = 0
			
			# while nothing or both BTN pressed 
			if !Input.get_action_strength(up) and !Input.get_action_strength(down) or Input.get_action_strength(up) and Input.get_action_strength(down):
				InputDir.y = 0

func Teleport():
	position = Vector3(GlobVar.PlayerPos.x, GlobVar.PlayerPos.y, GlobVar.PlayerPos.y + ZoomDist)
