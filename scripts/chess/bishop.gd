extends Piece

class_name Bishop

# Variable Titre & Description pour l'attaque normale d'un Fou
var titleAtk : String = "Charge Flash"
var descAtk : String = "À toute vitesse, le Fou fonce sur son adversaire."

# Varible Titre & Description pour l'attaque spéciale d'un Fou
var titleSpeAtk : String = "Danse de la Guinguette"
var descSpeAtk : String = "Pris dans un élan festif, le Fou se met à faire sa danse spéciale dont lui seul connaît le secret."

# PV d'un Fou
var pvMax : int = 250
var pv : int = pvMax

# Dégâts de l'attaque normale & spéciale d'un Fou
var valueAtk : int = 50
var valueSpeAtk : int = 80

var nbAtkSpe : int = 3

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	create_piece(self, "Bishop")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

# fonction de recuperation de toutes les coordonnées possibles pour le fou
#X -> ligne | Y -> colonne
func get_possible_move(actual_x: int, actual_y: int, board: VBoxContainer) -> Array:
	#initialisation de la liste des coordonnées
	var moves_coord = []
	
	# Double boucle sur un périmètre de coordonnées de 2 cases autour de la pièce
	var directions = [Vector2(1, 1), Vector2(1, -1), Vector2(-1, 1), Vector2(-1, -1)]
	
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
				#Si la case aux coordonnées calculées est vide
				if board.get_piece(x, y) == null:
					moves_coord.append(Vector2(x, y))
				
				#Si la case aux coordonnées calculées a une pièce de la couleur opposée
				elif board.get_piece(x, y).isWhite() != board.get_piece(actual_x, actual_y).isWhite():
					moves_coord.append(Vector2(x, y))
					stop = true
				
				#Si la case aux coordonnées calculées a une pièce de la même couleur
				else :
					stop = true
				
	return moves_coord;
