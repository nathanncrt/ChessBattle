extends Sprite2D

class_name Piece

var killed = false
var piece_name
var lvl : int = 1

#----------------------------------------------------------------
#A DESCENDRE DANS CHAQUE PIECES (test d'environnement)
# var titleAtk : String = "Charge Flash"
# var descAtk : String = "À toute vitesse, le Fou fonce sur son adversaire."

# var titleSpeAtk : String = "Danse de la Guinguette"
# var descSpeAtk : String = "Pris dans un élan festif, le Fou se met à faire sa danse spéciale dont lui seul connaît le secret."

# var pvMax : int = 200
# var pv : int = pvMax
# var valueAtk : int = 20
# var valueSpeAtk : int = 200
#----------------------------------------------------------------

var white : bool = false

  
func isWhite() :
	return self.white; 
  
func setWhite(is_white):
	self.white = is_white; 
	
func setName(new_name):
	self.piece_name = new_name; 

func isKilled():
	return self.killed; 
	
func setKilled(is_killed):
	self.killed = is_killed; 
 
func create_piece(piece: Node, new_name: String)->void:
	piece.piece_name = new_name
	var color = "white" if piece.isWhite() else "black"
	piece.texture = load("res://assets/img/pieces/"+color+"/chess-"+new_name.to_lower()+"-"+color+".png")

func canMove(_board,_start, _end):
	pass 

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
