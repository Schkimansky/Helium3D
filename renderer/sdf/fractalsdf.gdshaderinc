//#include "res://renderer/math.gdshaderinc"
//
//float process_orbit_trap(vec3 z) {
	//if (coloring_mode == 1) { return length(z); }
	//if (coloring_mode == 2) { return dot(z, z); }
	//if (coloring_mode == 3) { return sqrt(length(z)); }
	//if (coloring_mode == 4) { return sqrt(dot(z, z)); }
	//if (coloring_mode == 5) { return abs(length(z)); }
	//if (coloring_mode == 6) { return abs(dot(z, z)); }
	//if (coloring_mode == 7) { return log(length(z)); }
	//if (coloring_mode == 8) { return log(dot(z, z)); }
	//if (coloring_mode == 9) { return exp(length(z)); }
	//if (coloring_mode == 10) { return exp(dot(z, z)); }
	//return 0.0;
//}
//
//float process_orbit_trap4d(vec4 z) {
	//if (coloring_mode == 1) { return length(z); }
	//if (coloring_mode == 2) { return dot(z, z); }
	//if (coloring_mode == 3) { return sqrt(length(z)); }
	//if (coloring_mode == 4) { return sqrt(dot(z, z)); }
	//if (coloring_mode == 5) { return abs(length(z)); }
	//if (coloring_mode == 6) { return abs(dot(z, z)); }
	//if (coloring_mode == 7) { return log(length(z)); }
	//if (coloring_mode == 8) { return log(dot(z, z)); }
	//if (coloring_mode == 9) { return exp(length(z)); }
	//if (coloring_mode == 10) { return exp(dot(z, z)); }
	//return 0.0;
//}
//
//#include "formulas/mandelfractal.gdshaderinc"
//#include "formulas/mandelbox.gdshaderinc"
//#include "formulas/sierpinskitetrahedron.gdshaderinc"
//#include "formulas/tetraglad.gdshaderinc"
//#include "formulas/mengersponge.gdshaderinc"
//#include "formulas/pseudoklenian.gdshaderinc"
//#include "formulas/amazingsurf.gdshaderinc"
//#include "formulas/juliabulb4d.gdshaderinc"
//#include "formulas/mengerflake.gdshaderinc"
//#include "formulas/fresnelcube.gdshaderinc"
//#include "formulas/sierpinskidodecahedron.gdshaderinc"
//#include "formulas/sierpinskiicosahedron.gdshaderinc"
//#include "formulas/sierpinskioctahedron.gdshaderinc"
//#include "formulas/bairddelta.gdshaderinc"
//
//vec2 single_fractal_sdf(int formula, vec3 p, float power) {
	//if (formula == 30) return bairddelta_sdf(p, power);
	//if (formula == 29) return sierpinskioctahedron_sdf(p, power);
	//if (formula == 28) return sierpinskiicosahedron_sdf(p, power);
	//if (formula == 27) return sierpinskidodecahedron_sdf(p, power);
	//if (formula == 26) return fresnelcube4d_sdf(p, power);
	//if (formula == 25) return fresnelcube_sdf(p, power);
	//if (formula == 24) return mengerflake_sdf(p, power);
	//if (formula == 23) return sierpinskitetrahedron4d_sdf(p, power);
	//if (formula == 22) return sierpinskitetrahedron_sdf(p, power);
	//if (formula == 21) return tetraglad_sdf(p, power);
	//if (formula == 20) return juliabulb4d_sdf(p, power);
	//if (formula == 19) return amazingsurf_sdf(p, power);
	//if (formula == 18) return pseudoklenian_sdf(p, power);
	//if (formula == 17) return mengersponge_sdf(p, power);
	//if (formula == 16) return mandelbox_sdf(p, power);
	//if (formula <= 15) return mandelfractal(formula, p, power);
//
	//return vec2(0.0, 0.0);
//}
//
//vec2 scene_sdf(vec3 p) {
	//vec2 data_values[5];
	//int total_formulas = 0;
//
	//for (int i = 0; i < 5; i++) {
		//int formula = formulas[i];
		//float power = powers[i];
		//if (formula != 0 && formula != -1) {
			//total_formulas += 1;
			//data_values[i] = single_fractal_sdf(formula, p, power);
		//} else {
			//data_values[i] = vec2(0.0, 0.0);
		//};
	//}
//
	//vec2 combined_data = vec2(0.0);
	//for (int i = 0; i < 5; i++) {
		////combined_data.x += data_values[i].x * formula_weights[i];
		////combined_data.y += data_values[i].y; // / float(total_formulas);
		//combined_data.x += data_values[i].x / float(total_formulas);
		//combined_data.y += data_values[i].y / float(total_formulas);
	//}
//
	//return combined_data.yx;
//}
//
////if (mixing_method == 1) { combined_data.x = smoothstep_mix(combined_data.x, data_values[i].x, formula_weights[i]); }
////else if (mixing_method == 2) { combined_data.x = lerp_mix(combined_data.x, data_values[i].x, formula_weights[i]); }
