extends RigidBody2D

class_name Throwable

@export var m_isGrow: int = 1;

@onready var m_area: Area2D = $Area2D;
@onready var m_collision: CollisionShape2D = $CollisionShape2D;

func _ready() -> void:
	modulate = GetColour();
	$AnimatedSprite2D.play();

func _physics_process(_delta: float):
	var overlaps: Array[Node2D] = m_area.get_overlapping_bodies();
	for overlap: Node2D in overlaps:
		if !(overlap is Player):
			continue;
		var p: Player = overlap;
		if (p.m_currentThrowable != null):
			continue;
		$AudioStreamPlayer2D.play();
		p.m_currentThrowable = self;
		p.m_parts.emitting = true;
		p.m_parts.modulate = GetColour();


func GetColour() -> Color:
	if (m_isGrow == 1):
		return Color.BLUE_VIOLET;
	if (m_isGrow == -1):
		return Color.RED;
	return Color.GREEN;


static func GetColourS(colour: int) -> Color:
	if (colour == 1):
		return Color.BLUE_VIOLET;
	if (colour == -1):
		return Color.RED;
	return Color.GREEN;
