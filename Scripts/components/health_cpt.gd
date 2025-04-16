class_name Health extends Node

signal health_change(diff: int)
signal max_health_changed(diff: int)
signal health_depleted

@export var max_health: int = 100 : set = set_max_health, get = get_max_health
@export var invince: bool = false : set = set_invince, get = get_invince

@onready var health: int = max_health

var invince_timer: Timer = null

func set_max_health(new_max: int):
	var clamped_health = 1 if new_max < 1 else new_max
	if not clamped_health == max_health:
		var diff = clamped_health - max_health
		max_health = clamped_health
		if health > max_health:
			health = max_health
		max_health_changed.emit(diff)

func get_max_health() -> int:
	return max_health

func set_health(new_health: int):
	if new_health < health and invince:
		return
	var clamped_health = clampi(new_health, 0, max_health)
	if not clamped_health == health:
		var diff = clamped_health - health
		health = clamped_health
		health_change.emit(diff)
		if health == 0:
			health_depleted.emit()

func get_health() -> int:
	return health

func set_invince(value: bool):
	invince = value

func get_invince() -> bool:
	return invince

func set_invince_timer(time: float):
	if invince_timer == null:
		invince_timer = Timer.new()
		invince_timer.one_shot = true
		add_child(invince_timer)
	if invince_timer.timeout.is_connected(set_invince):
		invince_timer.timeout.disconnect(set_invince)
	invince_timer.wait_time = time
	invince_timer.timeout.connect(set_invince.bind(false))
	invince = true
	invince_timer.start()

func damage(amount: int):
	set_health(health - amount)
