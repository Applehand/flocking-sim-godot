extends CharacterBody2D

@onready var sprite_2d = $Sprite2D

@export var speed = 400

var mouse_pos = null
var can_move: bool = false


func _physics_process(_delta: float) -> void:
	velocity = Vector2.ZERO
	mouse_pos = get_global_mouse_position()
	if position.distance_to(mouse_pos) > 5 and can_move:
		var direction = (mouse_pos - position).normalized()
		velocity = direction * speed
		move_and_slide()
		
		rotation = lerp_angle(rotation, direction.angle(), 0.75) - deg_to_rad(120)
		
		if mouse_pos.x > position.x:
			sprite_2d.flip_v = true
		else:
			sprite_2d.flip_v = false

