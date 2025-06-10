@icon("res://Assets/ClassIcons/Survivor_icon_(custom).webp")
extends Resource
class_name SlugcatData

const NAMES_LIST : Array[String] = []
const SATURATION : float = 0.9

@export var name : String
@export var body_color : Color = Color.WHITE
@export var eyes_color : Color = Color.BLACK
@export var type : SlugcatType

var leader : Slugcat = null

@export_subgroup("Personality")
@export_range(3, 10, 0.5) var calmness : float = 5
@export_range(3, 10, 0.5) var energic : float = 5
@export_range(3, 10, 0.5) var explorer : float = 5
@export_range(0, 3, 0.5) var loving : float = 5
# PERSONALIDAD
# Nerviosismo: - Impaciencia para quedarse quieto
# Energico: Movilidad para ir a sitios
# Explorador: Energía para ir lejos

static func generate_random_slugcat(pup_percentage := 50) -> SlugcatData:
	var new_data : SlugcatData = SlugcatData.new()
	
	# Color
	var body_color : Color = Color(randf_range(0, SATURATION), randf_range(0, SATURATION), randf_range(0, SATURATION))
	var eyes_color = Color(1 - body_color.r, 1 - body_color.g, 1 - body_color.b)
	
	new_data.body_color = body_color
	new_data.eyes_color = eyes_color
	
	
	# Personality
	new_data.calmness = roundf(randf_range(3, 10))
	new_data.energic = roundf(randf_range(3, 10))
	new_data.explorer = roundf(randf_range(3, 10))
	new_data.loving = roundf(randf_range(0, 3))
	return new_data

static func get_trait_multiplier(personality_trait : float) -> float:
	return((personality_trait * 2) / 10)

func is_slugpup() -> bool:
	return(type.slugpup)
	
