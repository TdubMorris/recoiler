extends Node

@export var actor: RigidBody2D
@export var force := 20
@export var rotateforce = 500

var player

func _ready() -> void:
	player = get_player()

func get_player() -> Node:
	if get_tree().has_group("player"):
		return get_tree().get_first_node_in_group("player")
	else: return null

func seek_player() -> void:
	actor.apply_central_force(force * Vector2.RIGHT.rotated(actor.global_position.angle_to_point(player.global_position)))

func rotate_towards_player() -> void:
	var direction = (player.global_position - actor.global_position)
	var angleTo = actor.transform.x.angle_to(direction)
	actor.apply_torque(angleTo * rotateforce)
