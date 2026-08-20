extends Node2D

@export var player = CharacterBody3D

var ChosenOpt = 4 # 0 - 4, five positions
# 0 is center - not choosable, 1 right,2 down ...

var Speed = Vector2(0,0)
var sMult = 20

var Active = false

var InDir = 0 #Input Direction

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	visible = false
	InDir = rad_to_deg( GlobVar.InputDir.angle() ) + 45



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	InDir = rad_to_deg( GlobVar.InputDir.angle() ) + 45
	
	if Input.is_action_just_pressed("Switch") and !GlobVar.block_pop:
		visible = !Active
		player.can_move = !player.can_move
		
		if Active && Input.is_action_just_pressed("Switch") && ChosenOpt !=0:
			GlobVar.PlayerActionMode = ChosenOpt
			print("menu chosen Action: ", ChosenOpt)
			GlobSig.ActionModeSwitch.emit()
			
		
		ChosenOpt =0
		Active = !Active
	
	if GlobVar.InputDir.length()>0.3 && Active:
		Choose()
	
	match ChosenOpt:
		0:
			Speed = Vector2(0,0) - $Core/Star.position
		1:
			Speed = $Core/Fix.position - $Core/Star.position
		2:
			Speed = $Core/Arbalet.position - $Core/Star.position
		3:
			Speed = $Core/SpyGlass.position - $Core/Star.position
		4:
			Speed = $Core/Hand.position - $Core/Star.position
		
	
	$Core/Star.position += Speed * delta * sMult
	
	$d.text =  str(InDir) + "  ///  "+ str(ChosenOpt) # str(  rad_to_deg( GlobVar.InputDir.angle() )  )

func Choose():
	if range(0,90).has( int(InDir) ):
		ChosenOpt = 1
	if range(90,180).has( int(InDir) ):
		ChosenOpt = 2
	if range(180, 270).has( int(InDir) )  || range(-180,-90).has( int(InDir) ) :
		ChosenOpt = 3
	if range(-90,0).has( int(InDir) ):
		ChosenOpt = 4
	pass

#func MultiVarSwitch():
	#match GlobVar.PlayerActionMode:
		#1:
			#interact = true
			#spyglass = false
			#repair = false
			#arbalest = false
