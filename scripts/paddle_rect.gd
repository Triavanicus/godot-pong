extends ColorRect


# Called when the node enters the scene tree for the first time.
func _ready():
	var parent = get_parent() as CollisionShape2D
	position = parent.position
	size = parent.shape.size
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
