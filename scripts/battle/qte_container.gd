extends HBoxContainer

var rng = RandomNumberGenerator.new()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func generate_qte(atk_type: String) -> void:
	var arrows_name = ["arrow_down", "arrow_left", "arrow_right", "arrow_up"]
	var qteArea = $".."
	var nb_arrows_total
	#Si le type d'attaque est l'attaque spéciale
	if atk_type == "SpeAtk":
		#générer un plus grand nombre de fleches
		nb_arrows_total = rng.randi_range(13, 15)
		#Agrandissement de l'interface
		qteArea.custom_minimum_size.x = 3950
		$"../TimerBar".size.x = 596
		$"../TimerBar".max_value = 4
	else:
		nb_arrows_total = rng.randi_range(5, 10)
	for i in range(nb_arrows_total):
		#Séléction aléatoire d'une fleches parmis les 4 directions
		var arrow_rand_name = arrows_name[rng.randi_range(0, arrows_name.size()-1)]
		#Ajout du nom de la fleches dans le tableau en mémoire
		qteArea.arrow_names.append(arrow_rand_name)
		#Création d'un nouveau noeud pour la flèche
		var arrow = ArrowTemplate.new()
		arrow.texture = load("res://assets/img/gui/"+arrow_rand_name+".png")
		self.add_child(arrow)
