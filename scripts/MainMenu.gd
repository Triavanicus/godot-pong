extends Control

var single_game := preload("res://scenes/game.tscn")
var multi_game := preload("res://scenes/multi_game.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_single_button_pressed():
	get_tree().change_scene_to_packed(single_game)


func _on_multi_button_pressed():
	get_tree().change_scene_to_packed(multi_game)


func _on_quit_button_pressed():
	get_tree().quit()
