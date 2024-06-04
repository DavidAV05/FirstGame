extends TileMap

@export var INVISIBLE_WALLS_ATLAS: Vector2i = Vector2i(9, 7)
@export var GROUND_LAYER: int = 1
@export var MAIN_SOURCE = 0

@onready var CELLS_TILEMAP_COORDS = get_used_cells(GROUND_LAYER)

const neighbour_coords = [
	Vector2i(0, 1),
	Vector2i(1, 0),
	Vector2i(-1, 0),
	Vector2i(0, -1)
]


# Called when the node enters the scene tree for the first time.
func _ready():
	for cell_coords in CELLS_TILEMAP_COORDS:
		for neighbour_coord in neighbour_coords:
			var current_cell_coords = cell_coords + neighbour_coord
			
			if get_cell_source_id(GROUND_LAYER, current_cell_coords) == -1:
				set_cell(GROUND_LAYER, current_cell_coords, MAIN_SOURCE, INVISIBLE_WALLS_ATLAS)


func is_tile_collision(coords: Vector2i) -> bool:
	var tile_data: TileData = get_cell_tile_data(GROUND_LAYER, coords)
	if not tile_data:
		return false
	
	return true
