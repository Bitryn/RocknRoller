extends Node3D

@export var player: NodePath
@export var barrier: NodePath
var player_node
var barrier_node
var children_player

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player_node = get_node(player)
	barrier_node = get_node(barrier)
	children_player = player_node.get_children()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var ch_p = children_player[0].global_transform.origin
	barrier_node.global_transform.origin = Vector3(ch_p.x,ch_p.y,0)
	
