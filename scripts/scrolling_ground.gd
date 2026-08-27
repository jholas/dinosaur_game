extends Node2D

# scrolling_ground.gd
# Write a script for a ParallaxBackground or a textured line.
# Move the texture offset on the X-axis to the left based on global game speed.
# Reset texture offset seamlessly to create an infinite loop.

# Reference to the spawner (or any node that exposes game_speed).
# Set this from the Main scene after the tree is ready.
var spawner: Node = null

@onready var _parallax_background: ParallaxBackground = $ParallaxBackground
@onready var _ground_layer: ParallaxLayer = $ParallaxBackground/GroundLayer
@onready var _cloud_layer: ParallaxLayer = $ParallaxBackground/CloudLayer

# Fallback speed when no spawner is connected.
const DEFAULT_SPEED: float = 400.0
# Cloud moves at a fraction of the ground speed for parallax effect.
const CLOUD_SPEED_FRACTION: float = 0.25

var _ground_offset: float = 0.0
var _cloud_offset: float = 0.0
var _is_running: bool = false


func start() -> void:
	_is_running = true


func stop() -> void:
	_is_running = false


func _process(delta: float) -> void:
	if not _is_running:
		return

	var speed: float = DEFAULT_SPEED
	if spawner != null and "game_speed" in spawner:
		speed = spawner.game_speed

	# Advance offsets.
	_ground_offset -= speed * delta
	_cloud_offset -= speed * CLOUD_SPEED_FRACTION * delta

	# Apply offsets to the parallax layers' motion_offset.
	_ground_layer.motion_offset.x = _ground_offset
	_cloud_layer.motion_offset.x = _cloud_offset
