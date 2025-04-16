extends Node2D

@export var enemies : Array[PackedScene]
@export var count : int = 5
@export var radius : float = 150



func _ready() -> void:
	spawn_enemies()

func spawn_enemies():
	for i in range(count):
		var enemyInstance = enemies.pick_random().instantiate()
		add_child(enemyInstance)
		var r = randf_range(0,radius)
		var theta = randf_range(0, TAU)
		enemyInstance.position = Vector2(r * cos(theta), r * sin(theta))
		
