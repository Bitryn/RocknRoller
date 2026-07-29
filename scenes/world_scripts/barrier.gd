extends Node3D

@export var player: NodePath
@export var barrier: NodePath
var player_node
var barrier_node
var children_player

# Barrier blocking player to move on position.z
#or be moved by other things

func _ready() -> void:
	# getting all nodes
	player_node = get_node(player)
	barrier_node = get_node(barrier)
	children_player = player_node.get_children()


func _process(delta: float) -> void:
	var ch_p = children_player[0].global_transform.origin # getting player location in world
	barrier_node.global_transform.origin = Vector3(ch_p.x,ch_p.y,0) # setting barrier on player
	
