extends CharacterBody2D


@export var JUMP_VELOCITY := -400.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
@onready var manager = get_node("/root/Manager")

var last_animation := ""
var is_jumping := false
var is_jump_init := false
var is_jump_ending := false

var is_alive := true

func _physics_process(delta):
	if not is_alive or manager.stop_game:
		return 
		
		
	var current_animation := last_animation
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	if is_jumping and is_on_floor():
		is_jumping = false
		is_jump_ending = true
		current_animation = "jump_end"
		
	# Handle Jump.
	if Input.is_action_just_pressed("ui_up") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		current_animation = "jump_init"
		is_jumping = true
		is_jump_init = true

	# dog going up
	if is_jumping and not is_jump_init:
		current_animation = "jump_air"
	
	# dog going down
	if velocity.y > 0:
		current_animation = "jump_fall"
		
	if not is_jumping and not is_jump_ending:
		current_animation = "walking"
	
	
	# play animation
	if last_animation != current_animation:
		$AnimatedSprite2D.play(current_animation)
		last_animation = current_animation
	
	move_and_slide()
	for index in get_slide_collision_count():
		var collision := get_slide_collision(index)
		var body := collision.get_collider()
		if body.name != "Floor":
			die()

func die():
	is_alive = false
	manager.stop_game = true


func _on_animated_sprite_2d_animation_finished():
	is_jump_init = false
	is_jump_ending = false
