uniform vec4 uAmbientColor;
uniform vec4 uDiffuseColor;
uniform vec3 uSpecularColor;
uniform float uShininess;
uniform vec3 uEnvMapColor;
uniform float uShadowStrength;
uniform vec3 uShadowColor;

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

void main()
{
	// First deform the vertex and normal
	// TDDeform always returns values in world space
	vec4 worldSpaceVert =TDDeform(P);
	vec4 camSpaceVert = uTDMat.cam * worldSpaceVert;
	gl_Position = TDCamToProj(camSpaceVert);

	// This is here to ensure we only execute lighting etc. code
	// when we need it. If picking is active we don't need this, so
	// this entire block of code will be ommited from the compile.
	// The TD_PICKING_ACTIVE define will be set automatically when
	// picking is active.
#ifndef TD_PICKING_ACTIVE

	vec3 camSpaceNorm = uTDMat.camForNormals * TDDeformNorm(N).xyz;
	vVert.norm.stp = camSpaceNorm.stp;
	vVert.camSpaceVert.xyz = camSpaceVert.xyz;
	vVert.color = TDInstanceColor(Cd);
	vec3 camVec = normalize(-camSpaceVert.xyz);
	vVert.camVector.stp = camVec.stp;
	vec3 envMapCoord = texgen(-camVec, camSpaceNorm);
	vVert.envMapCoord.stp = envMapCoord.stp;

#else // TD_PICKING_ACTIVE

	// This will automatically write out the nessessary values
	// for this shader to work with picking.
	// See the documentation if you want to write custom values for picking.
	TDWritePickingValues();

#endif // TD_PICKING_ACTIVE
}
