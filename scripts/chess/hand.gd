extends Sprite2D

class_name Hand


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.scale = Vector2(0.7,0.7)
	self.position.y = -200
	self.position.x = -10
	self.z_index = -1
	self.texture = load("res://assets/img/hand-pinch.png")
	
	var handThumb = Sprite2D.new()
	handThumb.z_index = 1
	handThumb.texture = load("res://assets/img/hand-pinch-thumb.png")
	self.add_child(handThumb) # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
