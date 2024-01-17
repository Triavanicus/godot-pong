@tool
extends CharacterBody2D

@onready
var collision := $CollisionShape2D

@onready
var rect := $ColorRect

@export_range(100, 1000)
var movement_speed = 500

@export
var size: Vector2i:
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
	if rect == null || collision == null: return
	rect.size = size
	collision.shape.size = size
	collision.position = Vector2(size.x / 2, size.y / 2)


func get_vector():
	return vector


func _ready():
	if Engine.is_editor_hint(): return
	
	var viewport := get_viewport_rect()
	min_position = viewport.position
	var max_x = viewport.position.x + viewport.size.x - size.x
	var max_y = viewport.position.y + viewport.size.y - size.y
	max_position = Vector2(max_x, max_y)
	resize_rect()
	
	position.y = viewport.position.y + viewport.size.y / 2 - size.y / 2


func _physics_process(delta):
	if Engine.is_editor_hint(): return

	vector = Vector2()
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
		var ball = get_node("../Ball")
		var ball_pos: Vector2 = ball.position + (ball.size as Vector2 / 2)
		var pos: Vector2 = position + (size as Vector2 / 2)
		
		var move_delta = movement_speed * delta
		if ball_pos.y < pos.y:
			vector.y = -min((pos.y - ball_pos.y), move_delta)
		if ball_pos.y > pos.y:
			vector.y = min((ball_pos.y - pos.y), move_delta)
		move_and_collide(vector)
	
	var viewport_size = get_viewport_rect().size
	position = position.clamp(min_position, max_position)

