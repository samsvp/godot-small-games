extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	%Pong.grab_focus()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _input(ev):
	if ev is InputEventKey and ev.pressed:
		if ev.keycode == KEY_W:
			get_tree().change_scene_to_file("res://Scenes/endless_runner.tscn")
		if ev.keycode == KEY_P:
			get_tree().change_scene_to_file("res://Scenes/Pong/main.tscn")


func _on_pong_pressed():
	get_tree().change_scene_to_file("res://Scenes/Pong/main.tscn")


func _on_space_shooter_pressed():
	get_tree().change_scene_to_file("res://Scenes/SpaceShooter/space_shooter_main.tscn")
