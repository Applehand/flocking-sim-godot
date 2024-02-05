extends Node2D

@onready var left_border = $LeftBorder
@onready var top_border = $TopBorder
@onready var right_border = $RightBorder
@onready var bottom_border = $BottomBorder
@onready var ui_main = $UICanvas/ui_main
@onready var player = $player
@onready var start_timer = $StartTimer
@onready var end_timer = $EndTimer
@onready var score_timer = $ScoreTimer

@export var num_boids: int = 100

var score: int = 0
var boid_scene: PackedScene = preload("res://scenes/Boid.tscn")
var start_counting_down: bool = false
var end_counting_down: bool = false


func _ready() -> void:
	ui_main.start_game.connect(start_game)
	var viewport_rect := get_viewport_rect().size
	var player_spawn_pos := Vector2(viewport_rect.x / 2, viewport_rect.y / 3)
	player.position = player_spawn_pos


func player_ate_boid():
	score += 1
	ui_main.change_score(score)


func reset_game():
	pass


func spawn_boids(viewport_rect: Vector2):
	for i in range(num_boids):
		var boid: Boid = boid_scene.instantiate()
		add_child(boid)
		
		var boid_spawn_pos := Vector2(randi() % int(viewport_rect.x - 10), randi_range(viewport_rect.y / 2, viewport_rect.y))
		boid.position = boid_spawn_pos
		boid.got_eaten.connect(player_ate_boid)


func set_borders(viewport_rect):
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


func start_game():
	var viewport_rect := get_viewport_rect().size
	set_borders(viewport_rect)
	spawn_boids(viewport_rect)
	start_timer.start()
	start_counting_down = true
	
	
func _process(_delta):
	if start_counting_down:
		ui_main.change_countdown_text(int(start_timer.time_left))
	if end_counting_down:
		if end_timer.time_left < 5:
			ui_main.countdown_label_container.visible = true
			ui_main.change_countdown_text(int(end_timer.time_left))


func _on_start_timer_timeout():
	player.can_move = true
	start_counting_down = false
	ui_main.countdown_label_container.visible = false
	end_timer.start()
	end_counting_down = true


func _on_end_timer_timeout():
	end_counting_down = false
	get_tree().paused = true
	score_timer.start()
	ui_main.change_countdown_text('You bopped ' + str(score) + ' boids!')


func _on_score_timer_timeout():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/main.tscn")
