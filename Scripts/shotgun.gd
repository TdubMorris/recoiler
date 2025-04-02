extends Node2D

@onready var bulletScene = preload("res://Scenes/bullet.tscn")

@export var bullet_count = 5
@export var spread = 10
@export var speed = 1000
@export var damping = 20
@export var cooldown = 0.5

func _ready() -> void:
	$Timer.wait_time = cooldown

func _process(delta: float) -> void:
	if Input.is_action_pressed("shoot"):
		if $Timer.is_stopped():
			for i in range(bullet_count):
				shoot()
			SignalBus._player_recoil.emit(Vector2(250,0).rotated(global_rotation + PI))
			$Timer.start()
			$ShotgunBarrel/AnimationPlayer.stop()
			$ShotgunBarrel/AnimationPlayer.play("barrel_recoil")
			
			

func shoot() -> void:
	var bullet = bulletScene.instantiate()
	get_tree().root.add_child(bullet)
	bullet.transform = $SpawnLoc.global_transform
	
	bullet.speed = speed + randf_range(-0.1 * speed, 0)
	bullet.rotation_degrees += randf_range(-spread, spread)
	bullet.damping = damping
