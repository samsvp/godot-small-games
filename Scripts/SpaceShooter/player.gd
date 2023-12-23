######################
### SPACE SHOOTER  ###
######################

extends CharacterBody2D

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
		Callable(self, "queue_free")
	)

