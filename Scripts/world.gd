extends Node2D

@export_subgroup("Slugcats Amount")
@export_range(0, 10, 1.0, "or_greater") var min_slugcats : int = 1
@export_range(0, 10, 1.0, "or_greater") var max_slugcats : int = 10

@export_subgroup("Slugcats Spawn")
@export_range(0, 10, 0.5, "or_greater") var min_spawn_time : float = 0.5
@export_range(0, 10, 0.5, "or_greater") var max_spawn_time : float = 1.0
@export_range(0, 100, 1.0, "suffix:%") var slugpup_prob : float = 50

@export_subgroup("Slugcats Types")
@export var slugcat_types : Array[SlugcatType]
@export var slugpup_types : Array[SlugcatType]

@export_subgroup("References")
@export var wander_zone : Wanderzone
@export var slugcat_scene : PackedScene
@export var slugcat_zone : Node2D

func _enter_tree() -> void:
	var slugs_amount : int = randi_range(min_slugcats, max_slugcats)
	for i in range(0, slugs_amount):
		var slug : Slugcat = _create_slugcat()
		slug.position = wander_zone.get_random_position()
		slug.wander_zone = wander_zone
		slugcat_zone.add_child(slug)
		await get_tree().create_timer(randf_range(min_spawn_time, max_spawn_time)).timeout

func _create_slugcat() -> Slugcat:
	var new_slug : Slugcat = slugcat_scene.instantiate()
	var data : SlugcatData = SlugcatData.generate_random_slugcat(slugpup_prob)
	
	var new_type : SlugcatType
	
	if randi_range(0, 100) <= slugpup_prob:
		new_type = slugpup_types.pick_random()
	else:
		new_type = slugcat_types.pick_random()
	data.type = new_type
	
	new_slug.slugcat_data = data
	return(new_slug)
