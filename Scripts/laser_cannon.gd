extends Node2D

@export var damage := 5
@export var force := 50

@onready var RayCast = $RayCast2D
@onready var Line = $Line2D
@onready var Particles = $CPUParticles2D
@onready var Cooldown = $Timer 

@onready var is_casting := false
var tween

func _ready():
	Line.width = 0
	Particles.emitting = false

func _process(delta: float) -> void:
	if RayCast.is_colliding():
		Line.points[1] = to_local(RayCast.get_collision_point())
	else:
		Line.points[1] = Vector2(2000,0)

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("fire_weapon"):
		is_casting = true
		appear()
		Particles.emitting = true
	if Input.is_action_just_released("fire_weapon"):
		is_casting = false
		disappear()
		Particles.emitting = false
	
	# check for enemies
	if is_casting and RayCast.get_collider():
		if RayCast.get_collider().is_in_group("enemy"): 
			var enemy = RayCast.get_collider()
			enemy.apply_force(
					force * Vector2.RIGHT.rotated(global_rotation),
					RayCast.get_collision_point() - RayCast.get_collider().position)
			if Cooldown.is_stopped():
				enemy.damage(damage)
				Cooldown.start()
	
	# recoil
	if is_casting:
		SignalBus._player_recoil.emit(3 * Vector2.LEFT.rotated(global_rotation))
	

func appear() -> void:
	if tween:
		tween.kill()
	tween = create_tween()
	tween.tween_property(Line, "width", 5, 0.1)

func disappear() -> void:
	if tween:
		tween.kill()
	tween = create_tween()
	tween.tween_property(Line, "width", 0, 0.1)
