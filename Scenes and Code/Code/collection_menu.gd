extends Control

#Declaring Members of the scene for reference
@onready var menu_contents : Node = $"Menu Contents"
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

#called when a game display button is pressed
func game_button_pressed():
	print("button pressed called")
	var pressed_button #declare pressed button
	
	#Check all buttons to see which is being pressed
	for button in buttons.get_children():
		if button.button_pressed: #if the button being checked is being pressed
			print(button.name)
			pressed_button = button #set the button being pressed to the pressed button variable
#	#		for child in get_children():
#	#			child.queue_free()
	
	match pressed_button: #match the now found pressed_button to one of the cases below
		
		#the following is a commenting case to show how it is structured
		#if the case matches the case listed here:
		#	set playing flag to true
		#	change the scene as needed
		
		pongalong_display:
			pongalong_selected = true
			zoomed_in_spawn(pongalong_display)
		
		comin_to_town_display:
			#Signal Bus Issues
			comin_to_town_selected = true
			zoomed_in_spawn(comin_to_town_display)
		
		publix_accounting_app_display:
			pub_account_app_selected = true
			zoomed_in_spawn(publix_accounting_app_display)
		
		scoundrel_display:
			scoundrel_selected = true
			zoomed_in_spawn(scoundrel_display)
		
		lamplighters_display:
			#Autoload File Issues
			lamplighters_selected = true
			zoomed_in_spawn(lamplighters_display)
		
		hack_and_sketch_display:
			hack_and_sketch_selected = true
			zoomed_in_spawn(hack_and_sketch_display)

#Called when a button is pressed, passing in the display that needs to be zoomed
func zoomed_in_spawn(display_zoomed):
	var zoomed_display #declare a variable for zoomed_display
	zoomed_display = zoomed_in_display_load.instantiate() #instantiate the preloaded scene
	zoomed_display.position = Vector2(0, 0) #Set the position of the zoomed display to (0, 0)
	
	zoomed_display.set_deferred("custom_minimum_size", display_zoomed.size) #set it's minimum size to the size of the small display
	menu_contents.add_child(zoomed_display) #and then add it to the scene, under the correct part of the tree
	
	#Set the variables on the new large display to the selected small displays variables
	zoomed_display.game_name = display_zoomed.game_name
	zoomed_display.month_made = display_zoomed.month_made
	zoomed_display.year_made = display_zoomed.year_made
	zoomed_display.is_2D = display_zoomed.is_2D
	zoomed_display.display = display_zoomed.texture_normal
	#Set the display to clear
	zoomed_display.modulate = Color(1, 1, 1, 0)
	#call the fill display function on the zoomed display so it will display the new sets
	zoomed_display.call_deferred("fill_display")
	
	#And finally call tween_display to allow the display to actually move it as desired
	call_deferred("tween_display", display_zoomed, zoomed_display)

#Function to tween the displays as needed
func tween_display(small_display, big_display):
	#Ensure the displays are in the correct order so the smaller displays don't end up overlapping the chosen ones
	small_display.move_to_front()
	big_display.move_to_front()
	
	#Declare variables to memorize the sizes and positions of the small display, so it can be reset after the tween
	var sds = small_display.size
	var sdcms = small_display.custom_minimum_size
	var sdgp = small_display.global_position
	
	var tween = create_tween() #create the tween
	tween.set_parallel(true) #Set parallel to true to allow the tweens to happen simultaneously
	tween.tween_property(small_display, "custom_minimum_size", Vector2(get_window().size), 1.5) #Tween the minimum size from current to the size of the game window in 1.5 seconds
	tween.tween_property(small_display, "global_position", Vector2(0, 0), 1.5) #Tween the global position from current to (0, 0) aka the center of the screen in this case in 1.5 seconds
	
	#End the parallel... which seems to not be working.  Need to research tween interactions more
	tween.set_parallel(false)
	tween.tween_interval(0.25) # wait for the parallel block to finish
	
	#Tween the big display from clear to opaque
	tween.tween_property(big_display, "modulate", Color(1, 1, 1, 1), 1)
	
	await tween.finished #Wait for the tween to finish and then
	#Set the small display to the memorized variables from earlier
	small_display.custom_minimum_size = sdcms 
	small_display.size = sds
	#small_display.global_position = sdgp
	small_display.position = sdgp#sdgp

#When a child node enters the tree
func _on_child_entered_tree(node: Node) -> void:
	var selected_node
	#If the node is a beegdisplay
	if node is BeegDisplay:
		for flag in game_signals:
			if flag:
				var selected_game = str(flag.name).replace("_selected", "")
				selected_game += "_display" #now selected game is game_display
				selected_node = get_node("Menu Contents/Buttons/" + selected_game)		
