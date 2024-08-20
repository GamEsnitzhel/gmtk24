extends StaticBody2D

class_name Lock

@export var m_col: int = 0;

func _ready() -> void:
	modulate = Throwable.GetColourS(m_col);

func _physics_process(_delta: float):
	var overlaps: Array[Node2D] = $Area2D.get_overlapping_bodies();
	for overlap: Node2D in overlaps:
		if !(overlap is Throwable):
			continue;
		var t: Throwable = overlap;
		if (t.m_isGrow == m_col):
			$Area2D/CollisionShape2D.queue_free();
			$AudioStreamPlayer.play();
			global_position = Vector2(-1000, -1000);
			t.queue_free();
