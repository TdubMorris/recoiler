class_name triangle_enemy
extends RigidBody2D

@onready var moveHandler := $MovementCPT
@onready var health := $HealthCPT
@onready var animator := $AnimationPlayer

@export var speed := 100

func _ready() -> void:
	global_rotation = randf_range(0, TAU)


func _physics_process(delta: float) -> void:
	moveHandler.rotate_towards_player()
	apply_central_force(50 * transform.x)

func _on_body_entered(body: Node) -> void:
	if body.is_in_group("player"):
		apply_impulse(100 * Vector2.RIGHT.rotated(global_position.angle_to_point(body.global_position) + PI))

func damage(amount:  int):
	health.damage(amount)
	animator.play("damage_flash")


func _on_health_cpt_health_depleted() -> void:
	queue_free()
