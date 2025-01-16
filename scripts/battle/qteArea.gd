extends ColorRect

class_name QteArea

var actual_arrow_idx : int = 0
var arrow_names : Array = []
var atk_type : String

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Timer.stop()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if self.visible :
		#Si une des inputs nécessaire au qte est appuyée
		if (Input.is_action_just_pressed("arrow_down") 
		or Input.is_action_just_pressed("arrow_left") 
		or Input.is_action_just_pressed("arrow_right") 
		or Input.is_action_just_pressed("arrow_up")):
			#Si l'input appuyée correspond à la fleche actuelle
			if Input.is_action_just_pressed(arrow_names[self.actual_arrow_idx]):
				nextArrow()
			else:
				reset_qte()

func _on_timer_timeout() -> void:
	var timerbar = $TimerBar
	timerbar.value -= 1
	#Si le timer tombe a zéro, suppression du qte et changement de coté
	if timerbar.value == 0:
		get_node("/root/Game/Battle/background").switch_side()
		self.queue_free()

		# Réinitialisation de l'état des boutons
		toggle_buttons(false)

func nextArrow() -> void:
	#récupération de la fleche actuelle
	var actual_arrowTemplate = $qte_container.get_child(self.actual_arrow_idx)
	#Coloration en noir
	actual_arrowTemplate.modulate = Color.html("000000")
	#Changement de d'index pour la fleche actuelle
	self.actual_arrow_idx += 1
	#Si l'index de fleche actuelle correspond à la taille du tableau de fleche
	if self.actual_arrow_idx == self.arrow_names.size():
		var btn = get_node("/root/Game/Battle/background/section-atk/BtnAtkContainer/"+self.atk_type)
		# Réinitialisation de l'état des boutons
		toggle_buttons(false)
		btn.reducePV(btn.damage)
		self.queue_free()


#Réinitisalisation des couleurs de base et retours à l'index 0
func reset_qte() -> void:
	for idx in range(self.actual_arrow_idx):
		var arrow = $qte_container.get_child(idx)
		arrow.modulate = Color.html("ffffff")
	self.actual_arrow_idx = 0
	
func toggle_buttons(areDisabled: bool) -> void:
	var normal_attack_btn = get_node("/root/Game/Battle/background/section-atk/BtnAtkContainer/NormAtk")
	var special_attack_btn = get_node("/root/Game/Battle/background/section-atk/BtnAtkContainer/SpeAtk")
	normal_attack_btn.disabled = areDisabled
	special_attack_btn.disabled = areDisabled
