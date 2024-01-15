extends CharacterBody2D

@onready var timer: Timer = $Timer

@export var speed = 200

var mouse_pos = null


func _physics_process(_delta: float) -> void:
	velocity = Vector2.ZERO
	mouse_pos = get_global_mouse_position()
	var direction = (mouse_pos - position).normalized()
	velocity = direction * speed
	move_and_slide()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("dash"):
		timer.start()
		speed = 350



func _on_timer_timeout() -> void:
	speed = 200
