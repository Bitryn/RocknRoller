extends Node3D

# get object to chase
var player = null
var roller = null
var last_pos_player
var last_pos_roller

# field of view
const FOV_IDLE = 30
const FOV_CHASING = 40

# parts of enemy
@onready var detect_zone = $body/detectZone/CollisionShape3D
@onready var bird_body = $body
@onready var path_progress = $LeftRight/PathFollow3D/Circle/PathFollow3D

# enemy state
var chasing = false
var attacking = false
var returning = false

var bird_attack_speed = 8
var what_chasing = 0   # 1 = roller  2 = player
var what_attack = 0
var what_element = null

var timer = 0

func _physics_process(delta: float) -> void:
	
	# enemy move   attack/returning/idle
	if !attacking and !returning: # idle
		bird_body.global_position = path_progress.global_position # go to point on setted path
	elif attacking: # attack
		if what_attack == 1:
			if roller == null:
				do_attack(delta,last_pos_roller,true)
			if roller !=null:
				do_attack(delta,GlobVar.attackable_parts[what_element],true)
		elif what_attack == 2:
			if player == null:
				do_attack(delta,last_pos_player,false)
			if player !=null:
				do_attack(delta,player.global_position,false)
			if GlobVar.PlayerInRoller:
				returning = true # returninig on
				attacking = false # attacking off
	elif returning: # returninig
		bird_body.global_position = bird_body.global_position.move_toward(path_progress.global_position,10*delta) # fly back to setted path
		if bird_body.global_position.distance_to(path_progress.global_position) < .1: # when near path start idle
			returning = false  # returninig off
	
	# move path progress
	$LeftRight/PathFollow3D.progress_ratio += .02 * delta
	path_progress.progress_ratio += 0.2 * delta
	
	# Chase
	if (player != null or roller != null) and detect_zone.shape.radius == FOV_IDLE: # detect player or roller
		detect_zone.shape.radius = FOV_CHASING # FOV for chasing
		chasing = true # chasing on
	elif player == null and roller == null and detect_zone.shape.radius == FOV_CHASING: # nothing in FOV
		detect_zone.shape.radius = FOV_IDLE # set FOV to normal
		chasing = false # stop chasing
	
	# move main node above player/roller
	if chasing and roller != null:
		global_position.x = move_toward(global_position.x,roller.global_position.x,4*delta) # follow player X
		global_position.y = move_toward(global_position.y,roller.global_position.y + 20,4*delta) # follow player X
		what_chasing = 1
	elif chasing and player != null and roller == null:
		global_position.x = move_toward(global_position.x,player.global_position.x,4*delta) # follow player X
		global_position.y = move_toward(global_position.y,player.global_position.y + 12,4*delta) # follow player X
		what_chasing = 2
	
	# when attack
	if chasing and !attacking and !returning: # only chasing nothing else
		timer += delta
		if timer > 4: # after some time go attack
			what_attack = what_chasing
			what_element = randi_range(0,2)
			timer = 0
			attacking = true # attack ON


# Animation
func _on_flapper_timeout() -> void:
	$body/BirdIdle/AnimationPlayer.play("ArmatureAction")

func do_attack(delta,attackTo,roler:bool):
	bird_body.global_position = bird_body.global_position.move_toward(attackTo,bird_attack_speed*delta) # fly toward last player position
	if bird_body.global_position.distance_to(attackTo) < 1: # when near last player position start returning
		if roler:
			roller.durabilityControl.damage(what_element,false,10)
		returning = true # returninig on
		attacking = false # attacking off

# FOV detect 
func _on_detect_zone_body_entered(body: Node3D) -> void:
	if body.name == "MainCharacter":
		player = body
	if body.name == "Roller":
		roller = body
	pass 

# out of FOV 
func _on_detect_zone_body_exited(body: Node3D) -> void:
	if body.name == "MainCharacter":
		last_pos_player = player.global_position
		player = null
	if body.name == "Roller":
		last_pos_roller = roller.global_position
		roller = null
	pass
