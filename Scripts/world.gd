extends Node2D

@export_subgroup("Slugcats Amount")
@export_range(0, 10, 1.0, "or_greater") var min_slugcats : int = 1
@export_range(0, 10, 1.0, "or_greater") var max_slugcats : int = 10

@export_subgroup("Slugcats Spawn")
@export_range(0, 10, 0.5, "or_greater") var min_spawn_time : float = 0.5
@export_range(0, 10, 0.5, "or_greater") var max_spawn_time : float = 1.0
@export_range(0, 100, 1.0, "suffix:%") var slugpup_prob : float = 50
@export_range(0, 100, 1.0, "suffix:%") var mother_prob : float = 30
@export_range(1, 5, 1, "or_greater") var min_pups : int = 1
@export_range(1, 5, 1, "or_greater") var max_pups : int = 3

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
		
		if (randi_range(0, 100) <= mother_prob) and (not slug.slugcat_data.is_slugpup()):
			for pup_index in range(1, randi_range(min_pups, max_pups)):
				var slug_pup : Slugcat = _create_slugpup(slug)
				slug_pup.position = wander_zone.get_point_near_point(slug.position, 10, 20)
				slug_pup.wander_zone = wander_zone
				slugcat_zone.add_child(slug_pup)
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

func _create_slugpup(leader : Slugcat) -> Slugcat:
	var new_slug : Slugcat = _create_slugcat()
	new_slug.slugcat_data.type = slugpup_types.pick_random()
	new_slug.slugcat_data.leader = leader
	return(new_slug)
