extends CharacterBody2D
class_name pinto_character

signal game_over

const PINTO_1 = preload("res://textures/sprites/pinto1.png")
const PINTO_2 = preload("res://textures/sprites/pinto2.png")
@onready var pinto_sprite: Sprite2D = %PintoSprite
@onready var sprite_change_timer: Timer = %SpriteChangeTimer

const SPEED = 110.0
const JUMP_VELOCITY = -300.0
const GRAVITY = 980

func _input(event: InputEvent) -> void:
	if event is InputEventScreenTouch:
		jump()
		await get_tree().create_timer(0.1).timeout

func _physics_process(delta: float) -> void:
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		if collision and not Global.emit_one_time:
			game_over.emit()
			Global.emit_one_time = true
	velocity += get_gravity() * delta
	
	if Input.is_action_just_pressed("ui_accept"):
		jump()
	
	velocity.x = SPEED
	
	move_and_slide()

func _on_sprite_change_timer_timeout() -> void:
	pinto_sprite.texture = PINTO_1

func jump() -> void:
	pinto_sprite.texture = PINTO_2
	sprite_change_timer.start()
	velocity.y = JUMP_VELOCITY
