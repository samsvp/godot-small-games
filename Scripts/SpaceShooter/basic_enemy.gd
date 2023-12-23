######################
### SPACE SHOOTER  ###
######################

extends Area2D


@export var initial_speed := 2
var height_offset: float
var target: Vector2 

func _ready():
	self.position.x = randi_range(50, Manager.screen_width - 50)
	self.target = Vector2(self.position.x, Manager.screen_height / 2)
	self.height_offset = randf_range(-100, 100)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if self.position.y > Manager.screen_height / 2 + height_offset:
		return
	
	self.position = self.position.lerp(target, delta * initial_speed)


func _on_body_entered(body):
	if body.name == "Player":
		body.take_damage(1)
