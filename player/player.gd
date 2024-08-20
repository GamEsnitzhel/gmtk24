extends CharacterBody2D

class_name Player

var m_velocity: Vector2 = Vector2(300, 100);
var m_gravity: float = 980 * 2;
var m_jumpStr: float = 1000;
var m_currentThrowable: Throwable = null;


@onready var m_parts: GPUParticles2D = $GPUParticles2D;

func _ready() -> void:
	$AnimatedSprite2D.play();
	if (Input.is_action_pressed("reset")):
		$AudioStreamPlayer2D3.play();
	else:
		$AudioStreamPlayer2D2.play();

func _process(_delta: float) -> void:
	if (Input.is_action_just_pressed("reset")):
		get_tree().reload_current_scene();

func _physics_process(delta: float):
	if (m_currentThrowable != null && m_currentThrowable.m_isGrow && Input.is_action_pressed("usethrowable")):
		$AudioStreamPlayer2D5.playing = true;
		$AudioStreamPlayer2D5.pitch_scale = scale.x;
		scale += Vector2(1, 1) * delta * m_currentThrowable.m_isGrow;
		scale = scale.clamp(Vector2(0.2, 0.2), Vector2(3.0, 3.0));
	else:
		$AudioStreamPlayer2D5.playing = false;
		var move: float = Input.get_axis("ui_left", "ui_right");
		var targetVel: Vector2 = Vector2(move * m_velocity.x, velocity.y);
		var strength = 750;
		if (move == 0):
			strength *= 1.5;
		elif (sign(move) != sign(velocity.x)):
			strength *= 3;
		velocity = velocity.move_toward(targetVel, strength * delta);
		velocity.y += delta * m_gravity;
		
		if (is_on_floor()):
			velocity.y = 0;
			if (Input.is_action_pressed("ui_accept") || Input.is_action_pressed("ui_up")):
				velocity.y -= m_jumpStr * ((scale.x / 3.0) + (2.0 / 3.0));
				$AudioStreamPlayer2D4.play();
	
		move_and_slide();


	if (m_currentThrowable):
		m_currentThrowable.hide();
		m_currentThrowable.m_collision.disabled = true;
		if (Input.is_action_just_pressed("throwthrowable")):
			m_currentThrowable.show();
			m_currentThrowable.m_collision.disabled = false;
			var mPos: Vector2 = get_global_mouse_position();
			var posDiff: Vector2 = mPos - global_position;
			m_currentThrowable.global_position = global_position + (posDiff.normalized() * (125 * scale.x + 50));
			m_currentThrowable.linear_velocity = posDiff.normalized() * remap(scale.x, 0.2, 3.0, 1000.0, 3.0);
			var velMult: float = 0.5;
			if (m_currentThrowable.m_isGrow == 0):
				velMult = 0.7;
			velocity -= posDiff.normalized() * remap(scale.x, 0.2, 3.0, 1000.0, 3.0) * velMult;
			m_currentThrowable = null;
			m_parts.emitting = false;
			$AudioStreamPlayer2D.play();
