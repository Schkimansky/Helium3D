#include "res://renderer/math.gdshaderinc"

///////////////////////////////
// Mandelbulb and variations //
///////////////////////////////

vec2 mandelfractal(int fractal_id, vec3 p) {
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


    float min_dist = 10000000.0;
    float r = length(z);
    float dz = 1.0;
    float powercache1 = (power - 1.0) * 0.5;

    for (int i = 0; i < int(iterations); i++) {
        dz = power * pow(r, powercache1) * dz + 1.0;
        float th = power * fast_acos(z.z / r);
        float ph = power * atan(z.y, z.x);
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
        min_dist = min(min_dist, distance(z, vec3(0.0, 0.0, 0.0)));

        if (r > escape_radius) break;
    }

    return vec2(0.5 * log(r) * sqrt(r) / dz, min_dist);
}

///////////////
// Mandelbox //
///////////////

// Some algorithms
float sphereFold(vec4 z, float minR, float maxR, float bloatFactor) { float r2 = dot(z.xyz, z.xyz); return max(maxR / max(minR, r2), bloatFactor); }
void boxFold(inout vec4 z, vec3 r) { z.xyz = clamp(z.xyz, -r, r) * 2.0 - z.xyz; }
float de_box(vec4 p, vec3 s) { vec3 a = abs(p.xyz) - s; return (min(max(max(a.x, a.y), a.z), 0.0) + length(max(a, 0.0))) / p.w; }

vec2 mandelbox_sdf(vec3 pos) {
	vec4 p = vec4(pos, 1.0);
	p *= 4.0;
	vec4 o = p;
	float min_dist = 100000000.0;

	for (int i = 0; i < iterations; i++) {
		boxFold(p, fmandelbox_box_size);
		p *= sphereFold(p, fmandelbox_sphere_fold.x, fmandelbox_sphere_fold.y, fmandelbox_sphere_fold.z) * power;
		p += o * fmandelbox_spread;
		p += sin(o) * fmandelbox_stoneness;
		p += sin(o - p) * fmandelbox_divisions;
		p += vec4(sphereInversion(p.xyz, fmandelbox_sphere_reflection_position, fmandelbox_sphere_reflection), 0.0);

		min_dist = min(min_dist, sphere_sdf4d(p, vec4(0.0, 0.0, 0.0, 0.0), 1.0));
	}

	return vec2(de_box(p, vec3(10, 10, 10)), float(min_dist));
}

vec2 mengersponge_sdf(vec3 p){
    float d = cube_sdf3d(p, vec3(1));
    float res = d;
    float s = 1.0;
    for(int m = 0; m < iterations; m++) {
        vec3 a = mod(p * s, 2.0) - 1.0;
        s *= power + 1.0;
        vec3 r = abs(1.0 - (power + 1.0) * abs(a));

        float da = max(r.x, r.y);
        float db = max(r.y, r.z);
        float dc = max(r.z, r.x);
        float c = (min(da, min(db, dc)) - 1.0) / s;

		if (c > d) {
			d = c;
			res = c;
		}
	}
	return vec2(res, 0.0);
}

///////////////
// Scene SDF //
///////////////

vec2 scene_sdf(vec3 p) {
	vec2 data_values[10];
	int total_formulas = 0;

	for (int i = 0; i < 10; i++) {
		int formula = formulas[i];
		if (formula == 0) continue;
		total_formulas += 1;

		//if (i == 1 && data_values[0].x > 0.03) return data_values[0].yx;

		if (formula == 17) data_values[i] = mengersponge_sdf(p);
		else if (formula == 16) data_values[i] = mandelbox_sdf(p);
		else if (formula <= 15) data_values[i] = mandelfractal(formula, p);
	}

	vec2 combined_data = vec2(0.0);
	for (int i = 0; i < total_formulas; i++) {
		data_values[i].x /= float(total_formulas);
		combined_data.x += data_values[i].x * formula_weights[i];
		combined_data.y += data_values[i].y / float(total_formulas);
	}

	return combined_data.yx;
}
