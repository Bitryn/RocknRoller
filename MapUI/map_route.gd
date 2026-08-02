@tool 
extends Node2D

@export var Point0 := Node2D
@export var Point1 := Node2D

var timed= false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Anim.play("wobble")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if !timed:
		$Timer.start()
		timed = true
	
	
	pass

func _draw() -> void:
	draw_line(Point0.position - position, Point1.position - position, Color.AQUAMARINE, 3.5)

func _on_timer_timeout() -> void:
	timed = false
	$Anim.play("wobble")
	queue_redraw()
	#print(Point0.global_position)
	
