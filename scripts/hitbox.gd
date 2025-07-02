extends Area2D


const HitInfo := preload('res://scripts/resources/hit_info.gd')

signal hit_something(victims: Array[Node], hit_info: HitInfo)

@export var hit_info: HitInfo


func check_hit(p_hit_info: HitInfo) -> void:
	var hi := p_hit_info

	if not hi:
		hi = hit_info

	var victims: Array[Node]

	victims.assign(
			get_overlapping_areas()
					.filter(
							func (area: Area2D) -> bool:
								return area.owner != owner))

	hit_something.emit(
			victims,
			p_hit_info)
