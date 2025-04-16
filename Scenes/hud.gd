extends CanvasLayer

@onready var ammobar := $Control/Ammobar/AmmoBG/AmmoProgress

func _process(delta: float) -> void:
	ammobar.position.x = ammobar.size.x * (1 - PlayerStats.ammo/PlayerStats.max_ammo)
