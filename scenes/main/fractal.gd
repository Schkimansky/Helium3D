extends MeshInstance3D

func rangef(floatfrom: float, floatto: float, floatstep: float) -> Array:
	var result := []
	var value := floatfrom
	while value <= floatto:
		result.append(value)
		value += floatstep
	
	return result

func square_3d(zval: Vector3) -> Vector3:
	var x = zval.x
	var y = zval.y
	var z = zval.z
	return Vector3(x * x - y * y - z * z, 2 * x * y, 2 * x * z)

func iterate_3d(z: Vector3, c: Vector3, iterations: int) -> Vector2:
	for i in range(iterations):
		if z.length() >= 2:
			return Vector2(i, 0)
		
		z = square_3d(z) + c
	
	return Vector2(iterations, 1)

func _ready() -> void:
	var points: Array[Vector3] = []
	var size: float = 2
	var step: float = 0.2
	var max_iterations: int = 25
	
	# Collect points that lie inside the fractal
	for x in rangef(-size, size, step):
		for y in rangef(-size, size, step):
			for z in rangef(-size, size, step):
				var data: Vector2 = iterate_3d(Vector3.ZERO, Vector3(x, y, z), max_iterations)
				var is_point_inside_fractal: bool = data.y == 1.0
				
				if is_point_inside_fractal:
					points.append(Vector3(x, y, z))
	
	# Create the mesh from the points
	var generated_mesh = ArrayMesh.new()
	var arrays = []
	arrays.resize(ArrayMesh.ARRAY_CUSTOM_MAX)

	var triangles: Array = []
	var point_count = points.size()

	for i in range(0, point_count, 1):
		for j in range(point_count, 0, -1):
			triangles.append(i)
			triangles.append(j)
			triangles.append(j)

	# Prepare mesh data
	var mesh_data: Array = []
	mesh_data.resize(ArrayMesh.ARRAY_MAX)
	mesh_data[ArrayMesh.ARRAY_VERTEX] = PackedVector3Array(points)
	#mesh_data[ArrayMesh.ARRAY_INDEX] = PackedInt32Array(triangles)
	
	var array_mesh := ArrayMesh.new()
	array_mesh.add_surface_from_arrays(Mesh.PrimitiveType.PRIMITIVE_TRIANGLE_STRIP, mesh_data)
	
	mesh = array_mesh
	#create_trimesh_collision()
