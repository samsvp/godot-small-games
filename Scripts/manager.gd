extends Node


static var stop_game := false
var current_scene = null

var screen_width: int = ProjectSettings.get_setting("display/window/size/viewport_width")
var screen_height: int = ProjectSettings.get_setting("display/window/size/viewport_height") 
var screen_size := Vector2(screen_width, screen_height)

# Called when the node enters the scene tree for the first time.
func _ready():
	var root = get_tree().get_root()
	current_scene = root.get_child(root.get_child_count() -1)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _input(ev):
	if ev is InputEventKey and ev.pressed:
		if ev.keycode == KEY_R:
			get_tree().reload_current_scene()
			stop_game = false
