uniform sampler2D tMatCap;

in vec2 vectorNormal;

in VS_OUT
{
	vec4 position;
	vec3 normal;
	vec4 color;
	vec2 uv;
} fs_in;

layout (location = 0) out vec4 o_positions;
layout (location = 1) out vec4 o_normals;
layout (location = 2) out vec4 o_colors;
layout (location = 3) out vec4 o_uvs;

void main()
{
    vec3 base = texture2D( tMatCap, vectorNormal ).rgb;
	o_positions = fs_in.position;
	o_normals = vec4(fs_in.normal, 1.0);
	o_colors = vec4( base, 1.0 );
	o_uvs = vec4(fs_in.uv, 0.0, 1.0);
}