extends Node2D

const BULLET_COUNT: int = 100
const bullet_image = preload("res://Sprites/white.png")
@onready var shader = preload("res://Shaders/SpaceShooter/bullet.gdshader")
@onready var pshader = preload("res://Shaders/SpaceShooter/Player.gdshader")
var speed := 10.0
var sprite_scale := 0.2

var shape: RID
var bullets := []
var size: Vector2 
var transform2d = Transform2D()

class Bullet:
	var position: Vector2
	var speed: float
	var body := RID()
	
	func _init(speed: float, position: Vector2):
		self.speed = speed
		self.position = position

# Called when the node enters the scene tree for the first time.
func _ready():
	self.size = bullet_image.get_size() * Vector2(sprite_scale, sprite_scale)
	self.shape = PhysicsServer2D.circle_shape_create()
	# set the radius
	PhysicsServer2D.shape_set_data(self.shape, 8)
	
	# set shader
	var material := ShaderMaterial.new()
	material.shader = shader
	set_material(material)
	
	for _i in self.BULLET_COUNT:
		var pos := Vector2( 
			randf_range(0, Manager.screen_width), 
			randf_range(0, Manager.screen_height) 
		)
		var bullet := Bullet.new(speed, pos)
		bullet.body = PhysicsServer2D.body_create()
		
		PhysicsServer2D.body_set_space(bullet.body, get_world_2d().get_space())
		PhysicsServer2D.body_add_shape(bullet.body, shape)
		# Don't make bullets check collision with other bullets to improve performance.
		PhysicsServer2D.body_set_collision_mask(bullet.body, 0)
		
		transform2d.origin = bullet.position
		PhysicsServer2D.body_set_state(
			bullet.body, PhysicsServer2D.BODY_STATE_TRANSFORM, transform2d
		)
		
		bullets.push_back(bullet)


func _process(delta):
	# Order the CanvasItem to update every frame.
	queue_redraw()


func _physics_process(delta):
	var offset := Manager.screen_width + 16
	for bullet in self.bullets:
		bullet.position.x -= bullet.speed * delta
		if bullet.position.x < -16:
			bullet.position.x = offset
		transform2d.origin = bullet.position
		PhysicsServer2D.body_set_state(
			bullet.body, PhysicsServer2D.BODY_STATE_TRANSFORM, transform2d
		)


# Instead of drawing each bullet individually in a script attached to each bullet,
# we are drawing *all* the bullets at once here.
func _draw():
	for bullet in bullets:
		var rect := Rect2(bullet.position - size * 0.5, size)
		draw_texture_rect(bullet_image, rect, false)


func _exit_tree():
	for bullet in bullets:
		PhysicsServer2D.free_rid(bullet.body)
	
	bullets.clear()
