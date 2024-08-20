extends Area2D

@export var m_next: String = "";

func _physics_process(_delta: float):
	var overlaps: Array[Node2D] = get_overlapping_bodies();
	for overlap: Node2D in overlaps:
		if !(overlap is Player):
			continue;
		Change();
	if (Input.is_action_just_pressed("ui_cancel")):
		Change();

func Change() -> void:
	if (m_next != ""):
		get_tree().change_scene_to_file(m_next);
	else:
		get_tree().change_scene_to_file("res://levels/menu.tscn");
