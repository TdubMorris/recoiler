extends Node

var max_ammo : float = 12
var ammo : float = 12
var reload_speed : float = 3

func _process(delta: float) -> void:
	ammo = min(max_ammo, ammo + reload_speed * delta)
