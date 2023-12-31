class_name Enemy extends Resource


static func physics_process(enemy: Area2D):
	if enemy.bullets.stop and enemy.bullets.bullet_array.n_bullets == 0:
		enemy.queue_free()


static func spawn_location() -> Vector2:
	var position: Vector2
	if randf() < 0.5:
		position.x = randi_range(50, Manager.screen_width - 50)
		position.y = 0 if randf() < 0.5 else Manager.screen_height
	else:
		position.x = 0 if randf() < 0.5 else Manager.screen_width
		position.y = randi_range(50, Manager.screen_height - 50)
	return position


## Marks the body shape as sleeping and returns the enemy's health after 
## damage calculation
static func on_body_shape_entered(body_rid: RID, damage: int, 
								  enemy: Area2D) -> int:
	PhysicsServer2D.body_set_state(
		body_rid, PhysicsServer2D.BODY_STATE_SLEEPING, true
	)
	
	return SpaceShooterChar.take_damage(
		enemy,
		damage,
		func (): die(enemy)
	)


static func hit_timeout(enemy: Area2D):
	enemy.smaterial.set_shader_parameter("color", enemy.color)


static func die(enemy: Area2D):
	enemy.bullets.stop = true
	enemy.sprite2d.queue_free()
	enemy.collision_shape2d.queue_free()
