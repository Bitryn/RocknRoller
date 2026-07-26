extends Area3D

@export var Roller:RigidBody3D

var can_use = false
var using = false

var run_engine = 0
var try_run = false
var engine_runnning = false

var max_speed = 0

func _on_body_entered(body: Node3D) -> void:
	can_use = true


func _on_body_exited(body: Node3D) -> void:
	can_use = false

func _process(delta: float) -> void:
	
	# turn on/off engine 
	if Input.is_action_pressed("use") and can_use and !engine_runnning: # odpalanie silnika
		print(run_engine)
		try_run = true
		if run_engine < 2: # odpalasz
			run_engine += 0.1
		elif run_engine >= 2: # po przetrzymaniu silnik zaczyna dzialac
			engine_runnning = true
			using = true
	elif !Input.is_action_pressed("use") and can_use and try_run: # odpuscisz odpalanie to rozruch od nowa
		try_run = false
		run_engine = 0
	elif Input.is_action_just_pressed("use") and using and engine_runnning: # wylaczenie
		using = false
		engine_runnning = false
		max_speed = 0
		Roller.speed = max_speed
	elif Input.is_action_just_pressed("use") and engine_runnning and not using: # uzycie kiedy silnik dziala
		using = true
	elif !can_use: # jak odejdzisz nie uzywasz silnika
		using = false
	
	if engine_runnning:
		#print("brrrr  power: " + str(max_speed))
		Roller.speed = max_speed
		
	
	# dostowanie mocy 
	if Input.is_action_pressed("move_up") and using:
		if max_speed < 10000:
			max_speed += .5
	if Input.is_action_pressed("move_down") and using:
		if max_speed > -10000:
			max_speed -= .5
