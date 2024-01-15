extends Node2D

@export var num_boids: int

var boid_scene: PackedScene = preload("res://scenes/Boid.tscn")
const WINDOW_X: int = 1920
const WINDOW_Y: int = 1080

func _ready() -> void:
	for i in range(num_boids):
		var boid: Boid = boid_scene.instantiate()
		add_child(boid)
		boid.position = Vector2(randi() % WINDOW_X, randi() % WINDOW_Y)

