
float process_orbit_trap(float ot) {
	//ot *= orbit_trap_scale;
	if (orbit_trap_modifier == 1) return ot;
	else if (orbit_trap_modifier == 2) return sqrt(ot);
	else if (orbit_trap_modifier == 3) return log(ot);
	else if (orbit_trap_modifier == 4) return exp(ot);

	return ot;
}
