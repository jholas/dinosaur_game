extends Area2D

# pterodactyl.gd
# Flying obstacle that appears after score >= 500.
# Has a 2-frame wing-flap animation and three flight heights
# (set externally by the spawner).

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

var _speed: float = 400.0


func _ready() -> void:
	animated_sprite.play("fly")
	body_entered.connect(_on_body_entered)


func set_speed(speed: float) -> void:
	_speed = speed


func _physics_process(delta: float) -> void:
	position.x -= _speed * delta
	if position.x < -200.0:
		queue_free()


func _on_body_entered(body: Node) -> void:
	if body.is_in_group("player"):
		body.die()
