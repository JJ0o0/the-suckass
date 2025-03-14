extends Node3D

@onready var locations: Node3D = $locations

@export var piece_model : PackedScene
@export var collectables_quantity : int = 6

func _ready() -> void:
	_distribute_collectables()

func _process(delta: float) -> void:
	if GameManager.collected.size() != collectables_quantity:
		return
	
	print("collected all")

func _distribute_collectables() -> void:
	for i in collectables_quantity:
		var collectable = piece_model.instantiate()
		
		var random_location = locations.get_children().pick_random()
		while random_location.get_child_count() > 0:
			random_location = locations.get_children().pick_random()
		
		random_location.add_child(collectable)
		
		GameManager.collectables.append(collectable)
		collectable.position = Vector3.ZERO
		collectable.collect.connect(func(): 
			GameManager.collected.append(collectable)
		)
