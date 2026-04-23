extends Node3D

@onready var carousel: Path3D = $Carousel
@onready var camera_3d: Camera3D = $Camera3D


@onready var pongalong_display_3d: Node3D = $"Carousel/Pongalong PathFollow/Pongalong Display 3D"
@onready var hack_and_sketch_display_3d: Node3D = $"Carousel/Hack and Sketch PathFollow/Hack and Sketch Display 3D"
@onready var comin_to_town_display_3d: Node3D = $"Carousel/Comin to Town PathFollow/Comin To Town Display 3D"
@onready var scoundrel_display_3d: Node3D = $"Carousel/Scoundrel PathFollow/Scoundrel Display 3D"
@onready var lamplighters_display_3d: Node3D = $"Carousel/Lamplighters PathFollow/Lamplighters Display 3D"
var game_displays : Array[GameDisplay3D] = []


var moving_forward : bool = true
var carousel_dir : int = 1
var carousel_moving : bool = false
var game_chosen : bool = false

var big_display_preload := preload("res://Scenes and Code/Scenes/game_display_3d.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#For the pathfollow nodes connected to the carousel path
	for paths in carousel.get_children():
		#If the path has children, target the first child, and if it is a GameDisplay3D
		if paths.get_child(0) is GameDisplay3D:
			#Add that display to the game display array
			game_displays.append(paths.get_child(0))
	
	#for the displays within the game display array
	for display in game_displays:
		#Connect the signal game clicked to the game button pressed function
		display.connect("game_clicked", game_button_pressed)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#If we press the next button and the carousel isn't currently moving
	if Input.is_action_just_pressed("Next") and not carousel_moving:
		#Set the carousel movement to true
		carousel_moving = true
		#If it isn't moving forward
		if not moving_forward:
			#Set the direction to the opposite of whatever it currently is
			carousel_dir *= -1
			#and set moving forward to true
			moving_forward = true
		#for the progress of each display in the carousel
		for gamecard_progress in carousel.get_children():
			#Tween the displays to the correct position
			progress_tweening(gamecard_progress)
	
	#Repeat above but for previous, letting the menu move backwards through slight changes to the moving forward bool
	if Input.is_action_just_pressed("Prev") and not carousel_moving:
		carousel_moving = true
		if moving_forward:
			carousel_dir *= -1
			moving_forward = false
		for gamecard_progress in carousel.get_children():
			progress_tweening(gamecard_progress)
	
	#if we want to switch back to the 2d menu
	if Input.is_action_just_pressed("Menu Switch"):
		#Set the menu in 3d flag to false in the gameMenuConfig global script
		gameMenuConfig.menu_in_3D = false
		#change the current scene to the 2d menu scene
		get_tree().change_scene_to_file("res://Scenes and Code/Scenes/collection_menu.tscn")
	
	if not game_chosen:
		#for each display in the game display array
		for display in game_displays:
			#Force the display to look at the camera's global position at all times
			display.look_at(camera_3d.global_position)
			#I actually... don't remember why I put this.  It is probably there to flip the display in the right direction
			#In fact yea, rotating something by pi is equivalent of rotating it 180 degrees so I am sure that is what it is
			display.rotate_object_local(Vector3.UP, PI)
		#game_display_3d.rotation = Vector3(camera_3d.rotation.x, camera_3d.rotation.y + 180, camera_3d.rotation.z)

#Function to tween the game cards
func progress_tweening(gamecard_progress):
	var tween = create_tween()
	#Create a new_progress variable for the gamecards to tween to
	var new_progress
	#We do this by setting it's value to:
	#the current progress plus the result of dividing 1 by the amount of game's on the list.  
	#We also multiply this by the carousel's direction of 1 or -1 to tell which direction the games should move
	new_progress = gamecard_progress.progress_ratio + ((1.0/game_displays.size()) * carousel_dir)
	
	#Now we simply set the tween property to tween the passed card's progress ratio to the new target over the span of one second
	tween.tween_property(gamecard_progress, "progress_ratio", new_progress, 1.0)
	#we wait for the tween to finish
	await tween.finished
	#And then set carousel moving to false
	carousel_moving = false

#I believe this is currently not working but meant to tween the postion of the card, to the camera, to look like the game is coming at you, before loading you in
func tween_to_camera(gamecard_tweening):
	var og_gc_gp = gamecard_tweening.global_position
	var og_gc_gr = gamecard_tweening.global_rotation
	
	var tween = create_tween()
	game_chosen = true
	tween.set_parallel(true)
	tween.tween_property(gamecard_tweening, "global_position", camera_3d.global_position + Vector3(1, 0, 0), 1.0)
	tween.tween_property(gamecard_tweening, "global_rotation", camera_3d.global_rotation, 1.0)
	await tween.finished
	
	gamecard_tweening.global_position = og_gc_gp
	gamecard_tweening.global_rotation = og_gc_gr

func game_button_pressed(game_chosen):
	#Set pressed_button to the passed in chosen game
	var pressed_button = game_chosen
	
	#for display in game_displays:
	#	if display.game_display.button_pressed:
	#		pressed_button = display.game_display
	
	#Set menu_in_3d to true in case it somehow wasn't
	gameMenuConfig.menu_in_3D = true
	
	#Match case to load the correct game
	#All cases are built the same so instead, the first comment under pressed button will instead be a template
	match pressed_button:
		#name of game card
			#tween_to_camera(name of game card)
			#change the scene to that of the chosen game
		pongalong_display_3d:
			await tween_to_camera(pongalong_display_3d)
			#get_tree().change_scene_to_file("res://Games/Pongalong/Scenes/main.tscn")
		comin_to_town_display_3d:
			await tween_to_camera(comin_to_town_display_3d)
			#get_tree().change_scene_to_file("res://Games/Comin To Town/Scenes/main.tscn")
		scoundrel_display_3d:
			await tween_to_camera(scoundrel_display_3d)
			#get_tree().change_scene_to_file("res://Games/Scoundrel/Scenes and Code/Scenes/main.tscn")
		lamplighters_display_3d:
			await tween_to_camera(lamplighters_display_3d)
			#get_tree().change_scene_to_file("res://Games/Lamplighters/Scenes and Codes/Scenes/main.tscn")
		hack_and_sketch_display_3d:
			await tween_to_camera(hack_and_sketch_display_3d)
			#get_tree().change_scene_to_file("res://Games/Hack and Sketch/Scenes/Main.tscn")
	
	create_big_display(pressed_button)

func create_big_display(game_selected):
	print(game_selected, " pressed")
	var big_display = big_display_preload.instantiate()
	
	big_display.is_big_display = true
	big_display.game_name = game_selected.game_name
	big_display.month_made = game_selected.month_made
	big_display.year_made = game_selected.year_made
	big_display.is_2D = game_selected.is_2D
	big_display.thumbnail = game_selected.thumbnail
	
	
	camera_3d.add_child(big_display)
	big_display.position = Vector3(0, 0, -0.63)
	
