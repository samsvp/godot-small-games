######################
### SPACE SHOOTER  ###
######################

extends Area2D

@export var SPEED := 300
@export var current_health = 5

func _physics_process(delta):
	var input_direction := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	self.position = SpaceShooterChar.move(
		self.position, input_direction, SPEED, delta
	)


func take_damage(damage: int) -> void:
	self.current_health = SpaceShooterChar.take_damage(
		self.current_health, 
		damage, 
		func(): self.visible = false
	)
	


func _on_body_shape_entered(body_rid, body, body_shape_index, local_shape_index):
	print("Entered")
