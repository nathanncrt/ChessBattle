extends Piece

class_name Queen

# Variable Titre & Description pour l'attaque normale d'une Reine
var titleAtk : String = "Regard Perçant"
var descAtk : String = "La Dame fixe son adversaire avec une intensité glaciale, qui lui inflige des dégâts en conséquence."

# Varible Titre & Description pour l'attaque spéciale d'une Reine
var titleSpeAtk : String = "Charme Fatal"
var descSpeAtk : String = "Avec un sourire ensorcelant, la Dame inflige de lourds dégâts à son adversaire."

# PV d'une Reine
var pvMax : int = 500
var pv : int = pvMax

# Dégâts de l'attaque normale & spéciale d'une Reine
var valueAtk : int = 100
var valueSpeAtk : int = 200

var nbAtkSpe : int = 2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	create_piece(self, "Queen")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

# fonction de recuperation de toutes les coordonnées possibles pour le fou
#X -> ligne | Y -> colonne
func get_possible_move(actual_x: int, actual_y: int, board: VBoxContainer) -> Array:
	#initialisation de la liste des coordonnées
	var moves_coord = []
	# Double boucle sur un périmètre de coordonnées de 2 cases autour de la pièce
	var directions = [Vector2(1, 1), Vector2(1, -1), Vector2(-1, 1), Vector2(-1, -1), Vector2(1, 0), Vector2(-1, 0), Vector2(0, 1), Vector2(0, -1)]
	
	#Boucle sur toutes les directions
	for direction in directions:
		#Initialisation des variables calculées à chaque direction
		var stop = false
		var x = actual_x
		var y = actual_y
		while !stop:
			x = x + direction.x
			y = y + direction.y
			#Si les coordonnées calculées sont hors du plateau
			if (x < 0 or x > 7) or (y < 0 or y > 7):
				#Arret de la boucle while
				stop = true
			else :
				var piece = board.get_piece(x, y)
				#Si la case aux coordonnées calculées est vide
				if piece == null:
					moves_coord.append(Vector2(x, y))
				
				#Si la case aux coordonnées calculées a une pièce de la couleur opposée
				elif !(piece.isWhite() == board.get_piece(actual_x, actual_y).isWhite()):
					moves_coord.append(Vector2(x, y))
					stop = true
				
				#Sinon si la case aux coordonnées calculées a une pièce de la même couleur
				else:
					stop = true
	return moves_coord;
