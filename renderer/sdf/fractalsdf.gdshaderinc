#include "res://renderer/math.gdshaderinc"
#include "formulas/mandelfractal.gdshaderinc"
#include "formulas/mandelbox.gdshaderinc"
#include "formulas/mengersponge.gdshaderinc"
#include "formulas/pseudoklenian.gdshaderinc"
#include "formulas/quaternion.gdshaderinc"
#include "formulas/amazingsurf.gdshaderinc"

vec2 scene_sdf(vec3 p) {
	vec2 data_values[2];
	int total_formulas = 0;

	for (int i = 0; i < 2; i++) {
		int formula = formulas[i];
		float power = powers[i];
		if (formula != 0) {
			total_formulas += 1;
			
			if (formula == 20) data_values[i] = quaternion_sdf(p, power);
			if (formula == 19) data_values[i] = amazingsurf_sdf(p, power);
			else if (formula == 18) data_values[i] = pseudoklenian_sdf(p, power);
			else if (formula == 17) data_values[i] = mengersponge_sdf(p, power);
			else if (formula == 16) data_values[i] = mandelbox_sdf(p, power);
			if (formula <= 15) data_values[i] = mandelfractal(formula, p, power);
		} else {
			data_values[i] = vec2(0.0, 0.0);
		};
	}

	vec2 combined_data = vec2(0.0);
	for (int i = 0; i < 2; i++) {
		//combined_data.x += data_values[i].x * formula_weights[i];
		//combined_data.y += data_values[i].y; // / float(total_formulas);
		combined_data.x += data_values[i].x / float(total_formulas);
		combined_data.y += data_values[i].y / float(total_formulas);
	}
	
	return combined_data.yx;
}

//if (mixing_method == 1) { combined_data.x = smoothstep_mix(combined_data.x, data_values[i].x, formula_weights[i]); }
//else if (mixing_method == 2) { combined_data.x = lerp_mix(combined_data.x, data_values[i].x, formula_weights[i]); }
