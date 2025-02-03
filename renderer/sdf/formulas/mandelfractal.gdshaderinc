vec2 mandelfractal(int fractal_id, vec3 p, float power) {
    vec3 scaled_p = p;
    vec3 z;
    vec3 c;
    if (fractal_id == 2) {
        z = scaled_p;
        c = fjuliabulb_c;
	} else if (fractal_id == 11) {
        z = scaled_p;
        c = fjuliaswirl_c;
	} else if (fractal_id == 12) {
        z = scaled_p;
        c = ftrijulia_c;
	} else if (fractal_id == 13) {
        z = scaled_p;
        c = ftangentjulia_c;
	} else if (fractal_id == 14) {
        z = scaled_p;
        c = fjuliaisland_c;
	} else if (fractal_id == 15) {
        z = scaled_p;
        c = fjuliabloat_c;
	} else {
        z = vec3(0.00001, 0.0, 0.0);
        c = scaled_p;
	}

    float orbit_trap = 10000000.0;
    float r = length(z);
    float dz = 1.0;
    float powercache1 = (power - 1.0) * 0.5;

    for (int i = 0; i < int(iterations); i++) {
        dz = power * pow(r, powercache1) * dz + 2.0;
        if (fractal_id == 3) z = abs(z);

        if (fractal_id <= 3) { z = complexPow(z, power); z += c; }
        else if (fractal_id == 4) { z = complexPow(z, power); z += c; z += (cos((c - z) + fhedgebulb_cosine_offset) * fhedgebulb_cosine_multiplier) + (sin(c + z) * fhedgebulb_sine_multiplier); }
        else if (fractal_id == 5) z = complexPow(z, power) + abs(c * z * fboxbloat_abs_multiplier) + cos(c - z * fboxbloat_cosine_multiplier);
        else if (fractal_id == 6) { z = complexPow(z, power); z += c; z += (abs(cos((c - z) * ftrenchbloat_cosine_multiplier1))) - (cos((c - z) * ftrenchbloat_cosine_multiplier2in) * ftrenchbloat_cosine_multiplier2out); }
        else if (fractal_id == 7) { z = complexPow(z, power); z += c; z -= (abs(cos(tan(c * z) * fbasebox_tan_multiplier) * fbasebox_cosine_multiplier1) * fbasebox_abs_multiplier) - (cos(c - z) * fbasebox_cosine_multiplier2); }
        else if (fractal_id == 8) { z = complexPow(z, power); z += c; z = vec3(z.x + log(abs(z.y * fstarbulb_multiplier.y + fstarbulb_adder.y) * fstarbulb_multiplier.x + fstarbulb_adder.x), z.y + log(abs(z.z) * fstarbulb_multiplier.z + fstarbulb_adder.z), z.z + log(abs(z.x) + 1.0)); }
        else if (fractal_id == 9) { z = complexPow(z, power); z -= c; z = vec3(z.y + log(abs(z.x + fwingtail_adder.x) * fwingtail_multiplier.x), (z.y * fwingtail_multiplier.y + fwingtail_adder.y) + log(abs(z.z * fwingtail_multiplier.z + fwingtail_adder.z) + 1.0), z.z + log(abs(z.x) + 1.0)); }
        else if (fractal_id == 10) { z = complexPow(z, power); z += length(negative_sqrt(c * ftribulb_multiplier1)) * (c * ftribulb_multiplier2); }
        else if (fractal_id == 11) { vec3 zminus = negative_sqrt(c * fjuliaswirl_csqrt_multiplier); z += complexPow(z - zminus, power); z -= zminus; }
        else if (fractal_id == 12) { z = complexPow(z, power); z += sin(c * z * ftrijulia_sine_multiplier1); z += cos(c * ftrijulia_cosine_multiplier) - sin(c * ftrijulia_sine_multiplier2); }
        else if (fractal_id == 13) { z = complexPow(z, power); z += sin(c * z * ftangentjulia_sine_multiplier1); z -= cos(c * ftangentjulia_cosine_multiplier) + sin(c * ftangentjulia_sine_multiplier2); }
        else if (fractal_id == 14) { z = complexPow(z, power) - abs(c * z * fjuliaisland_abs_multiplier) - cos((c - z) * fjuliaisland_cosine_multiplier); }
        else if (fractal_id == 15) { z = complexPow(z, power) - abs(c * z * fjuliabloat_abs_multiplier) - cos((c - z) * fjuliabloat_cosine_multiplier1); z += sin((c * z) * fjuliabloat_sine_multiplier1); z += cos(c * fjuliabloat_cosine_multiplier2) + sin(c * fjuliabloat_sine_multiplier2); }

        r = length(z);
        orbit_trap = min(orbit_trap, dot(z, z));

        if (r > escape_radius) break;
    }

    return vec2(0.5 * log(r) * sqrt(r) / dz, orbit_trap);
}
