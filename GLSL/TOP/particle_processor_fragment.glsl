uniform float uTime;
uniform vec3 Wind;
uniform vec3 Turb;
uniform vec3 Amp;
uniform float Noise;
out vec4 fResult;

mat3 m = mat3(Wind[0], Wind[0], Wind[0],
Turb[0], Turb[0], Turb[0],
Amp[0], Amp[0], Amp[0]);

float hash(float n)
{
    return fract(sin(n) * 43758.5453);
}

float noise(in vec3 x)
{
    vec3 p = floor(x);
    vec3 f = fract(x);
    f = f * f * (3.0 - 2.0 * f);
    float n = p.x + p.y * 57.0 + 113.0 * p.z;
    return mix(mix(mix(hash(n + 0.0), hash(n + 1.0), f.x),
    mix(hash(n + 57.0), hash(n + 58.0), f.x), f.y),
    mix(mix(hash(n + 113.0), hash(n + 114.0), f.x),
    mix(hash(n + 170.0), hash(n + 171.0), f.x), f.y), f.z);
}

float fbm (vec3 p)
{
    float f;
    f = 0.5000 * noise(p); p = m * p * 2.02;
    f += 0.2500 * noise(p); p = m * p * 2.03;
    f += 0.1250 * noise(p); p = m * p * 2.03;
    return f;
}

void main() {
    vec2 vTexcoord = vUV.xy;
    vec4 pos = texture(sTD2DInputs[0], vTexcoord);
    vec2 uv = vTexcoord * 0.00942;
    vec3 ut = vec3(uv, uTime * 0.4172);
    vec3 uu = vec3(0, 0, uTime * 1.9272);
    float sc = fbm(pos.xzy + uu) * 0.264;
    pos.a += fbm((pos.xyz + uu) * 0.3) * Noise;
    vec3 nv = vec3(
    fbm(sc * pos.zxy + ut),
    fbm(sc * pos.xyz + ut),
    fbm(sc * pos.yzx + ut));
    nv -= vec3(0.5);

    if (pos.a >= 1) {
        pos.xyz = texture(sTD2DInputs[1], vTexcoord).rgb;
        pos.a -= 1.0;
    } else {
        nv *= 0.28 * (1.2 - pos.a * 0.5);
        nv.y += 0.1 * pow(pos.a, 2.95);
        pos.xyz += nv;
    }
    fResult = pos;
}