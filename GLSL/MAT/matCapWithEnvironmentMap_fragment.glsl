out vec4 fragColor;

uniform sampler2D tMatCap;
uniform samplerCube sEnvMap;
uniform vec3 uEnvMapColor;

in vec2 vN;

in Vertex {
	vec4 color;
	vec3 camSpaceVert;
	vec3 camVector;
	vec3 norm;
	vec3 envMapCoord;
}vVert;

void main() {

    vec3 envMapCoord = vVert.envMapCoord.stp;
    vec4 envMapColor = texture(sEnvMap, envMapCoord.stp);
    envMapColor.rgb *= uEnvMapColor;

    vec3 base = texture( tMatCap, vN ).rgb;
    fragColor = vec4( base, 1.0 ) + envMapColor;
}
