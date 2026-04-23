extends Node3D
class_name GameDisplay3D

signal game_clicked(Node3D)

@export var game_name : String
@export var month_made : int 
@export var year_made : int
@export var is_2D : bool
@export var thumbnail : Texture2D
var is_big_display = false

@onready var sub_viewport: SubViewport = $SubViewport
@onready var control: Control = $SubViewport/Control
@onready var game_display: TextureButton = $"SubViewport/Control/Game Display"

# Called when the node enters the scene tree for the first time.
#func _ready() -> void:
#	game_display.game_name = game_name
#	game_display.month_made = month_made
#	game_display.year_made = year_made
#	game_display.is_2D = is_2D
#	game_display.texture_normal = thumbnail
#	game_display.set_title()
#	
#	if is_big_display:
#		change_game_display()
#	else:
#		floating_in_space()

func _ready() -> void:
	if is_big_display:
		change_game_display()
	else:
		game_display.game_name = game_name
		game_display.month_made = month_made
		game_display.year_made = year_made
		game_display.is_2D = is_2D
		game_display.texture_normal = thumbnail
		game_display.set_title()
		floating_in_space()

func change_game_display():
	control.queue_free()
	
	var big_game_display_load = load("res://Scenes and Code/Scenes/zoomed_in_display.tscn")
	
	var big_game_display = big_game_display_load.instantiate()
	big_game_display.game_name = game_name
	big_game_display.month_made = month_made
	big_game_display.year_made = year_made
	big_game_display.is_2D = is_2D
	big_game_display.display = thumbnail
	
	sub_viewport.handle_input_locally = true
	sub_viewport.size = Vector2(1152, 648)
	sub_viewport.add_child(big_game_display)
	big_game_display.fill_display()
	
	big_game_display.play.pressed.connect(_play_button_pressed)
	big_game_display.quit.pressed.connect(_quit_button_pressed)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

#Function to emulate the movement of floating in space
func floating_in_space():
	var tween = create_tween()
	
	#Set the top and bottom possible heights the cards can float between
	var top_float = position + Vector3(0.0, 0.05, 0.0)
	var bottom_float = position - Vector3(0.0, 0.05, 0.0)
	
	tween.bind_node(self) #Bind the node to the game cards so if they are cleared then the tween ends
	tween.set_loops(0) #Set the tweens to loop for infinity
	tween.tween_property(self, "position", top_float, randf_range(2.5, 3.5)) #Tween the card to the top positino, over a random period of 2 and a half to 3 and a half seconds
	tween.tween_property(self, "position", bottom_float, randf_range(2.5, 3.5)) #Tween the card to the bottom positino, over a random period of 2 and a half to 3 and a half seconds

#Handles clicks on the card
func _on_area_3d_input_event(camera: Node, event: InputEvent, event_position: Vector3, normal: Vector3, shape_idx: int) -> void:
	if is_inside_tree():
		sub_viewport.push_input(event)
	if event is InputEventMouseButton and event.pressed: #if a card is clicked on
		game_clicked.emit(self) #emit the click signal

func _play_button_pressed():
	pass

func _quit_button_pressed():
	queue_free()
