extends RigidBody2D
class_name Boid

@onready var visual_range = $VisualRange
@onready var protected_range = $ProtectedRange
@onready var label: Label = $Label
@onready var sprite: Sprite2D = $Sprite2D

@export var min_speed: int = 4
@export var max_speed: int = 8
@export var turning_speed: int = 2
@export var separation_strength: float = 0.002
@export var alignment_strength: float = 0.0025
@export var centering_strength: float = 0.0006
@export var player_separation_strength: float = 0.003

var boids_in_visual_range: Array[Boid]
var boids_in_protected_range: Array[Boid]
var player_body: CharacterBody2D


func _physics_process(_delta):
	calculate_position(player_body)
	

func _on_visual_range_entered(body) -> void:
	if body is Boid:
		boids_in_visual_range.append(body)
	if body is CharacterBody2D:
		player_body = body


func _on_visual_range_exited(body) -> void:
	if body is Boid:
		boids_in_visual_range.erase(body)
	if body is CharacterBody2D:
		player_body = null


func _on_protected_range_entered(body) -> void:
	if body is Boid:
		boids_in_protected_range.append(body)


func _on_protected_range_exited(body) -> void:
	if body is Boid:
		boids_in_protected_range.erase(body)


func calculate_position(player_body):
	var x_pos_avg: float = 0
	var y_pos_avg: float = 0
	var x_vel_avg: float = 0
	var y_vel_avg: float = 0
	var num_boids_in_vision: int = len(boids_in_visual_range)
	var sep_dist_x: int = 0
	var sep_dist_y: int = 0
	var player_sep_dist_x: int = 0
	var player_sep_dist_y: int = 0
	
	# Adding up separation distances for boids within protected range
	for boid in boids_in_protected_range:
		sep_dist_x += position.x - boid.position.x
		sep_dist_y += position.y - boid.position.y
	
	# Also avoiding the player, if visible
	if player_body:
		player_sep_dist_x += position.x - player_body.position.x
		player_sep_dist_y += position.y - player_body.position.y
	
	# Getting average positions and velocities for boids in view
	for boid in boids_in_visual_range:
		x_vel_avg += boid.linear_velocity.x
		y_vel_avg += boid.linear_velocity.y
		x_pos_avg += boid.position.x
		y_pos_avg += boid.position.y
	if num_boids_in_vision > 0: # Making sure not to divide by zero if no boids in view
		x_vel_avg = x_vel_avg / num_boids_in_vision
		y_vel_avg = y_vel_avg / num_boids_in_vision
		x_pos_avg = x_pos_avg / num_boids_in_vision
		y_pos_avg = y_pos_avg / num_boids_in_vision

	# Separation velocity calcs
	linear_velocity.x += sep_dist_x * separation_strength
	linear_velocity.y += sep_dist_y * separation_strength
	linear_velocity.x += player_sep_dist_x * player_separation_strength
	linear_velocity.y += player_sep_dist_y * player_separation_strength
	
	# Alignment velocity calcs
	linear_velocity.x += (x_vel_avg - linear_velocity.x) * alignment_strength
	linear_velocity.y += (y_vel_avg - linear_velocity.y) * alignment_strength
	
	# Cohesion velocity calcs
	linear_velocity.x += (x_pos_avg - position.x) * centering_strength
	linear_velocity.y += (y_pos_avg - position.y) * centering_strength
	
	# Speed constraints
	var speed = sqrt(linear_velocity.x*linear_velocity.x + linear_velocity.y*linear_velocity.y)
	if speed > max_speed:
		linear_velocity.x = (linear_velocity.x/speed)*max_speed
		linear_velocity.y = (linear_velocity.y/speed)*min_speed
	if speed < min_speed:
		linear_velocity.x = (linear_velocity.x/speed)*min_speed
		linear_velocity.y = (linear_velocity.y/speed)*min_speed
	
	# Sprite rotation update
	sprite.rotation = lerp_angle(sprite.rotation, linear_velocity.angle(), 0.75)

	# Final position update
	position.x = position.x + linear_velocity.x
	position.y = position.y + linear_velocity.y
	
