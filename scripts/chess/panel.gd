extends VBoxContainer

@onready var pieceName: Label = $Name
@onready var lvl: Label = $LVL
@onready var hp: Label = $HP
@onready var attackInfo: HBoxContainer = $AttackInfo

signal displayInfo(piece)
signal resetPanel()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func _on_reset_panel() -> void:
	pieceName.text = ""
	lvl.text = ""
	hp.text = ""
	attackInfo.get_child(0).text = ""
	attackInfo.get_child(1).text = ""
	attackInfo.get_child(2).text = ""

func _on_display_info(piece: Variant) -> void:
	pieceName.text = piece.piece_name
	pieceName.label_settings.font_color = 'f2deab' if piece.isWhite() else '9b5d2b'
	lvl.text = "Niv " + str(piece.lvl)
	hp.text = str(piece.pv) + " / " + str(piece.pvMax)
	attackInfo.get_child(0).text = "Normal : " + str(piece.valueAtk)
	attackInfo.get_child(1).text = "Special : " + str(piece.valueSpeAtk)
	attackInfo.get_child(2).text = "Remain special : " + str (piece.nbAtkSpe)
