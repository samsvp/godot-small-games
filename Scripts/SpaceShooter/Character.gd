class_name SpaceShooterChar extends Resource

const explosion_scene := preload("res://Scenes/SpaceShooter/explosion.tscn")

## Moves the character into the given direction
static func move(position: Vector2, direction: Vector2,
		  speed: float, delta: float) -> Vector2:
	return  position.move_toward(
				position + 10 * direction, speed * delta
			).clamp(Vector2.ZERO, Manager.screen_size)


static func take_damage(character: Area2D,
						damage: int, 
						kill_func: Callable) -> int:
	var current_health = character.current_health - damage
	character.smaterial.set_shader_parameter("color", character.hit_color)
	if current_health <= 0:
		explode(character)
		kill_func.call()
	character.hit_timer.start(0.1)
	return current_health


static func look_towards(target: Vector2, character: Area2D, 
						 delta: float) -> float:
	var angle := target.angle() - PI / 2
	return lerp_angle(character.rotation, angle, 10 * delta)


static func explode(character: Area2D) -> void:
	var explosion := explosion_scene.instantiate()
	explosion.restart()
	explosion.position = character.position
	explosion.process_material.color = character.color
	character.get_window().add_child(explosion)
