vec4 qSquare(vec4 a) { return vec4(a.x*a.x - dot(a.yzw,a.yzw), 2.0*a.x*a.yzw); }
vec4 qCube(vec4 a) { return a * (4.0*a.x*a.x - dot(a,a)*vec4(3.0,1.0,1.0,1.0)); }
vec4 qPow5(vec4 a) {
    vec4 a2 = vec4(a.x * a.x - dot(a.yzw, a.yzw), 2.0 * a.x * a.yzw);
    vec4 a4 = vec4(a2.x * a2.x - dot(a2.yzw, a2.yzw), 2.0 * a2.x * a2.yzw);
    return vec4(a4.x * a.x - dot(a4.yzw, a.yzw), 2.0 * a4.x * a.yzw);
}
float lengthSquared(vec4 a) { return dot(a, a); }

vec4 hyperspherical_power(vec4 z, float power) {
    float r = length(z);
    float theta = acos(z.x / r);
    float phi = atan(z.y, z.z);
    float psi = atan(length(z.yz), z.w);

    r = pow(r, power);
    theta *= power;
    phi *= power;
    psi *= power;

    return r * vec4(cos(theta), sin(theta) * cos(phi), sin(theta) * sin(phi) * cos(psi), sin(theta) * sin(phi) * sin(psi));
}

vec2 juliabulb4d_sdf(vec3 p, float power) {
    //vec4 c = fquaternion_c;
    //vec4 z = vec4(p, 0.0001);
    vec4 z = vec4(p, 0.0001);
    vec4 c = fquaternion_c;
    float dz = 1.0;
    float m2 = 0.0;
    float orbit_trap = 1000000.0;

    for(int i = 0; i < iterations; i++) {
		vec4 z_pow = qSquare(z);
        dz *= 9.0 * length(z_pow);

        z = z_pow + c;
        m2 = dot(z, z);

        orbit_trap = min(orbit_trap, m2);
        if(m2 > escape_radius * escape_radius) break;
    }

	float d = 0.25 * log(m2) * sqrt(m2 / dz);
    return vec2(d, orbit_trap);
}