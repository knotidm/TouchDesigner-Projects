out vec2 vN;
out vec3 vWorldNormal;
out vec3 vWorldIncident;

void main() {

    vec4 pos = uTDMat.worldInverse * vec4(P, 1.0);
    vWorldNormal = normalize(uTDMat.worldForNormals * N);
    vec4 eyePos = uTDMat.worldInverse * vec4(0.0, 0.0, 0.0, 1.0);
    vWorldIncident = pos.xyz - eyePos.xyz;

    vec3 e = normalize( vec3(uTDMat.worldCam * vec4(P, 1.0)));
    vec3 n = normalize( uTDMat.worldCamForNormals * N );
    vec3 r = reflect( e, n );

    float m = 2.0 * sqrt(
        pow( r.x, 2.0 ) +
        pow( r.y, 2.0 ) +
        pow( r.z + 1.0, 2.0 )
    );
    vN = r.xy / m + 0.5;

    gl_Position = TDWorldToProj(TDDeform(P));
}