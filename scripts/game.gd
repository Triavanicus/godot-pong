extends Node2D
class_name Game

enum Side {LEFT, RIGHT}

var ball := load("res://scenes/Ball.tscn") as PackedScene
var main_menu := load("res://scenes/MainMenu.tscn") as PackedScene

var left_wins := 0
var right_wins := 0

@export
var left_score: Label
@export
var right_score: Label

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().change_scene_to_packed(main_menu)
	if Input.is_action_just_pressed("ui_focus_next"):
		if Engine.time_scale == 1.0:
			Engine.time_scale = 0.1
		else: Engine.time_scale = 1.0


func _on_ball_side_hit(side: Side):
	if side == Side.RIGHT: left_wins += 1
	else: right_wins += 1
	left_score.text = str(left_wins)
	right_score.text = str(right_wins)
	
	$Ball.queue_free()
	$Ball.name = "DeadBall"
	var new_ball := ball.instantiate() as Ball
	add_child(new_ball)
	new_ball.side_hit.connect(_on_ball_side_hit)
	new_ball.name = "Ball"
