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
	
	if randi_range(0, 1) == 0: dir_x = -1
	else: dir_x = 1
	if randi_range(0, 1) == 0: dir_y = -1
	else: dir_y = 1


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

	var vector = Vector2(dir_x, dir_y) * movement_speed * delta
	var collision = move_and_collide(vector)
	if collision:
		var normal = collision.get_normal()
		if normal.y != 0:
			dir_y = normal.y
		if normal.x != 0:
			dir_x = normal.x
	
	position = position.clamp(min_position, max_position)
	if position.y == min_position.y || position.y == max_position.y:
		dir_y *= -1
	if position.x == min_position.x || position.x == max_position.x:
		dir_x *= -1

