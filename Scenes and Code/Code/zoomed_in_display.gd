extends Control
class_name BeegDisplay

signal display_created(display_node)
signal play_button_pressed(game_starting)


@onready var texture_rect: TextureRect = $TextureRect
@onready var color_rect: ColorRect = $ColorRect
@onready var title_text: RichTextLabel = $"ColorRect/Title Text"
@onready var explainer_text: RichTextLabel = $"ColorRect/Explainer Text"
@onready var play: Button = $ColorRect/Play
@onready var quit: Button = $ColorRect/Quit

@export var display : Texture
@export var game_name : String
@export var month_made : int 
@export var year_made : int
@export var is_2D : bool

var explainers = {
	"Pongalong" : "This is the first game I ever made, a copy of Pong!\nI have a few additions in the form of power-ups, so have fun discovering what they do!\n\nControls:\nPlayer 1:\nW moves paddle up, S moves paddle down\nPlayer 2: Up arrow moves up, down arrow moves down",
	"Hack and Sketch" : "This game was made for a class in University as a study for fully planning, developing, and releasing a software.\nGiven a choice to make anything, I made this game!\nExplore the dungeon, and try to find the stairs to get to the next level.\n\nControls:\nIn overworld:\nArrow Keys to move, Shift to Run\nIn Battle:\nUse the mouse to select the options in the menus.",
	"Comin' to Town" : "This is the first game in the Game a Month study I have been doing.\nPlay as Santa and bring presents from his sleigh to the tree, then return to the sleigh to beat the level!\nAvoid the sight of the children or you'll lose health!\n\nControls:\nMove with the Arrow Keys\nPower-ups collected from coookies should explain how to use them.",
	"Publix Accounting App" : "Breaking the rules early.  The second game in the Game a Month Study is actually an app.\nThis app has been created for the use of Publix Customer Service Staff employees.\n\nI would recommend not playing this as it will softlock this program.  It was made for Android devices.  Please contact me if you have an android device and would like to try it out.\nIf you do not have an android device, I do have a website that does some of the functions the app does at:\n\nlbcalcs.netlify.app",
	"Scoundrel" : "Game 3 in the Game a Month Study!\nThis game is a digitization of the card game scoundrel solitare, the rules of which can be found here:\n\nhttp://stfj.net/art/2011/Scoundrel.pdf\n\nControls:\nUse the mouse to select the cards.",
	"Lamplighters" : "Game 4 in the Game a Month Study!\nThis is a simple game, when the game's countdown reaches 0, be the first to light your torch!  But don't go to quick or you will lose a point. First to 5 wins.\n\nControls:\nPlayer 1: any of these buttons will light your torch - A,S,D,F\nPlayer 2: any of these buttons will light your torch - J,K,L,;"
}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

#Simply fills in the display
func fill_display():
	#Set the texture to the image in display
	texture_rect.texture = display
	#Set the title text to whether it is 2d, the games name, and the date it was made
	title_text.text = is_2d() + " - " + game_name + " - " + date_formatting()
	#Set the correct explainer text
	explainer_text.text = explainers[game_name]

#Make the date look correct with months less then 10 still have double digits
func date_formatting():
	if month_made < 10: #If the month it was made is less then 10
		return "0" + str(month_made) + "/" + str(year_made) #return the date, with the month returned with a 0 added in the front
	else: #otherwise
		return str(month_made) + "/" + str(year_made) #Just return the correct date

#Repeat of the is it 2d function
func is_2d():
	#If it is 2D
	if is_2D:
		#Return the correct text
		return "2D"
	else: #otherwise
		return "3D" #return the correct text


func _on_quit_pressed() -> void:
	print("Back to menu Button Pressed")
	var tween = create_tween()
	
	tween.tween_property(self, "modulate", Color(1, 1, 1, 0), 1)
	await tween.finished
	
	queue_free()


func _on_play_pressed() -> void:
	print("on_play_pressed reached on game ", game_name)
#	play_button_pressed.emit(str(game_name))
	match game_name:
		
		"Pongalong":
			get_tree().change_scene_to_file("res://Games/Pongalong/Scenes/main.tscn")
		"Hack and Sketch":
			get_tree().change_scene_to_file("res://Games/Hack and Sketch/Scenes/Main.tscn")
		"Comin' to Town":
			get_tree().change_scene_to_file("res://Games/Comin To Town/Scenes/main.tscn")
		"Publix Accounting App":
			get_tree().change_scene_to_file("res://Games/Publix Accounting App/Scenes and Code/main.tscn")
		"Scoundrel":
			get_tree().change_scene_to_file("res://Games/Scoundrel/Scenes and Code/Scenes/main.tscn")
		"Lamplighters":
			get_tree().change_scene_to_file("res://Games/Lamplighters/Scenes and Codes/Scenes/main.tscn")
		
