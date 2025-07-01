@tool
extends Object


signal set_target_variable(property: StringName, new_value: Variant, old_value: Variant, success: bool)

var target: Object
var forward_gets: bool
var forward_sets: bool


func _get_property_list() -> Array[Dictionary]:
	var property_list: Array[Dictionary] = [
		{
			'name': 'target',
			'type': TYPE_OBJECT,
			'hint': PROPERTY_HINT_NODE_TYPE,
		},
		{
			'name': 'forward_gets',
			'type': TYPE_BOOL,
		},
		{
			'name': 'forward_sets',
			'type': TYPE_BOOL,
		},
		{
			'name': 'custom_property_list',
			'type': TYPE_ARRAY,
		},
	]

	if target:
		property_list.append_array(ClassDB.class_get_property_list(target.get_class()))

	return property_list


func _get(property: StringName) -> Variant:
	if not target:
		return null

	if forward_gets and property in target:
		return target.get(property)

	return null


func _set(property: StringName, value: Variant) -> bool:
	var old_value = null
	var success := not not target

	if success and forward_sets and property in target:
		old_value = target.get(property)
		target.set(property, value)
		success = true

	set_target_variable.emit(property, value, old_value, success)

	return success


func target_callv(method: StringName, args: Array) -> void:
	target.callv(method, args)
