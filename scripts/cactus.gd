extends Area2D

# cactus.gd
# Obstacle that moves from right to left.
# Comes in three variations controlled by a CactusType enum.

enum CactusType { SMALL_SINGLE, LARGE_SINGLE, CLUSTER }

@export var cactus_type: CactusType = CactusType.SMALL_SINGLE

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

var _speed: float = 400.0


func _ready() -> void:
	# Choose a random variation if none was set explicitly.
	cactus_type = CactusType.values()[randi() % CactusType.size()]
	_apply_type()

	# Connect to player collision signal.
	body_entered.connect(_on_body_entered)


func set_speed(speed: float) -> void:
	_speed = speed


func _physics_process(delta: float) -> void:
	position.x -= _speed * delta
	# Remove once safely off-screen to the left.
	if position.x < -200.0:
		queue_free()


func _apply_type() -> void:
	match cactus_type:
		CactusType.SMALL_SINGLE:
			animated_sprite.play("small_single")
		CactusType.LARGE_SINGLE:
			animated_sprite.play("large_single")
		CactusType.CLUSTER:
			animated_sprite.play("cluster")


func _on_body_entered(body: Node) -> void:
	if body.is_in_group("player"):
		body.die()
