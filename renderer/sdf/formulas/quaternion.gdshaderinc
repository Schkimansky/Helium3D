vec4 qSquare(vec4 a) { return vec4(a.x*a.x - dot(a.yzw,a.yzw), 2.0*a.x*a.yzw); }
vec4 qCube(vec4 a) { return a * (4.0*a.x*a.x - dot(a,a)*vec4(3.0,1.0,1.0,1.0)); }
float lengthSquared(vec4 a) { return dot(a, a); }

vec2 quaternion_sdf(vec3 p, float power) {
    vec4 c = fquaternion_c; // Should be defined as uniform
    vec4 z = vec4(p, 0.0001);
    float dz = 1.0;
    float m2 = 0.0;
    float orbit_trap = 1000000.0;

    for(int i = 0; i < iterations; i++) {
        vec4 z_pow = qCube(z);
        dz *= 9.0 * lengthSquared(qCube(z));

        z = z_pow + c;
        m2 = dot(z, z);

        orbit_trap = min(orbit_trap, m2);
        if(m2 > escape_radius * escape_radius) break;
    }

	float d = 0.25 * log(m2) * sqrt(m2 / dz);
    return vec2(d, orbit_trap);
}