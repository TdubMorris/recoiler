extends Node2D

@export var speed = 1000
@export var damping = 20

func _physics_process(delta: float) -> void:
	
	#bullet movement
	move_local_x(speed * delta)
	speed -= damping
	if speed < 0:
		queue_free()
	
	#collision detection
	$RayCast2D.target_position = Vector2(speed * delta, 0)
	if $RayCast2D.is_colliding():
		queue_free()
	
