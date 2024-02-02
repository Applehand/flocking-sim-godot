extends Node2D

@onready var left_border = $LeftBorder
@onready var top_border = $TopBorder
@onready var right_border = $RightBorder
@onready var bottom_border = $BottomBorder
@onready var player = $player

@export var num_boids: int = 50

var score: int = 0
var boid_scene: PackedScene = preload("res://scenes/Boid.tscn")


func _ready() -> void:
	var viewport_rect := get_viewport_rect().size
	var player_spawn_pos := Vector2(viewport_rect.x / 2, viewport_rect.y / 3)
	
	left_border.position.y = viewport_rect.y / 2
	top_border.position.x = viewport_rect.x / 2
	right_border.position.x = viewport_rect.x
	right_border.position.y = viewport_rect.y / 2
	bottom_border.position.x = viewport_rect.x / 2
	bottom_border.position.y = viewport_rect.y
	
	left_border.get_node("CollisionShape2D").shape.size.y = viewport_rect.y
	right_border.get_node("CollisionShape2D").shape.size.y = viewport_rect.y
	top_border.get_node("CollisionShape2D").shape.size.x = viewport_rect.x
	bottom_border.get_node("CollisionShape2D").shape.size.x = viewport_rect.x
	
	player.position = player_spawn_pos
	
	spawn_boids(viewport_rect)


func player_ate_boid():
	score += 1
	print('Score: ', score)

func reset_game():
	pass

func spawn_boids(viewport_rect: Vector2):
	for i in range(num_boids):
		var boid: Boid = boid_scene.instantiate()
		add_child(boid)
		
		var boid_spawn_pos := Vector2(randi() % int(viewport_rect.x - 10), randi_range(viewport_rect.y / 2, viewport_rect.y))
		boid.position = boid_spawn_pos
		boid.got_eaten.connect(player_ate_boid)

