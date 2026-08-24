extends Node3D

@export var RainVec := Vector3(0,-1,0)
@export var Lightning := false

var LightningVec = Vector3(-90,0,0)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if Lightning:
		$Timer.start()
	
	$Drops.process_material.direction = RainVec
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_timer_timeout() -> void:
	LightningVec = Vector3(-90,0,0)
	
	randomize()
	LightningVec.x += randi()%80 #- 40
	randomize()
	LightningVec.y += randi()%360 - 180
	$DirLight.rotation_degrees = LightningVec
	$Anim.play("LightingStrike")
	
	if $Timer.wait_time == 0.5:
		randomize()
		$Timer.wait_time = randi()%10 + 5
	else: $Timer.wait_time = 0.5
	
	print("Lightning Strikes!")
