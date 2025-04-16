extends RigidBody2D

@onready var anchored: bool = false
@onready var guns = $Guns

signal updateEnemyTarget(position: Vector2)


func _ready() -> void:
	SignalBus.connect("_player_recoil", recoil)


func _process(_delta: float) -> void:
	guns.look_at(get_global_mouse_position())
	$Anchor.global_rotation = 0.0
	
	#camera movement
	var target = get_viewport().get_mouse_position() - get_viewport_rect().size / 2
	$Camera2D.global_position = global_position + 0.2 * target

func _physics_process(delta: float) -> void:
	updateEnemyTarget.emit(global_position)
	
	# anchoring mechanic
	if Input.is_action_just_pressed("anchor"):
		$Anchor.show()
		linear_velocity = Vector2(0,0)
		anchored = true
		freeze = true
	if Input.is_action_just_released("anchor"):
		$Anchor.hide()
		anchored = false
		freeze = false
	
	# rotation with q+e
	if Input.is_action_pressed("rotate_left"):
		angular_velocity = max(angular_velocity - 0.1, -5)
	if Input.is_action_pressed("rotate_right"):
		angular_velocity = min(angular_velocity + 0.1, 5)

# function for pushing player around with recoil
func recoil(direction: Vector2):
	if not anchored:
		apply_impulse(direction)

# obligitory comment congragulating you for reading this
