extends Area2D

@export var current_health := 6
@export var speed: float = 250
@export var color := Color(0.95, 0.5, 0.5)
@export var hit_color := Color(1.0, 1.0, 0.2)

@onready var hit_timer := %HitTimer
@onready var sprite2d: Sprite2D = %Sprite2D
@onready var smaterial: Material = %Sprite2D.material

var Player: Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	self.speed = abs(randfn(1.0, 0.2) * self.speed)
	self.smaterial.set_shader_parameter("color", color)
	self.position = Enemy.spawn_location()


func _physics_process(delta):
	if Player == null:
		return
	
	var target := Player.position - self.position
	self.rotation = SpaceShooterChar.look_towards(target, self, delta)
	self.position = SpaceShooterChar.move(
		self.position, target, speed, delta
	)


func _on_body_shape_entered(body_rid, body, body_shape_index, local_shape_index):
	PhysicsServer2D.body_set_state(
		body_rid, PhysicsServer2D.BODY_STATE_SLEEPING, true
	)
	
	self.current_health = SpaceShooterChar.take_damage(self, 1, queue_free)


func _on_hit_timer_timeout():
	Enemy.hit_timeout(self)
