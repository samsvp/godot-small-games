extends Sprite2D

@onready var player := %Player
@onready var enemies_node := %Enemies

var spotlights: PackedVector2Array = []
var m: float = min(Manager.screen_height, Manager.screen_width)

# Called when the node enters the scene tree for the first time.
func _ready():
	for i in range(100):
		spotlights.append(Vector2(1001, 1001))
	scale = Manager.screen_size / 128
	material.set_shader_parameter("u_resolution", Manager.screen_size)


func _process(delta):
	spotlights[0] = get_shader_position(player.position)
	var enemies := self.enemies_node.get_children()
	for i in range(1, 100):
		if enemies.size() >= i:
			if enemies[i - 1].current_health > 0:
				spotlights[i] = get_shader_position(enemies[i - 1].position)
			else:
				# this is only here because the shader stops
				# looking for spotlights once it sees a spotlight
				# with x coordinate bigger than 100
				spotlights[i] = spotlights[0]
		else:
			spotlights[i] = Vector2(101, 101)
	material.set_shader_parameter("u_spotlight", spotlights)


func get_shader_position(pos: Vector2) -> Vector2:
	return (2.0 * pos - Manager.screen_size) / self.m
