extends Node2D

var ball: PackedScene = load("res://ball.tscn")

var left_wins = 0
var right_wins = 0

@onready
var left_score := $Container/CenterContainer/LeftScore
@onready
var right_score := $Container/CenterContainer2/RightScore

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_ball_side_hit(side):
	if side == 1: left_wins += 1
	else: right_wins += 1
	left_score.text = str(left_wins)
	right_score.text = str(right_wins)
	
	$Ball.queue_free()
	$Ball.name = "DeadBall"
	var new_ball = ball.instantiate()
	add_child(new_ball)
	new_ball.side_hit.connect(_on_ball_side_hit)
	new_ball.name = "Ball"