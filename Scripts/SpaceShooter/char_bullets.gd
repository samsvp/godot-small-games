extends Node2D

class_name CharBullet

@onready var bullet_image = preload("res://Sprites/white.png")

@export var BULLET_COUNT: int = 100
@export var speed := 10.0
@export var sprite_scale := 0.2
@export var bullet_color: Color
@export var collision_layer: int = 1

var bullet_array: BulletArray
var stop := false
var passed_time := 0.0

# Called when the node enters the scene tree for the first time.
func _ready():
	top_level = true
	self.bullet_array = BulletArray.new(speed,
		   bullet_image, sprite_scale, BULLET_COUNT, 
		   get_world_2d().get_space(), self.collision_layer)
	
	material.set_shader_parameter("bullet_color", bullet_color)


func _process(delta):
	# Order the CanvasItem to update every frame.
	queue_redraw()


func shoot(origin: Vector2, direction: Vector2, speed_multiplier := 1.0):
	if not self.stop:
		self.bullet_array.shoot(origin, direction, speed_multiplier)


func _physics_process(delta):
	self.passed_time += delta
	material.set_shader_parameter("time", self.passed_time)
	self.bullet_array.physics_process(delta)


# Instead of drawing each bullet individually in a script attached to each bullet,
# we are drawing *all* the bullets at once here.
func _draw():
	material.set_shader_parameter("bullet_color", bullet_color)
	self.bullet_array.draw(draw_texture_rect)


func _exit_tree():
	self.bullet_array.exit_tree()
