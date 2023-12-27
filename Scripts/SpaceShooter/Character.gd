extends Node2D

class_name SpaceShooterChar


## Moves the character into the given direction
static func move(position: Vector2, direction: Vector2,
		  speed: float, delta: float) -> Vector2:
	return  position.move_toward(
				position + 10 * direction, speed * delta
			).clamp(Vector2.ZERO, Manager.screen_size)


static func take_damage(character: Node2D,
						damage: int, 
						kill_func: Callable) -> int:
	var current_health = character.current_health - damage
	character.smaterial.set_shader_parameter("color", character.hit_color)
	if current_health <= 0:
		kill_func.call()
	character.hit_timer.start(0.1)
	return current_health
	
