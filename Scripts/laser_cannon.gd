extends Node2D

@onready var is_casting := false
var tween

func _ready():
	$Line2D.width = 0
	$CPUParticles2D.emitting = false

func _process(delta: float) -> void:
	if $RayCast2D.is_colliding():
		$Line2D.points[1] = to_local($RayCast2D.get_collision_point())
	else:
		$Line2D.points[1] = Vector2(1000,0)

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("fire_weapon"):
		is_casting = true
		appear()
		$CPUParticles2D.emitting = true
	if Input.is_action_just_released("fire_weapon"):
		is_casting = false
		disappear()
		$CPUParticles2D.emitting = false
	
	if is_casting:
		SignalBus._player_recoil.emit(3 * Vector2.LEFT.rotated(global_rotation))
	

func appear() -> void:
	if tween:
		tween.kill()
	tween = create_tween()
	tween.tween_property($Line2D, "width", 5, 0.1)

func disappear() -> void:
	if tween:
		tween.kill()
	tween = create_tween()
	tween.tween_property($Line2D, "width", 0, 0.1)
