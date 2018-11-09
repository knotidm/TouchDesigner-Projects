out vec2 vectorNormal;

out VS_OUT
{
	vec4 position;
	vec3 normal;
	vec4 color;
	vec2 uv;
} vs_out;

void main()
{
    vec3 eye = normalize( vec3(uTDMat.worldCam * vec4(P, 1.0)));
    vec3 normal = normalize( uTDMat.worldCamForNormals * N );
    vec3 rreflect = reflect( eye, normal );

    float matCapFormula = 2.0 * sqrt(
        pow( rreflect.x, 2.0 ) +
        pow( rreflect.y, 2.0 ) +
        pow( rreflect.z + 1.0, 2.0 )
    );
    vectorNormal = rreflect.xy / matCapFormula + 0.5;

	vs_out.position = TDDeform(P);
	vs_out.normal = TDDeformNorm(N);
	vs_out.color = Cd;
	vs_out.uv = uv[0].st;

	gl_Position = TDWorldToProj(vs_out.position);
}