extends Node3D
class_name GameDisplay3D

signal game_clicked(Node3D)

@export var game_name : String
@export var month_made : int 
@export var year_made : int
@export var is_2D : bool
@export var thumbnail : Texture2D

@onready var game_display: TextureButton = $"SubViewport/Control/Game Display"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	game_display.game_name = game_name
	game_display.month_made = month_made
	game_display.year_made = year_made
	game_display.is_2D = is_2D
	game_display.texture_normal = thumbnail
	game_display.set_title()
	
	floating_in_space()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func floating_in_space():
	var tween = create_tween()
	
	var top_float = position + Vector3(0.0, 0.25, 0.0)
	var bottom_float = position - Vector3(0.0, 0.25, 0.0)
	
	tween.bind_node(self)
	tween.set_loops(0)
	tween.tween_property(self, "position", top_float, randf_range(2.5, 3.5))
	tween.tween_property(self, "position", bottom_float, randf_range(2.5, 3.5))


func _on_area_3d_input_event(camera: Node, event: InputEvent, event_position: Vector3, normal: Vector3, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed:
		game_clicked.emit(self)
