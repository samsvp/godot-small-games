extends Node2D

class_name SpaceShooterChar


## Moves the character into the given direction
static func move(position: Vector2, direction: Vector2,
		  speed: float, delta: float) -> Vector2:
	return  position.move_toward(
				position + 10 * direction, speed * delta
			).clamp(Vector2.ZERO, Manager.screen_size)


static func take_damage(current_health: int, damage: int, 
						kill_func: Callable) -> int:
	current_health -= damage
	if current_health <= 0:
		kill_func.call()
	return current_health
	
