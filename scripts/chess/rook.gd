extends Piece

class_name Rook

# Variable Titre & Description pour l'attaque normale d'une Tour
var titleAtk : String = "Écrasement"
var descAtk : String = "La Tour s'abat sur son adversaire."

# Varible Titre & Description pour l'attaque spéciale d'une Tour
var titleSpeAtk : String = "No Pasarán!"
var descSpeAtk : String = "La Tour repousse violemment son adversaire."

# PV d'une Tour
var pvMax : int = 300
var pv : int = pvMax

# Dégâts de l'attaque normale & spéciale d'une Tour
var valueAtk : int = 70
var valueSpeAtk : int = 100

var nbAtkSpe : int = 3

var has_moved : bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	create_piece(self, "Rook")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

# Fonction de récuperation de toutes les coordonnées possibles pour la tour
# X -> ligne | Y -> colonne
func get_possible_move(actual_x: int, actual_y: int, board: VBoxContainer) -> Array:
	var moves_coord = []
	# Directions possibles
	var directions = [Vector2(1, 0), Vector2(-1, 0), Vector2(0, 1), Vector2(0, -1)]
	
	# boucle sur les directions
	for direction in directions:
		#Initialisation des variables calculées à chaque direction
		var stop = false
		var x = actual_x
		var y = actual_y
		while !stop:
			x += direction.x
			y += direction.y
			
			#Si les coordonnées calculées sont en dehors du plateau
			if (x < 0 or x > 7) or (y < 0 or y > 7):
				stop = true
			
			#Sinon
			else:
				#récupération de la pièce aux coordonnées calculées
				var piece = board.get_piece(x, y)
				
				#Si il n'y a pas de pièces
				if piece == null:
					moves_coord.append(Vector2(x, y))
				
				#Si pièce adverse
				elif !(piece.isWhite() == board.get_piece(actual_x, actual_y).isWhite()):
					moves_coord.append(Vector2(x, y))
					stop = true
				
				#Si pièce alliée
				else:
					stop = true

	return moves_coord
