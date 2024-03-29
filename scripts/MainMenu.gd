extends Control

var single_game := load("res://scenes/Game.tscn") as PackedScene
var multi_game := load("res://scenes/MultiGame.tscn") as PackedScene
var has_focus := false

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

func _input(event: InputEvent):
	if event.is_released() && !has_focus: 
		($VSplitContainer/VBoxContainer/SingleButton as Button).grab_focus()
		has_focus = !has_focus
