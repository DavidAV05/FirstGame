extends Node2D

@onready var inventory : Inventory = $Inventory

func _physics_process(delta):
	if inventory:
		print("Hive inventory:", inventory.get_total_pollen())

func _on_area_2d_body_entered(body : Player):
	if body is Player:
		var n_pollen : int = body.inventory.get_total_pollen()
		body.inventory.remove_pollen(n_pollen)
		self.inventory.add_pollen(n_pollen)
