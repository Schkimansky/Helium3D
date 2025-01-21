@tool
extends Node3D

@export var rotate_speed = 1.0

func _process(delta: float) -> void:
	$GpuFractal.rotation_degrees.y += delta * 14 * 1.75 * rotate_speed
	$GpuFractal.rotation_degrees.z += delta * 6 * 1.75 * rotate_speed
	$GpuFractal.rotation_degrees.x += delta * 3 * 1.75 * rotate_speed
	
	#Engine.time_scale = sin(Time.get_unix_time_from_system() * 0.8) + 1.2
	
