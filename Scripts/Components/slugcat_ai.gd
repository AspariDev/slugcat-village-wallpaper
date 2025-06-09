extends Node

@onready var slugcat: Slugcat = get_parent()

var wander_zone : CollisionShape2D

func move() -> void:
	var pos : Vector2 = get_random_position()
	var tween : Tween = create_tween()
	tween.tween_property(get_parent(), "position", pos, randf_range(3, 10)).from_current()\
	.set_ease(Tween.EASE_OUT_IN)
	print(pos)
	await tween.finished
	await get_tree().create_timer(randf_range(4, 15)).timeout
	move()

func get_random_position() -> Vector2:
	var rect : Rect2 = wander_zone.shape.get_rect()
	return(rand_inside_unit_rectangle(wander_zone.global_position, rect.size))

func rand_inside_unit_rectangle(origin: Vector2 = Vector2.ZERO, dimensions: Vector2 = Vector2.ONE) -> Vector2:
	var x_min: float = origin.x - (dimensions.x / 2)
	var x_max: float = origin.x + (dimensions.x / 2)
	
	var y_min: float = origin.y - (dimensions.y / 2)
	var y_max: float = origin.y + (dimensions.y / 2)
	
	var x_point: float = randf_range(x_min, x_max)
	var y_point: float = randf_range(y_min, y_max)
	
	return Vector2(x_point, y_point)
