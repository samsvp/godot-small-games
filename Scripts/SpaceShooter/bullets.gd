extends Node2D

class_name BulletArray

var bullet_image: Resource
var sprite_scale: float
var transform2d = Transform2D()
var bullet_size: Vector2
var active_bullets:Array[Bullet] = []
var max_bullet_count: int 
var space: RID
var shape: RID
var collision_layer: int
var speed: float
var n_bullets := 0

class Bullet:
	var position: Vector2
	var direction: Vector2
	var speed: float
	var body :RID
	
	func _init(speed: float, position: Vector2):
		self.speed = speed
		self.position = position


func _init(speed: float, bullet_image: Resource, sprite_scale: float,
		   bullet_count: int, space: RID, collision_layer: int):
	self.bullet_image = bullet_image
	self.sprite_scale = sprite_scale

	self.bullet_size = bullet_image.get_size() * Vector2(sprite_scale, sprite_scale)
	self.max_bullet_count = bullet_count
	
	self.speed = speed
	self.space = space
	self.collision_layer = collision_layer
	
	# set the radius
	self.shape = PhysicsServer2D.circle_shape_create()
	PhysicsServer2D.shape_set_data(shape, 8)


func create_bullet() -> Bullet:
	var pos := Vector2.ZERO
	var bullet := Bullet.new(speed, pos)
	self.n_bullets += 1
	
	bullet.body = PhysicsServer2D.body_create()
	PhysicsServer2D.body_set_space(bullet.body, space)
	PhysicsServer2D.body_add_shape(bullet.body, shape)
	# Don't make bullets check collision with other bullets to improve performance.
	PhysicsServer2D.body_set_collision_mask(bullet.body, 0)
	PhysicsServer2D.body_set_collision_layer(bullet.body, collision_layer)
	
	transform2d.origin = bullet.position
	PhysicsServer2D.body_set_state(
		bullet.body, PhysicsServer2D.BODY_STATE_TRANSFORM, transform2d
	)
	return bullet


func delete_bullet(bullet: Bullet):
	PhysicsServer2D.free_rid(bullet.body)
	self.n_bullets -= 1


func shoot(origin: Vector2, direction: Vector2) -> void:
	if self.n_bullets >= self.max_bullet_count:
		return
		
	var bullet = create_bullet()
	bullet.position = origin 
	bullet.direction = direction.normalized()
	self.active_bullets.append(bullet)


func physics_process(delta):
	var offset := 32.0
	var bullets_to_remove:Array[Bullet] = [] 
	for bullet in self.active_bullets:
		if PhysicsServer2D.body_get_state(
				bullet.body, PhysicsServer2D.BODY_STATE_SLEEPING):
			bullets_to_remove.append(bullet)
			continue
		
		bullet.position += bullet.speed * bullet.direction * delta
		
		# remove offscreen bullets
		if bullet.position.x > Manager.screen_width + offset or \
				bullet.position.y > Manager.screen_height + offset or \
				bullet.position.x < -offset or \
				bullet.position.y < -offset:
			bullets_to_remove.append(bullet)
			
		transform2d.origin = bullet.position
		PhysicsServer2D.body_set_state(
			bullet.body, PhysicsServer2D.BODY_STATE_TRANSFORM, transform2d
		)
	
	for bullet in bullets_to_remove:
		self.active_bullets.erase(bullet)
		self.delete_bullet(bullet)


# Instead of drawing each bullet individually in a script attached to each bullet,
# we are drawing *all* the bullets at once here.
func draw(draw_texture_rect: Callable):
	for bullet in self.active_bullets:
		var rect := Rect2(bullet.position - self.bullet_size * 0.5, self.bullet_size)
		draw_texture_rect.call(self.bullet_image, rect, false)


func exit_tree():
	for bullet in self.active_bullets:
		PhysicsServer2D.free_rid(bullet.body)
	
	self.active_bullets.clear()
