extends Node2D


func set_outline(sprite: Sprite2D, outline_color: Color, outline_width := 1.0) -> void:
	sprite.material.set_shader_parameter("outline_width", outline_width)
	sprite.material.set_shader_parameter("outline_color", outline_color)


func clamp_y(y: float, paddle_size: float) -> float:
	y = min(y, Manager.screen_height - paddle_size / 2)
	y = max(y, paddle_size / 2)
	return y


func reset(position: Vector2) -> Vector2:
	position.y = Manager.screen_height / 2
	return position
