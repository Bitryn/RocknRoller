extends RigidBody3D

var player
var world

var running = false
var speed = 0
var force = 0

var lineax

var poz = 0

@onready var durabilityControl = $RepairZones

func _ready() -> void:
	poz = position.z
	

#func _process(delta: float) -> void:
	#position.z = poz

func _physics_process(delta: float) -> void:
	
	GlobVar.attackable_parts[0] = $CollisionShape3D.global_position
	GlobVar.attackable_parts[1] = $CollisionShape3D3.global_position
	GlobVar.attackable_parts[2] = $Canon.global_position
	
	rotation.x = 0
	rotation.y = 0
	
	force = move_toward(force, speed, 100 * delta) # force in time going up 
	apply_central_force(transform.basis.x * force) # use force to push roller
	lineax = linear_velocity.x # get velocity for player
	
	
	if not player == null:
		player.linear_x = lineax # set roller velocity to variable in player code
	


func _on_area_3d_body_entered(body: CharacterBody3D) -> void:
	if body.name == "MainCharacter": # check is player in roller
		player = body # save player node
		GlobVar.PlayerInRoller = true
		
		
		

func _on_area_3d_body_exited(body: CharacterBody3D) -> void:
	if body.name == "MainCharacter":
		GlobVar.PlayerInRoller = false
