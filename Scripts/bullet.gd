extends Node2D

@export var speed = 1000
@export var damping = 20
@export var damage = 10

@onready var RayCast := $RayCast2D

func _physics_process(delta: float) -> void:
	
	#bullet movement
	position += transform.x * speed * delta
	speed -= damping
	if speed < 0:
		queue_free()
	
	#collision detection                  
	RayCast.target_position = Vector2(speed * delta, 0)
	if RayCast.get_collider():
		var collider: Node = RayCast.get_collider()
		if collider.is_in_group("enemy"):
			collider.apply_impulse(
					speed * delta * Vector2.RIGHT.rotated(global_rotation), 
					RayCast.get_collision_point() - collider.global_position)
			if collider.has_method("damage"):
				collider.damage(damage)
		queue_free()
