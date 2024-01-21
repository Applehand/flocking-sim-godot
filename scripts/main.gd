extends Node2D

@onready var left_border = $LeftBorder
@onready var top_border = $TopBorder
@onready var right_border = $RightBorder
@onready var bottom_border = $BottomBorder
@onready var player = $player

@export var num_boids: int

var boid_scene: PackedScene = preload("res://scenes/Boid.tscn")

func _ready() -> void:
	var window_x: int = get_viewport_rect().size.x
	var window_y: int = get_viewport_rect().size.y
	
	left_border.position.y = window_y / 2
	top_border.position.x = window_x / 2
	right_border.position.x = window_x
	right_border.position.y = window_y / 2
	bottom_border.position.x = window_x / 2
	bottom_border.position.y = window_y
	
	left_border.get_node("CollisionShape2D").shape.size.y = window_y
	right_border.get_node("CollisionShape2D").shape.size.y = window_y
	top_border.get_node("CollisionShape2D").shape.size.x = window_x
	bottom_border.get_node("CollisionShape2D").shape.size.x = window_x
	player.position = Vector2(window_x / 2, window_y / 3)
	
	for i in range(num_boids):
		var boid: Boid = boid_scene.instantiate()
		add_child(boid)
		boid.position = Vector2(randi() % window_x, randi() % window_y)

