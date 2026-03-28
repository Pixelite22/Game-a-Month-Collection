extends Control

@onready var buttons: Node = $Buttons
@onready var pongalong_display: TextureButton = $"Buttons/Pongalong Display"
@onready var comin_to_town_display: TextureButton = $"Buttons/Comin to Town Display"
@onready var publix_accounting_app_display: TextureButton = $"Buttons/Publix Accounting App Display"
@onready var scoundrel_display: TextureButton = $"Buttons/Scoundrel Display"
@onready var lamplighters_display: TextureButton = $"Buttons/Lamplighters Display"
@onready var hack_and_sketch_display: TextureButton = $"Buttons/Hack and Sketch Display"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	connect_buttons()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func connect_buttons():
	for button in buttons.get_children():
		button.pressed.connect(game_button_pressed)

func game_button_pressed():
	var pressed_button
	
	for button in buttons.get_children():
		if button.button_pressed:
			pressed_button = button
	
	match pressed_button:
		pongalong_display:
			print("pongalong pressed")
		comin_to_town_display:
			print("comin to town pressed")
		publix_accounting_app_display:
			print("publix accounting app pressed")
		scoundrel_display:
			print("scoundrel pressed")
		lamplighters_display:
			print("lamplighters pressed")
		hack_and_sketch_display:
			print("hack and sketch pressed")
