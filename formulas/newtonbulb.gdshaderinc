// [ID]
// newtonbulb
// [INDEX]
// 15
// [VARS]
// float power[1.0, 8.0] = 3.0
// vec3 solution[(-2.0, -2.0, -2.0), (2.0, 2.0, 2.0)] = (1.0, 0.0, 0.0)
// float de_scale1[0.1, 5.0] = 1.0
// float de_offset1[0.0, 1.0] = 0.0
// bool julia[false, true] = true
// vec3 julia_c[(-2.0, -2.0, -2.0), (2.0, 2.0, 2.0)] = (-1.0, 0.0, 0.0)
// [CODE]
uniform float fnewtonbulb_power;
uniform vec3 fnewtonbulb_solution;
uniform float fnewtonbulb_factor_phi = 1.0;
uniform float fnewtonbulb_factor_theta = 1.0;
uniform float fnewtonbulb_fake_bailout = 1.0;
uniform float fnewtonbulb_de_scale1;
uniform float fnewtonbulb_de_offset1;
uniform float fnewtonbulb_offset = 0.0001;
uniform float fnewtonbulb_bailout = 4.0;
uniform bool fnewtonbulb_julia;
uniform vec3 fnewtonbulb_julia_c;
uniform bool fnewtonbulb_enable_pre_folding;
uniform vec3 fnewtonbulb_pre_angle_xyz;
uniform float fnewtonbulb_pre_folding;
uniform bool fnewtonbulb_enable_post_folding;
uniform vec3 fnewtonbulb_post_angle_xyz;
uniform float fnewtonbulb_post_folding;

// Helper math functions for the Newton fractal
mat3 rotationMatrixXYZ(vec3 angles) {
    float a = radians(angles.x);
    float b = radians(angles.y);
    float c = radians(angles.z);

    float cosA = cos(a);
    float sinA = sin(a);
    float cosB = cos(b);
    float sinB = sin(b);
    float cosC = cos(c);
    float sinC = sin(c);

    mat3 rotX = mat3(
        vec3(1.0, 0.0, 0.0),
        vec3(0.0, cosA, -sinA),
        vec3(0.0, sinA, cosA)
    );

    mat3 rotY = mat3(
        vec3(cosB, 0.0, sinB),
        vec3(0.0, 1.0, 0.0),
        vec3(-sinB, 0.0, cosB)
    );

    mat3 rotZ = mat3(
        vec3(cosC, -sinC, 0.0),
        vec3(sinC, cosC, 0.0),
        vec3(0.0, 0.0, 1.0)
    );

    return rotX * rotY * rotZ;
}

float newton_sdf(vec3 pos) {
    vec4 orbitTrap = vec4(1000.0);
    float sq_r, r, r1, dr, theta, phi, r_pow, theta_pow, phi_pow, pow_eff, fac_eff, cth, cph, sph, sth, tmpx, tmpy, tmpz, tmpx2, tmpy2, tmpz2, r_zxy, r_cxy, h, scale;
    vec3 z = pos;
    vec3 c;
    mat3 rotMatrix;

    pow_eff = 1.0 - fnewtonbulb_power;
    fac_eff = (fnewtonbulb_power - 1.0)/fnewtonbulb_power;
    r1 = length(z);
    dr = 1.0;
    scale = 1.0;
    int i = 0;
    c = (fnewtonbulb_julia ? fnewtonbulb_julia_c : pos);

    while(r1 < fnewtonbulb_bailout && (i < iterations)) {
        dr = dr * r1 * 2.0;

        // Pre - Rotation Folding
        if (fnewtonbulb_enable_pre_folding) {
            rotMatrix = rotationMatrixXYZ(fnewtonbulb_pre_angle_xyz);
            z = z * rotMatrix;
            z.x = abs(z.x + fnewtonbulb_pre_folding) - abs(z.x - fnewtonbulb_pre_folding) - z.x;
            z = rotMatrix * z;
        }

        sq_r = fnewtonbulb_fake_bailout/(dot(z,z) + fnewtonbulb_offset);
        z.x = z.x*sq_r + fnewtonbulb_solution.x;
        z.y = -z.y*sq_r + fnewtonbulb_solution.y;
        z.z = -z.z*sq_r + fnewtonbulb_solution.z;

        sq_r = dot(z,z);
        r = sqrt(sq_r);
        phi = fnewtonbulb_factor_phi*asin(z.z/r);
        theta = fnewtonbulb_factor_theta*atan(z.y,z.x);

        r_pow = pow(r, pow_eff);
        phi_pow = phi*pow_eff;
        theta_pow = theta*pow_eff;

        cth = cos(theta_pow);
        sth = sin(theta_pow);
        cph = cos(phi_pow);
        sph = sin(phi_pow);

        tmpx = -cph*cth*r_pow/fnewtonbulb_power;
        tmpy = -cph*sth*r_pow/fnewtonbulb_power;
        tmpz = sph*r_pow/fnewtonbulb_power;

        r_zxy = sqrt(tmpx*tmpx + tmpy*tmpy);
        r_cxy = sqrt(c.x*c.x + c.y*c.y);

        h = 1.0 - c.z*tmpz/(r_cxy*r_zxy + fnewtonbulb_offset);

        tmpx2 = (c.x*tmpx - c.y*tmpy)*h;
        tmpy2 = (c.y*tmpx + c.x*tmpy)*h;
        tmpz2 = r_cxy*tmpz + r_zxy*c.z;

        z.x = fac_eff*z.x + tmpx2;
        z.y = fac_eff*z.y + tmpy2;
        z.z = fac_eff*z.z + tmpz2;

        sq_r = fnewtonbulb_fake_bailout/((dot(z-fnewtonbulb_solution,z-fnewtonbulb_solution))+ fnewtonbulb_offset);

        z.x = (z.x - fnewtonbulb_solution.x)*sq_r;
        z.y = -(z.y - fnewtonbulb_solution.y)*sq_r;
        z.z = -(z.z - fnewtonbulb_solution.z)*sq_r;

        if (fnewtonbulb_enable_post_folding) {
            rotMatrix = rotationMatrixXYZ(fnewtonbulb_post_angle_xyz);
            z = z * rotMatrix;
            z.x = abs(z.x + fnewtonbulb_post_folding) - abs(z.x - fnewtonbulb_post_folding) - z.x;
            z = rotMatrix * z;
        }

        dr = dr * fnewtonbulb_de_scale1 + fnewtonbulb_de_offset1;
        r1 = length(z);

        orbitTrap = min(orbitTrap, abs(vec4(z.x, z.y, z.z, r1*r1)));
        i++;
    }

    return 0.5 * 0.5 * log(r1) * r1 / dr;
}

vec2 newtonbulb_sdf(vec3 p) {
    float d = newton_sdf(p);
    return vec2(d, 0.0);
}