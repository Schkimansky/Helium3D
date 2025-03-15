// [ID]
// mandelbulb
// [INDEX]
// 1
// [VARS]
// [CODE]

vec2 mandelbulb_sdf(vec3 p, float power) {
	vec3 c = p;
	vec3 z = c;
	float orbit_trap = 10000000.0;
	float r = length(z);
	float dz = 1.0;

	for (int i = 0; i < int(iterations); i++) {
		dz = power * pow(r, (power - 1.0) * 0.5) * dz + 2.0;
		
		z = complexPow(z, power) + c;
		
		//else if (fmandelbulb_variant == 4) { z = complexPow(z, power); z += c; z += (cos((c - z) + fhedgebulb_cosine_offset) * fhedgebulb_cosine_multiplier) + (sin(c + z) * fhedgebulb_sine_multiplier); }
		//else if (fmandelbulb_variant == 5) z = complexPow(z, power) + abs(c * z * fboxbloat_abs_multiplier) + cos(c - z * fboxbloat_cosine_multiplier);
		//else if (fmandelbulb_variant == 6) { z = complexPow(z, power); z += c; z += (abs(cos((c - z) * ftrenchbloat_cosine_multiplier1))) - (cos((c - z) * ftrenchbloat_cosine_multiplier2in) * ftrenchbloat_cosine_multiplier2out); }
		//else if (fmandelbulb_variant == 7) { z = complexPow(z, power); z += c; z -= (abs(cos(tan(c * z) * fbasebox_tan_multiplier) * fbasebox_cosine_multiplier1) * fbasebox_abs_multiplier) - (cos(c - z) * fbasebox_cosine_multiplier2); }
		//else if (fmandelbulb_variant == 8) { z = complexPow(z, power); z += c; z = vec3(z.x + log(abs(z.y * fstarbulb_multiplier.y + fstarbulb_adder.y) * fstarbulb_multiplier.x + fstarbulb_adder.x), z.y + log(abs(z.z) * fstarbulb_multiplier.z + fstarbulb_adder.z), z.z + log(abs(z.x) + 1.0)); }
		//else if (fmandelbulb_variant == 9) { z = complexPow(z, power); z -= c; z = vec3(z.y + log(abs(z.x + fwingtail_adder.x) * fwingtail_multiplier.x), (z.y * fwingtail_multiplier.y + fwingtail_adder.y) + log(abs(z.z * fwingtail_multiplier.z + fwingtail_adder.z) + 1.0), z.z + log(abs(z.x) + 1.0)); }
		//else if (fmandelbulb_variant == 10) { z = complexPow(z, power); z += length(negative_sqrt(c * ftribulb_multiplier1)) * (c * ftribulb_multiplier2); }
		//else if (fmandelbulb_variant == 11) { vec3 zminus = negative_sqrt(c * fjuliaswirl_csqrt_multiplier); z += complexPow(z - zminus, power); z -= zminus; }
		//else if (fmandelbulb_variant == 12) { z = complexPow(z, power); z += sin(c * z * ftrijulia_sine_multiplier1); z += cos(c * ftrijulia_cosine_multiplier) - sin(c * ftrijulia_sine_multiplier2); }
		//else if (fmandelbulb_variant == 13) { z = complexPow(z, power); z += sin(c * z * ftangentjulia_sine_multiplier1); z -= cos(c * ftangentjulia_cosine_multiplier) + sin(c * ftangentjulia_sine_multiplier2); }
		//else if (fmandelbulb_variant == 14) { z = complexPow(z, power) - abs(c * z * fjuliaisland_abs_multiplier) - cos((c - z) * fjuliaisland_cosine_multiplier); }
		//else if (fmandelbulb_variant == 15) { z = complexPow(z, power) - abs(c * z * fjuliabloat_abs_multiplier) - cos((c - z) * fjuliabloat_cosine_multiplier1); z += sin((c * z) * fjuliabloat_sine_multiplier1); z += cos(c * fjuliabloat_cosine_multiplier2) + sin(c * fjuliabloat_sine_multiplier2); }
		
		r = length(z);
		
		if (coloring_mode == 0) orbit_trap = min(orbit_trap, dot(z, z));
		else orbit_trap = min(orbit_trap, process_orbit_trap(z));
		
		if (r > escape_radius) break;
	}
	
	return vec2(0.5 * log(r) * sqrt(r) / dz, orbit_trap);
}
