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
			var pongalong = load("res://Games/Pongalong/Scenes/main.tscn")
			var pongalong_instance = pongalong.instantiate()
			add_child(pongalong_instance)
		comin_to_town_display:
			print("comin to town pressed")
		publix_accounting_app_display:
			print("publix accounting app pressed")
		scoundrel_display:
			print("Scoundrel pressed")
		lamplighters_display:
			lamplighters_playing = true
			var lamplighters_event_bus_node = Node.new()
			lamplighters_event_bus_node.name = "lamplighters_event_bus_node"
			add_child(lamplighters_event_bus_node)
			lamplighters_event_bus_node.set_script("res://Games/Lamplighters/Scenes and Codes/Code/Event_Bus.gd")
			
			var lamplighters_state_machine = Node.new()
			lamplighters_state_machine.name = "lamplighters_state_machine"
			add_child(lamplighters_state_machine)
			lamplighters_state_machine.set_script("res://Games/Lamplighters/Scenes and Codes/Code/Game_State_Machine.gd")
			
			var lamplighters = load("res://Games/Lamplighters/Scenes and Codes/Scenes/main.tscn")
			var lamplighters_instance = lamplighters.instantiate()
			add_child(lamplighters_instance)
		hack_and_sketch_display:
			hack_and_sketch_playing = true
			get_tree().change_scene_to_file("res://Games/Hack and Sketch/Scenes/Main.tscn")
			#var hack_and_sketch = load("res://Games/Hack and Sketch/Scenes/Main.tscn")
			#var hack_and_sketch_instance = hack_and_sketch.instantiate()
			#add_child(hack_and_sketch_instance)
