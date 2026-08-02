extends Area3D

@export var Roller:RigidBody3D
@export var tank:Node3D

var can_use = false
var using = false

var run_engine = 0
var try_run = false
var engine_runnning = false

var max_speed = 0
var gear = 0
var fuel_consumption = [0.001,0.007,0.01,0.07] #per min | 3,6 | 25,2 | 36 | 252 | to calc x*60*60 = per min if _physics_process 60fps

var player

# to detect useable items
func _on_body_entered(body: CharacterBody3D) -> void:
	can_use = true
	if body.name == "MainCharacter":
		player = body
# to detect useable items
func _on_body_exited(body: CharacterBody3D) -> void:
	can_use = false

func _physics_process(delta: float) -> void:
	
	# Shpwing gear on stere
	$CollisionShape3D/MeshInstance3D/Label3D.text = str(gear)
	
	# turn on/off engine 
	if Input.is_action_pressed("use") and can_use and !engine_runnning and player.interact: # odpalanie silnika
		print(run_engine)
		try_run = true
		if run_engine < 2 and !(tank.tank_progress == -0.0000001 or tank.tank_progress == 0 ) : # odpalasz
			run_engine += 0.1
		elif run_engine >= 2: # po przetrzymaniu silnik zaczyna dzialac
			gear = 0
			engine_runnning = true
			using = true
	elif !Input.is_action_pressed("use") and can_use and try_run: # odpuscisz odpalanie to rozruch od nowa
		try_run = false
		run_engine = 0
	elif Input.is_action_just_pressed("use") and using and engine_runnning and player.interact: # wylaczenie
		engine_turn_off()
	elif Input.is_action_just_pressed("use") and engine_runnning and not using and player.interact: # uzycie kiedy silnik dziala
		using = true
	elif !can_use: # jak odejdzisz nie uzywasz silnika
		using = false
	
	# engine running
	if engine_runnning and tank.tank_progress > 0: # have fuel
		tank.tank_progress -= fuel_consumption[abs(gear)] # consume diffrent value on each gear
	elif tank.tank_progress <= 0 and !tank.tank_progress == -0.0000001: # fuel run off
		engine_turn_off() # turn off func
		tank.tank_progress = -0.0000001 # for end engine running check
		
	if !player == null and global_position.distance_to(player.global_position) > 150 :
		engine_turn_off()
	
	# gear switching
	if Input.is_action_just_pressed("move_up") and using and player.interact:
		if gear < 3:
			gear += 1
	if Input.is_action_just_pressed("move_down") and using and player.interact:
		if gear > -1:
			gear -= 1
			
	
	# switch for gears
	match gear:   # force > 1234 roller start moving
		-1: # reverse | wsteczny
			if Roller.force < 1000: # check not going to fast
				if Roller.force > -1200: # set force to move -x
					Roller.force = -1200
				max_speed = -1280 # set max pushing force
				Roller.speed = max_speed # set speed for roller
			else:
				gear = 0 # speed not good set 0
		0: # neutral
			max_speed = 0 # set max pushing force
			Roller.speed = max_speed # set speed for roller
		1:
			if Roller.force > -1000: # check not going to fast
				if Roller.force < 1200:  # set force to move x
					Roller.force = 1200
				max_speed = 1280 # set max pushing force
				Roller.speed = max_speed # set speed for roller
			else:
				gear = 0 # speed not good set 0
		2:
			max_speed = 1340 # set max pushing force
			Roller.speed = max_speed # set speed for roller
		3:
			max_speed = 1400 # set max pushing force
			Roller.speed = max_speed # set speed for roller

func engine_turn_off() -> void: 
	# disable all live function of engine 
	using = false
	engine_runnning = false
	gear = 0
	
