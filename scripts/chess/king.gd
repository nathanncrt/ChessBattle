extends Piece

class_name King

# Variable Titre & Description pour l'attaque normale d'un Roi
var titleAtk : String = "Gifle Royal"
var descAtk : String = "Le Roi donne une gifle à son adversaire"

# Varible Titre & Description pour l'attaque spéciale d'un Roi
var titleSpeAtk : String = "Coup de canne"
var descSpeAtk : String = "Le Roi écrase sa canne sur le son adversaire"

# PV d'un Roi
var pvMax : int = 500
var pv : int = pvMax

var nbAtkSpe : int = 10

# Dégâts de l'attaque normale & spéciale d'un Roi
var valueAtk : int = 30
var valueSpeAtk : int = 50

var has_moved : bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	create_piece(self, "King")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
	
func king_in_check(x: int, y: int, board: VBoxContainer, is_white: bool) -> bool:
	# Si un déplacement est sous menace on interdit le rock
	for i in range(8):
		for j in range(8):
			var piece = board.get_piece(i, j)
			if piece and piece.isWhite() != is_white:
				var moves = piece.get_possible_move(i, j, board)
				if Vector2(x, y) in moves:
					return true
	return false

func can_rock_with_rook(rook_pos_x: int, rook_pos_y: int, board: VBoxContainer) -> bool:
	var rook = board.get_piece(rook_pos_x, rook_pos_y)
	if not rook or !(rook is Rook) or has_moved or rook.has_moved:
		return false
	
	# Espace entre le roi et la tour
	var start_y = min(self.get_parent().y, rook_pos_y)
	var end_y = max(self.get_parent().y, rook_pos_y)
	
	# Si les cases entre le roi et la tour ne sont pas vides, on ne peut pas rock
	for y in range(start_y + 1, end_y):
		if board.get_piece(self.get_parent().x, y):
			return false
	
	# Si le roi est en échec et
	# si les cases qu'il traverse sont menacées, on ne peut pas rock
	var king_x = self.get_parent().x
	if king_in_check(king_x, self.get_parent().y, board, self.isWhite()):
		return false
		
	# Realisation du rock
	# Petit rock
	if rook_pos_y > self.get_parent().y:
		for y in range(self.get_parent().y + 1, self.get_parent().y + 3):
			if king_in_check(king_x, y, board, self.isWhite()):
				return false
	# Grand rock
	else:
		for y in range(self.get_parent().y - 2, self.get_parent().y):
			if king_in_check(king_x, y, board, self.isWhite()):
				return false
	
	return true

# fonction de recuperation de toutes les coordonnées possibles pour le roi
#X -> ligne | Y -> colonne
func get_possible_move(actual_x: int, actual_y: int, board: VBoxContainer) -> Array:
	#initialisation de la liste des coordonnées
	var moves_coord = []
	# Double boucle sur un périmètre de coordonnées de 2 cases autour de la pièce
	var directions = [Vector2(1, 1), Vector2(1, -1), Vector2(-1, 1), Vector2(-1, -1), Vector2(1, 0), Vector2(-1, 0), Vector2(0, 1), Vector2(0, -1)]
	
	#Boucle sur toutes les directions
	for direction in directions:
		
		var x = actual_x + direction.x
		var y = actual_y + direction.y
		
		# Si les coordonnées calculées sont présentes sur le plateau
		if (
			!((x < 0 or x > 7) or (y < 0 or y > 7))
			# Et que la case calculée est vide
			and (
				board.get_piece(x, y) == null
				# Ou que le pion présent est de la couleur adverse
				or !(board.get_piece(x, y).isWhite() == board.get_piece(actual_x, actual_y).isWhite())
			)
		):
			moves_coord.append(Vector2(x, y))

	# Mouvements de roque
	# Une case de plus pour le roi pour indiquer qu'on peut rock
	if !has_moved:
		# Petit roque
		if can_rock_with_rook(actual_x, 7, board):
			moves_coord.append(Vector2(actual_x, actual_y + 2))
		
		# Grand roque
		if can_rock_with_rook(actual_x, 0, board):
			moves_coord.append(Vector2(actual_x, actual_y - 2))
	
	return moves_coord

# Vérifie et réalise le roque
func check_rocks(new_y: int, board: VBoxContainer) -> void:
	var king_x = self.get_parent().x
	var king_y = self.get_parent().y
	
	# Petit roque
	if new_y > king_y:
		var rook = board.get_piece(king_x, 7)
		if rook:
			rook.get_parent().remove_child(rook)
			board.get_square(king_x, king_y + 1).add_child(rook)
			rook.position.x = 125
			rook.position.y = 80
	# grand roque
	else:
		var rook = board.get_piece(king_x, 0)
		if rook:
			rook.get_parent().remove_child(rook)
			board.get_square(king_x, king_y - 1).add_child(rook)
			rook.position.x = 125
			rook.position.y = 80
	
	# Validation du déplacement
	has_moved = true
