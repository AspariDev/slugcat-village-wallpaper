extends CollisionShape2D
class_name Wanderzone

func get_random_position() -> Vector2:
	var rect : Rect2 = shape.get_rect()
	var pos : Vector2 = rand_inside_unit_rectangle(global_position, rect.size)
	return(pos)

func rand_inside_unit_rectangle(origin: Vector2 = Vector2.ZERO, dimensions: Vector2 = Vector2.ONE) -> Vector2:
	var x_min: float = origin.x - (dimensions.x / 2)
	var x_max: float = origin.x + (dimensions.x / 2)
	
	var y_min: float = origin.y - (dimensions.y / 2)
	var y_max: float = origin.y + (dimensions.y / 2)
	
	var x_point: float = randf_range(x_min, x_max)
	var y_point: float = randf_range(y_min, y_max)
	
	return Vector2(x_point, y_point)
