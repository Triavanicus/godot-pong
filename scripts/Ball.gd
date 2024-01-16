@tool
extends CharacterBody2D

enum Side {LEFT, RIGHT}
signal side_hit(side: Side)

@onready
var collision := $CollisionShape2D

@onready
var rect := $ColorRect

@onready
var audio := $AudioStreamPlayer

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


func set_minimum_speed():
	if absf(movement_vec.x) < 0.2:
		var sign: float
		if movement_vec.x < 0: sign = -1.0
		else: sign = 1.0
		movement_vec.x = 0.25 * sign
		movement_vec = movement_vec.normalized()


func _ready():
	if Engine.is_editor_hint(): return
	
	var viewport := get_viewport_rect()
	min_position = viewport.position
	max_position = viewport.position + viewport.size - Vector2(size)
	resize_rect()
	
	position.y = viewport.position.y + viewport.size.y / 2 - size.y / 2
	movement_vec = Vector2(randf_range(-1, 1), randf_range(-1, 1)).normalized()
	set_minimum_speed()


func play_sound():
	var pitches = [1.0, 0.6, 0.8, 1.2, 1.5]
	var new_pitch = pitches[randi() % len(pitches)]
	while new_pitch == audio.pitch_scale:
		new_pitch = pitches[randi() % len(pitches)]
	audio.pitch_scale = new_pitch
	audio.play()


func _physics_process(delta):
	if Engine.is_editor_hint(): return

	var collision = move_and_collide(movement_vec * movement_speed * delta)
	if collision:
		play_sound()
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
		set_minimum_speed()
	
	position = position.clamp(min_position, max_position)
	if position.y == min_position.y || position.y == max_position.y:
		movement_vec.y *= -1
		play_sound()
	if position.x == min_position.x || position.x == max_position.x:
		play_sound()
		if position.x == min_position.x:
			side_hit.emit(Side.LEFT)
		else: side_hit.emit(Side.RIGHT)
		movement_vec.x *= -1

