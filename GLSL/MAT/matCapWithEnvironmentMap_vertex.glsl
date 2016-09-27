out vec2 vN;

vec3 texgen(vec3 camVector, vec3 camSpaceNorm) {
	return mat3(uTDMat.camInverse) * reflect(camVector, camSpaceNorm);
}

out Vertex {
	vec4 color;
	vec3 camSpaceVert;
	vec3 camVector;
	vec3 norm;
	vec3 envMapCoord;
}vVert;

void main() {

    vec4 camSpaceVert = uTDMat.cam * TDDeform(P);
    vec3 camSpaceNorm = uTDMat.camForNormals * TDDeformNorm(N).xyz;
	vVert.norm.stp = camSpaceNorm.stp;
	vVert.camSpaceVert.xyz = camSpaceVert.xyz;
	vVert.color = TDInstanceColor(Cd);
	vec3 camVec = normalize(-camSpaceVert.xyz);
	vVert.camVector.stp = camVec.stp;
	vec3 envMapCoord = texgen(-camVec, camSpaceNorm);
	vVert.envMapCoord.stp = envMapCoord.stp;

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