extends Control

#Declaring Members of the scene for reference
@onready var buttons: Node = $"Menu Contents/Buttons"
@onready var pongalong_display: TextureButton = $"Menu Contents/Buttons/Pongalong Display"
@onready var comin_to_town_display: TextureButton = $"Menu Contents/Buttons/Comin to Town Display"
@onready var publix_accounting_app_display: TextureButton = $"Menu Contents/Buttons/Publix Accounting App Display"
@onready var scoundrel_display: TextureButton = $"Menu Contents/Buttons/Scoundrel Display"
@onready var lamplighters_display: TextureButton = $"Menu Contents/Buttons/Lamplighters Display"
@onready var hack_and_sketch_display: TextureButton = $"Menu Contents/Buttons/Hack and Sketch Display"

var scene : Dictionary

#Playing signal
var pongalong_selected := false
var comin_to_town_selected := false
var hack_and_sketch_selected := false
var lamplighters_selected := false
var pub_account_app_selected := false
var scoundrel_selected := false
var game_signals := [pongalong_selected, comin_to_town_selected, hack_and_sketch_selected, lamplighters_selected, pub_account_app_selected, scoundrel_selected]

#Zoomed in display preload
var zoomed_in_display_load = preload("res://Scenes and Code/Scenes/zoomed_in_display.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#Connect the button on boot up of scene
	connect_buttons()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#If the player want's to switch the menu from 2d to 3d
	if Input.is_action_just_pressed("Menu Switch"):
		gameMenuConfig.menu_in_3D = true #Set the flag of menu being in 3d to true, as it is now
		get_tree().change_scene_to_file("res://Scenes and Code/Scenes/collection_menu_3d.tscn") #Switch the scene to the 3d menu

func connect_buttons():
	#Loop through all the burrons in the button node
	for button in buttons.get_children():
		button.pressed.connect(game_button_pressed) #Connect the pressed signal to the function that handles button presses

func game_button_pressed():
	var pressed_button #declare pressed button
	
	#Check all buttons to see which is being pressed
	for button in buttons.get_children():
		if button.button_pressed:
			pressed_button = button #set the button being pressed to the pressed button variable
#			for child in get_children():
#				child.queue_free()
	
	match pressed_button: #match the now found pressed_button to one of the cases below
		
		#the following is a commenting case to show how it is structured
		#if the case matches the case listed here:
		#	set playing flag to true
		#	change the scene as needed
		
		pongalong_display:
			pongalong_selected = true
			zoomed_in_spawn(pongalong_display)
			#get_tree().change_scene_to_file("res://Games/Pongalong/Scenes/main.tscn")
		
		comin_to_town_display:
			#Signal Bus Issues
			comin_to_town_selected = true
			get_tree().change_scene_to_file("res://Games/Comin To Town/Scenes/main.tscn")
		
		publix_accounting_app_display:
			pub_account_app_selected = true
			get_tree().change_scene_to_file("res://Games/Publix Accounting App/Scenes and Code/main.tscn")
		
		scoundrel_display:
			scoundrel_selected = true
			get_tree().change_scene_to_file("res://Games/Scoundrel/Scenes and Code/Scenes/main.tscn")
		
		lamplighters_display:
			#Autoload File Issues
			lamplighters_selected = true
			get_tree().change_scene_to_file("res://Games/Lamplighters/Scenes and Codes/Scenes/main.tscn")
		
		hack_and_sketch_display:
			hack_and_sketch_selected = true
			get_tree().change_scene_to_file("res://Games/Hack and Sketch/Scenes/Main.tscn")

func zoomed_in_spawn(display_zoomed):
	var zoomed_display
	zoomed_display = zoomed_in_display_load.instantiate()
	zoomed_display.position = display_zoomed.global_position
	#zoomed_display.size = display_zoomed.size
	
	zoomed_display.set_deferred("size", display_zoomed.size)
	add_child(zoomed_display)
	
	zoomed_display.game_name = display_zoomed.game_name
	zoomed_display.month_made = display_zoomed.month_made
	zoomed_display.year_made = display_zoomed.year_made
	zoomed_display.is_2D = display_zoomed.is_2D
	zoomed_display.display = display_zoomed.texture_normal
	
	tween_display(zoomed_display)

func tween_display(display):
	var tween = create_tween()
	tween.set_parallel(true)
	tween.tween_property(display, "size", Vector2(get_window().size), 1.5)
	tween.tween_property(display, "global_position", Vector2(0, 0), 1.5)

func _on_child_entered_tree(node: Node) -> void:
	var selected_node
	
	if node is BeegDisplay:
		for flag in game_signals:
			if flag:
				var selected_game = str(flag.name).replace("_selected", "")
				selected_game += "_display" #now selected game is game_display
				selected_node = get_node("Menu Contents/Buttons/" + selected_game)		
