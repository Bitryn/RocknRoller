extends Node2D

var RouteAimColl = 0
var CurrCollPoint = ""

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#$Aim.position += GlobVar.InputDir * delta * (200 + (300* int(Input.is_action_pressed("sprint") ) ) )
	
	if RouteAimColl:
		$Aim/Spr.modulate = Color(0.988, 0.608, 0.2, 1.0)
	else : $Aim/Spr.modulate = Color(0.573, 0.035, 0.059, 1.0)
	pass

func _physics_process(delta: float) -> void:
	$Aim.velocity =   GlobVar.InputDir * delta * (9000 + (11000* int(Input.is_action_pressed("sprint") )))     
	$Aim.move_and_slide()


func _on_area_area_entered(area: Area2D) -> void:
	if area.is_in_group("MapPoint"):
		RouteAimColl +=1
		CurrCollPoint = area.name


func _on_area_area_exited(area: Area2D) -> void:
	if area.is_in_group("MapPoint"):
		RouteAimColl -=1
