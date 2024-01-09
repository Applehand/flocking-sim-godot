extends RigidBody2D
class_name Boid

@onready var visual_range = $VisualRange
@onready var protected_range = $ProtectedRange

@export var min_speed: int = 10
@export var max_speed: int = 50
@export var turning_speed: int = 2
@export var separation_strength: float = 0.05
@export var alignment_strength: float = 0.05
@export var centering_strength: float = 0.005

var boids_in_visual_range: Array[Boid]
var boids_in_protected_range: Array[Boid]


func _physics_process(delta):
	var x_pos_avg: int
	var y_pos_avg: int
	var x_vel_avg: float = 0
	var y_vel_avg: float = 0
	var num_boids_in_vision: int = len(boids_in_visual_range)
	var sep_dist_x: int = 0
	var sep_dist_y: int = 0
	
	# Adding up separation distances for boids within protected range
	for boid in boids_in_protected_range:
		sep_dist_x += self.position.x - boid.position.x
		sep_dist_y += self.position.y - boid.position.y
	
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
	self.linear_velocity.x += sep_dist_x * separation_strength
	self.linear_velocity.y += sep_dist_y * separation_strength
	
	# Alignment velocity calcs
	self.linear_velocity.x += (x_vel_avg - self.linear_velocity.x) * alignment_strength
	self.linear_velocity.y += (y_vel_avg - self.linear_velocity.y) * alignment_strength
	
	# Cohesion velocity calcs
	self.linear_velocity.x += (x_pos_avg - self.position.x) * centering_strength
	self.linear_velocity.y += (y_pos_avg - self.position.y) * centering_strength
	
	# Final position update
	self.position.x = self.position.x + self.linear_velocity.x
	self.position.y = self.position.y + self.linear_velocity.y


func _on_visual_range_entered(boid: Boid) -> void:
	boids_in_visual_range.append(boid)



func _on_visual_range_exited(boid: Boid) -> void:
	boids_in_visual_range.erase(boid)



func _on_protected_range_entered(boid: Boid) -> void:
	boids_in_protected_range.append(boid)



func _on_protected_range_exited(boid: Boid) -> void:
	boids_in_protected_range.erase(boid)
