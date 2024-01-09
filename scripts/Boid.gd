extends RigidBody2D
class_name Boid


var boids_in_visual_range: Array[Boid]
var boids_in_protected_range: Array[Boid]
@export var min_speed: int = 10
@export var max_speed: int = 50
@export var turning_speed: int = 2


func _on_visual_range_entered(boid: Boid) -> void:
	boids_in_visual_range.append(boid)



func _on_visual_range_exited(boid: Boid) -> void:
	boids_in_visual_range.erase(boid)



func _on_protected_range_entered(boid: Boid) -> void:
	boids_in_protected_range.append(boid)



func _on_protected_range_exited(boid: Boid) -> void:
	boids_in_protected_range.erase(boid)
