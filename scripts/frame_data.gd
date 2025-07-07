extends Object


signal cancel_requested


@export var is_invulnerable: bool
@export var can_queue_next: bool


func reset() -> void:
	is_invulnerable = false
	can_queue_next = false


func request_cancel() -> void:
	cancel_requested.emit()
