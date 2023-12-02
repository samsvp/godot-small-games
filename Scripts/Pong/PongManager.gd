extends Node2D

enum {NONE, PLAYER, ENEMY}

var enemy_score = 0
var player_score = 0
var has_game_finished := true
var winner_name = NONE

@export var max_score := 3
@onready var Enemy := %Enemy
@onready var Player := %Player
@onready var PlayerScore := %PlayerScore
@onready var EnemyScore := %EnemyScore
@onready var WinExplosion := %WinExplosion


func _ready() -> void:
	%StartButton.grab_focus()


## Increments the player score
## returns true if the player has won, false otherwise
func increment_player_score() -> bool:
	if self.winner_name == ENEMY:
		return false
	if self.winner_name == PLAYER:
		return true
		
	self.player_score += 1
	if self.player_score == self.max_score:
		self.winner_name = PLAYER
		self.finish_game(Player.outline_color)
		
	self.reset_characters()
	self.print_score()
	return self.has_game_finished


## Increments the enemy score
## returns true if the enemy has won, false otherwise
func increment_enemy_score() -> bool:
	if self.winner_name == ENEMY:
		return true
	if self.winner_name == PLAYER:
		return false
	
	self.enemy_score += 1
	if self.enemy_score == self.max_score:
		self.winner_name = ENEMY
		WinExplosion.emitting = true
		self.finish_game(Enemy.outline_color)
	
	self.reset_characters()
	self.print_score()
	return self.has_game_finished


func set_max_score(max_score: int) -> bool:
	if max_score <= 0 or max_score >= 10:
		return false
	self.max_score = max_score
	return true


func finish_game(outline_color: Color) -> void:
	%GUI.visible = true
	%StartButton.grab_focus()
	self.has_game_finished = true
	WinExplosion.emitting = true
	WinExplosion.process_material.color = outline_color


func print_score() -> void:
	EnemyScore.frame = self.enemy_score - 1 if self.enemy_score > 0 else 9
	PlayerScore.frame = self.player_score - 1 if self.player_score > 0 else 9


func reset_characters() -> void:
	%Player.reset()
	%Enemy.reset()


func _on_start_button_pressed():
	%GUI.visible = false
	self.has_game_finished = false
	self.enemy_score = 0
	self.player_score = 0
	self.print_score()
	self.winner_name = NONE
	%Ball.reset()


func _on_end_button_pressed():
	get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")
