@tool 
extends Node2D

@export var Point0 := Node2D
@export var Point1 := Node2D
# ^^^ those can be updated in inspector and the route with stretch in between

@export var rName := "route_name" # is this the current route?



var timed= false #animation timer toggle

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	CurrUpdate()
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
	CurrUpdate()
	#print(Point0.global_position)
	

func CurrUpdate(): #check if route is current
	if not Engine.is_editor_hint(): #spams errors if in editor otherwise
		if GlobVar.CurrRoute == rName:
			$Sprite2D.visible = true
		else : $Sprite2D.visible = false
