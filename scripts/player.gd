extends CharacterBody2D

@onready var dash_timer: Timer = $DashTimer

@export var speed = 200

var mouse_pos = null


func _ready() -> void:
	speed = 0


func _physics_process(_delta: float) -> void:
	velocity = Vector2.ZERO
	mouse_pos = get_global_mouse_position()
	var direction = (mouse_pos - position).normalized()
	velocity = direction * speed
	move_and_slide()
	
	rotation = lerp_angle(rotation, direction.angle(), 0.75) - deg_to_rad(120)


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("dash"):
		dash_timer.start()
		speed = 350


func _on_dash_timer_timeout() -> void:
	speed = 200


func _on_start_timer_timeout() -> void:
	speed = 200
