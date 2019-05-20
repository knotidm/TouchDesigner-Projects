uniform sampler2D bump;
out vec2 vectorNormal;

out vertex
{
	vec4 position;
	vec3 normal;
	vec4 color;
	vec2 uv;
} vertexOut;

void main() {
    vec4 bumpPixel = texture(bump, uv[0].xy);
    vec3 outCoords = vec3(P.x, P.y, P.z + bumpPixel.z);

    vec3 eye = normalize( vec3(uTDMat.worldCam * vec4(outCoords, 1.0)));
    vec3 normal = normalize( uTDMat.worldCamForNormals * N );
    vec3 rreflect = reflect( eye, normal );

    float matCapFormula = 2.0 * sqrt(
        pow( rreflect.x, 2.0 ) +
        pow( rreflect.y, 2.0 ) +
        pow( rreflect.z + 1.0, 2.0 )
    );
    vectorNormal = rreflect.xy / matCapFormula + 0.5;

    vertexOut.position = TDDeform(outCoords);
    vertexOut.normal = TDDeformNorm(N);
    vertexOut.color = Cd;
    vertexOut.uv = uv[0].xy;

    gl_Position = TDWorldToProj(vertexOut.position);
}