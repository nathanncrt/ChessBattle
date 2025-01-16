extends HBoxContainer

class_name Rank
var rank_index : int
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for i in 8:
		#var pieces = [Tower,Knight,Bishop,King,Queen,Bishop,Knight,Tower]
		var square = Square.new()
		square.x = rank_index
		square.y = i
		
		self.add_child(square)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
