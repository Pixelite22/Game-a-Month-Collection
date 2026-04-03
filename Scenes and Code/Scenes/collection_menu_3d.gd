extends Node3D

@onready var carousel: Path3D = $Carousel
@onready var camera_3d: Camera3D = $Camera3D


@onready var pongalong_display_3d: Node3D = $"Carousel/Pongalong PathFollow/Pongalong Display 3D"
@onready var hack_and_sketch_display_3d: Node3D = $"Carousel/Hack and Sketch PathFollow/Hack and Sketch Display 3D"
@onready var comin_to_town_display_3d: Node3D = $"Carousel/Comin to Town PathFollow/Comin To Town Display 3D"
@onready var scoundrel_display_3d: Node3D = $"Carousel/Scoundrel PathFollow/Scoundrel Display 3D"
@onready var lamplighters_display_3d: Node3D = $"Carousel/Lamplighters PathFollow/Lamplighters Display 3D"

var moving_forward : bool = true
var carousel_dir : int = 1.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("Next"):
		if not moving_forward:
			carousel_dir *= -1
			moving_forward = true
		for gamecard_progress in carousel.get_children():
			progress_tweening(gamecard_progress)
	
	if Input.is_action_just_pressed("Prev"):
		if moving_forward:
			carousel_dir *= -1
			moving_forward = false
		for gamecard_progress in carousel.get_children():
			progress_tweening(gamecard_progress)
	
	for child in carousel.get_children():
		if child is PathFollow3D:
			for display in child.get_children():
				display.look_at(camera_3d.global_position)
				display.rotate_object_local(Vector3.UP, PI)
	#game_display_3d.rotation = Vector3(camera_3d.rotation.x, camera_3d.rotation.y + 180, camera_3d.rotation.z)

func progress_tweening(gamecard_progress):
	var tween = create_tween()
	var new_progress
	new_progress = gamecard_progress.progress_ratio + (0.2 * carousel_dir)
	tween.tween_property(gamecard_progress, "progress_ratio", new_progress, 1.0)

func game_button_pressed(game_chosen):
	var pressed_button = game_chosen
	
	for paths in carousel.get_children():
		if paths is PathFollow3D:
			var display = paths.get_child(0)
			if display.game_display.button_pressed:
				pressed_button = display.game_display
	
	match pressed_button:
		pongalong_display_3d:
			get_tree().change_scene_to_file("res://Games/Pongalong/Scenes/main.tscn")
		comin_to_town_display_3d:
			get_tree().change_scene_to_file("res://Games/Comin To Town/Scenes/main.tscn")
		#publix_accounting_app_display_3d:
		#	get_tree().change_scene_to_file("res://Games/Publix Accounting App/Scenes and Code/main.tscn")
		scoundrel_display_3d:
			get_tree().change_scene_to_file("res://Games/Scoundrel/Scenes and Code/Scenes/main.tscn")
		lamplighters_display_3d:
			#Autoload File Issues
			get_tree().change_scene_to_file("res://Games/Lamplighters/Scenes and Codes/Scenes/main.tscn")
		hack_and_sketch_display_3d:
			get_tree().change_scene_to_file("res://Games/Hack and Sketch/Scenes/Main.tscn")
