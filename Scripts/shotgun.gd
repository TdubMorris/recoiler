extends Node2D

@onready var bulletScene = preload("res://Scenes/bullet.tscn")

@export var bullet_count = 5
@export var spread = 10
@export var speed = 1000
@export var damping = 20
@export var cooldown = 0.5
@export var recoil = 50
@export var damage = 10

func _ready() -> void:
	$Timer.wait_time = cooldown

func _process(delta: float) -> void:
	if Input.is_action_pressed("fire_weapon"):
		if $Timer.is_stopped():
			for i in range(bullet_count):
				shoot()
			SignalBus._player_recoil.emit(recoil * bullet_count * Vector2.LEFT.rotated(global_rotation))
			$CPUParticles2D.emitting = true
			$Timer.start()
			$ShotgunBarrel/AnimationPlayer.stop()
			$ShotgunBarrel/AnimationPlayer.play("barrel_recoil")

func shoot() -> void:
	if PlayerStats.ammo < 1:
		return
	
	var bullet = bulletScene.instantiate()
	get_tree().root.add_child(bullet)
	bullet.transform = $SpawnLoc.global_transform
	
	bullet.damage = damage
	bullet.speed = speed + 0.1 * speed * randf_range(-1, 1)
	bullet.rotation_degrees += randf_range(-spread, spread)
	bullet.damping = damping
	
	PlayerStats.ammo -= 1
	
