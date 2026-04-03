extends Control

@onready var buttons: Node = $"Menu Contents/Buttons"
@onready var pongalong_display: TextureButton = $"Menu Contents/Buttons/Pongalong Display"
@onready var comin_to_town_display: TextureButton = $"Menu Contents/Buttons/Comin to Town Display"
@onready var publix_accounting_app_display: TextureButton = $"Menu Contents/Buttons/Publix Accounting App Display"
@onready var scoundrel_display: TextureButton = $"Menu Contents/Buttons/Scoundrel Display"
@onready var lamplighters_display: TextureButton = $"Menu Contents/Buttons/Lamplighters Display"
@onready var hack_and_sketch_display: TextureButton = $"Menu Contents/Buttons/Hack and Sketch Display"

var pongalong_playing := false
var comin_to_town_playing := false
var hack_and_sketch_playing := false
var lamplighters_playing := false
var pub_account_app_playing := false
var scoundrel_playing := false

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
			for child in get_children():
				child.queue_free()
	
	match pressed_button:
		pongalong_display:
			pongalong_playing = true
			get_tree().change_scene_to_file("res://Games/Pongalong/Scenes/main.tscn")
		comin_to_town_display:
			#Signal Bus Issues
			comin_to_town_playing = true
			get_tree().change_scene_to_file("res://Games/Comin To Town/Scenes/main.tscn")
		publix_accounting_app_display:
			get_tree().change_scene_to_file("res://Games/Publix Accounting App/Scenes and Code/main.tscn")
		scoundrel_display:
			get_tree().change_scene_to_file("res://Games/Scoundrel/Scenes and Code/Scenes/main.tscn")
		lamplighters_display:
			#Autoload File Issues
			lamplighters_playing = true
			get_tree().change_scene_to_file("res://Games/Lamplighters/Scenes and Codes/Scenes/main.tscn")
		hack_and_sketch_display:
			hack_and_sketch_playing = true
			get_tree().change_scene_to_file("res://Games/Hack and Sketch/Scenes/Main.tscn")
