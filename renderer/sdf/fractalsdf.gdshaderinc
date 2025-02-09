#include "res://renderer/math.gdshaderinc"
#include "formulas/mandelfractal.gdshaderinc"
#include "formulas/mandelbox.gdshaderinc"
#include "formulas/sierpinski.gdshaderinc"
#include "formulas/tetraglad.gdshaderinc"
#include "formulas/mengersponge.gdshaderinc"
#include "formulas/pseudoklenian.gdshaderinc"
#include "formulas/amazingsurf.gdshaderinc"
#include "formulas/quaternion.gdshaderinc"
#include "formulas/mengerflake.gdshaderinc"

vec2 single_fractal_sdf(int formula, vec3 p, float power) {
	if (formula == 24) return mengerflake_sdf(p, power);  // mengerflake_sdf
	else if (formula == 23) return sierpinski4d_sdf(p, power);
	else if (formula == 22) return sierpinski_sdf(p, power);
	else if (formula == 21) return tetraglad_sdf(p, power);
	else if (formula == 20) return quaternion_sdf(p, power);
	else if (formula == 19) return amazingsurf_sdf(p, power);
	else if (formula == 18) return pseudoklenian_sdf(p, power);
	//else if (formula == 17) return mengersponge_sdf(p, power);
	else if (formula == 16) return mandelbox_sdf(p, power);
	//else if (formula <= 15) return mandelfractal(formula, p, power);
}

vec2 scene_sdf(vec3 p) {
	vec2 data_values[5];
	int total_formulas = 0;

	for (int i = 0; i < 5; i++) {
		int formula = formulas[i];
		float power = powers[i];
		if (formula != 0 && formula != -1) {
			total_formulas += 1;
			data_values[i] = single_fractal_sdf(formula, p, power);
		} else {
			data_values[i] = vec2(0.0, 0.0);
		};
	}

	vec2 combined_data = vec2(0.0);
	for (int i = 0; i < 5; i++) {
		//combined_data.x += data_values[i].x * formula_weights[i];
		//combined_data.y += data_values[i].y; // / float(total_formulas);
		combined_data.x += data_values[i].x / float(total_formulas);
		combined_data.y += data_values[i].y / float(total_formulas);
	}

	return combined_data.yx;

	//return single_fractal_sdf(formulas[0], p, powers[0]).yx;
}

//if (mixing_method == 1) { combined_data.x = smoothstep_mix(combined_data.x, data_values[i].x, formula_weights[i]); }
//else if (mixing_method == 2) { combined_data.x = lerp_mix(combined_data.x, data_values[i].x, formula_weights[i]); }
