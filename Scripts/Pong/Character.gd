extends Node2D


func set_outline(sprite: Sprite2D, outline_color: Vector4, outline_width := 1.0) -> void:
	sprite.material.set_shader_parameter("outline_width", outline_width)
	sprite.material.set_shader_parameter("outline_color", outline_color)


func clamp_y(y: float, paddle_size: float) -> float:
	y = min(y, Manager.screen_height - paddle_size / 2)
	y = max(y, paddle_size / 2)
	return y
