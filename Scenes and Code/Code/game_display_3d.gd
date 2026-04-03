extends Node3D

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


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_area_3d_input_event(camera: Node, event: InputEvent, event_position: Vector3, normal: Vector3, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed:
		game_clicked.emit(self)
