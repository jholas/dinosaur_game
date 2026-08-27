extends CharacterBody2D

# dino.gd
# Write a CharacterBody2D script for a 2D side-scrolling endless runner.
# The player has a constant X position. Gravity should apply constantly.
# Implement touch screen jump when tapping the top portion of screen.
# Implement ducking when touching the bottom portion of screen.
# Play AnimatedSprite2D animations: "run", "jump", "duck".

const GRAVITY: float = 2800.0
const JUMP_VELOCITY: float = -1100.0
# Y threshold (as a fraction of viewport height) that separates jump from duck zones.
const DUCK_THRESHOLD: float = 0.70

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var standing_collision: CollisionShape2D = $StandingCollision
@onready var ducking_collision: CollisionShape2D = $DuckingCollision

var is_dead: bool = false
var is_ducking: bool = false
var _duck_touch_id: int = -1
var _jump_requested: bool = false


func _ready() -> void:
	ducking_collision.disabled = true
	animated_sprite.play("run")


func _physics_process(delta: float) -> void:
	if is_dead:
		return

	# Apply gravity, resolving any pending jump before the floor state is cleared.
	if is_on_floor():
		velocity.y = 0.0
		if _jump_requested:
			velocity.y = JUMP_VELOCITY
			_set_ducking(false)
	else:
		velocity.y += GRAVITY * delta
	_jump_requested = false

	# Keep the dino at its fixed X position.
	velocity.x = 0.0

	move_and_slide()

	_update_animation()


func _input(event: InputEvent) -> void:
	if is_dead:
		return

	var viewport_height: float = get_viewport().get_visible_rect().size.y

	if event is InputEventScreenTouch:
		var touch: InputEventScreenTouch = event as InputEventScreenTouch
		if touch.pressed:
			if touch.position.y < viewport_height * DUCK_THRESHOLD:
				# Upper portion → jump.
				_jump_requested = true
			else:
				# Lower portion → start duck.
				_duck_touch_id = touch.index
				_set_ducking(true)
		else:
			# Touch released – stop ducking if this was the duck touch.
			if touch.index == _duck_touch_id:
				_duck_touch_id = -1
				_set_ducking(false)
	elif event.is_action_pressed("jump"):
		_jump_requested = true
	elif event.is_action_pressed("duck"):
		_set_ducking(true)
	elif event.is_action_released("duck"):
		_set_ducking(false)


func _try_jump() -> void:
	if is_on_floor():
		velocity.y = JUMP_VELOCITY
		_set_ducking(false)


func _set_ducking(value: bool) -> void:
	is_ducking = value
	standing_collision.disabled = value
	ducking_collision.disabled = not value


func _update_animation() -> void:
	if not is_on_floor():
		animated_sprite.play("jump")
	elif is_ducking:
		animated_sprite.play("duck")
	else:
		animated_sprite.play("run")


signal died


func die() -> void:
	is_dead = true
	animated_sprite.stop()
	emit_signal("died")
