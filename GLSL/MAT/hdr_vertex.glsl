out vec3 vWorldNormal;
out vec3 vWorldIncident;

void main()
{
    // transform position to world space
    vec4 pos = uTDMat.worldInverse * vec4(P, 1.0);
    // transform normal to world space
    vWorldNormal = normalize(uTDMat.worldForNormals * N);
    vec4 eyePos = uTDMat.worldInverse * vec4(0.0, 0.0, 0.0, 1.0);
    // calculate incident vector
    vWorldIncident = pos.xyz - eyePos.xyz;

	gl_Position = TDWorldToProj(TDDeform(P));
}