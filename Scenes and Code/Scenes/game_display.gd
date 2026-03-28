extends TextureButton


@export var month_made : int 
@export var year_made : int
@export var is_2D : bool

@onready var title: Label = $ColorRect/Title

func _ready() -> void:
	set_title()

func set_title():
	var title_text : String
	
	title_text = self.name
	title_text = title_text.replace(" Display", " ")
	
	#Set title text to the name, whether it is 2d or 3d, and the month and year it was made
	if month_made < 10:
		title_text += "\n" + is_game_2d() + " - 0" + str(month_made) + "/" + str(year_made)
	else:
		title_text += "\n" + is_game_2d() + " - " + str(month_made) + "/" + str(year_made)
	
	title.text = title_text

func is_game_2d():
	if is_2D:
		return "2D"
	if not is_2D:
		return "3D"
