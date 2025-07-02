extends Node


const Health := preload('res://scripts/health.gd')

signal healed(amount: float)
signal damaged(amount: float)
signal depleted

static var _registry: Dictionary[Node, Health]

@export var target: Node
@export var amount: float = 100


static func try_get_from(node: Node) -> Health:
	if node in _registry:
		return _registry[node]

	if node.has_meta(&'belmondo'):
		var belmondo = node.get_meta(&'belmondo')

		if belmondo is Dictionary:
			var health = belmondo.get(&'beat_em_up/health')

			if health is Health:
				return health

	return null


func _ready() -> void:
	try_give_to(get_parent())


func try_give_to(node: Node) -> bool:
	if not node.has_meta(&'belmondo'):
		node.set_meta(&'belmondo',{})

	var belmondo = node.get_meta(&'belmondo')

	if belmondo is Dictionary:
		belmondo.set(&'beat_em_up/health', self)
		_registry[node] = self

		node.tree_exiting.connect(func () -> void:
			_registry.erase(node))

	return false


func heal(p_amount: float) -> void:
	amount += p_amount
	healed.emit(p_amount)


func damage(p_amount: float) -> void:
	amount -= p_amount
	damaged.emit(p_amount)

	if amount <= 0:
		depleted.emit()
