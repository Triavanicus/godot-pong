@tool
extends CharacterBody2D
class_name Paddle

@onready
var collision := $CollisionShape2D as CollisionShape2D

@onready
var particles := $GPUParticles2D as GPUParticles2D

@onready var particle_timer = $ParticleTimer as Timer

@onready
var rect := $ColorRect as ColorRect

@export_range(100, 1000)
var movement_speed := 500

@export
var size: Vector2:
	get: return size
	set(value):
		size = value
		resize_rect()

@export
var is_player: bool

enum Player {LEFT, RIGHT}

@export
var player: Player

var min_position: Vector2
var max_position: Vector2

var vector: Vector2

func resize_rect():
	if not rect || not collision: return
	rect.size = size
	(collision.shape as RectangleShape2D).size = size
	collision.position = Vector2(size.x / 2, size.y / 2)


func emit_particles(world_y: float) -> void:
	particle_timer.start()
	particles.emitting = true
	particles.global_position.y = world_y
	


func get_vector() -> Vector2:
	return vector


func _ready():
	if Engine.is_editor_hint(): return
	
	var viewport := get_viewport_rect()
	min_position = viewport.position
	var max_x := viewport.position.x + viewport.size.x - size.x
	var max_y := viewport.position.y + viewport.size.y - size.y
	max_position = Vector2(max_x, max_y)
	resize_rect()
	
	position.y = viewport.position.y + viewport.size.y / 2 - size.y / 2
	
	if player == Player.RIGHT:
		var material := particles.process_material as ParticleProcessMaterial
		material.direction.x *= -1


func _physics_process(delta: float):
	if Engine.is_editor_hint(): return

	vector = Vector2(0.0, 0.0)
	if is_player:
		if player == Player.LEFT:
			if Input.is_action_pressed("move_up"):
				vector.y -= movement_speed
			if Input.is_action_pressed("move_down"):
				vector.y += movement_speed
		if player == Player.RIGHT:
			if Input.is_action_pressed("right_move_up"):
				vector.y -= movement_speed
			if Input.is_action_pressed("right_move_down"):
				vector.y += movement_speed
		move_and_collide(vector * delta)
	if !is_player:
		var ball := get_node("../Ball") as Ball
		var ball_pos: Vector2 = ball.position + (ball.size as Vector2 / 2)
		var pos: Vector2 = position + (size as Vector2 / 2)
		
		var move_delta := movement_speed * delta
		if ball_pos.y < pos.y:
			vector.y = -minf((pos.y - ball_pos.y), move_delta)
		if ball_pos.y > pos.y:
			vector.y = minf((ball_pos.y - pos.y), move_delta)
		move_and_collide(vector)
	
	var viewport_size = get_viewport_rect().size
	position = position.clamp(min_position, max_position)


func _on_particle_timer_timeout():
	particles.emitting = false
