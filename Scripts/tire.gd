extends CharacterBody2D


@export var speed := Vector2(2, -10.0)

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
@onready var manager = get_node("/root/Manager")

# Called when the node enters the scene tree for the first time.
func _ready():
	velocity.x = speed.x


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if manager.stop_game:
		return
		
	if not is_on_floor():
		velocity.y += gravity * delta
	else:
		velocity.y = speed.y
	
	move_and_slide()
	for index in get_slide_collision_count():
		var collision := get_slide_collision(index)
		var body := collision.get_collider()
		if body.name == "Player":
			body.call("die")
