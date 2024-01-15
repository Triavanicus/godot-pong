@tool
extends CharacterBody2D

@onready
var collision := $CollisionShape2D

@onready
var rect := $ColorRect

@export_range(100, 1000)
var movement_speed = 500

var dir_x = 1
var dir_y = 1
var movement_vec: Vector2

@export
var size: Vector2i:
	get: return size
	set(value):
		size = value
		resize_rect()

var min_position: Vector2
var max_position: Vector2

func resize_rect():
	if rect == null || collision == null: return
	rect.size = size
	collision.shape.size = size
	collision.position = Vector2(size.x / 2, size.y / 2)


func _ready():
	if Engine.is_editor_hint(): return
	
	var viewport := get_viewport_rect()
	min_position = viewport.position
	var max_x = viewport.position.x + viewport.size.x - size.x
	var max_y = viewport.position.y + viewport.size.y - size.y
	max_position = Vector2(max_x, max_y)
	resize_rect()
	
	position.y = viewport.position.y + viewport.size.y / 2 - size.y / 2
	movement_vec = Vector2(randf_range(-1, 1), randf_range(-1, 1)).normalized()


func _physics_process(delta):
	if Engine.is_editor_hint(): return

	var collision = move_and_collide(movement_vec * movement_speed * delta)
	if collision:
		var additional:Vector2
		if collision.get_collider().has_method("get_vector"):
			var vec = collision.get_collider().get_vector().normalized()
			movement_speed *= 1.05
			if vec.y == 0:
				if movement_vec.x > 0:
					additional = Vector2(-0.7, 0)
				if movement_vec.x < 0:
					additional = Vector2(0.7, 0)
			if vec.y == -1:
				additional = Vector2(0, -0.7)
			if vec.y == 1:
				additional = Vector2(0, 0.7)
			
		movement_vec = (movement_vec.bounce(collision.get_normal()) + additional).normalized()
		if absf(movement_vec.x) < 0.2:
			var sign: float
			if movement_vec.x < 0: sign = -1.0
			else: sign = 1.0
			movement_vec.x = 0.25 * sign
			movement_vec = movement_vec.normalized()
	
	position = position.clamp(min_position, max_position)
	if position.y == min_position.y || position.y == max_position.y:
		movement_vec.y *= -1
	if position.x == min_position.x || position.x == max_position.x:
		movement_vec.x *= -1

