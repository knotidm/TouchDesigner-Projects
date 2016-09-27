uniform float uTime;

in VS_OUT
{
	vec4 color;
} gs_in[];

out vec4 fColor;

vec3 getNormal()
{
	vec3 a = vec3(gl_in[0].gl_Position) - vec3(gl_in[1].gl_Position);
	vec3 b = vec3(gl_in[2].gl_Position) - vec3(gl_in[1].gl_Position);
	return normalize(cross(a, b));
}

vec4 explode(vec4 position, vec3 normal)
{
	float magnitude = 2.0f;
	vec3 direction = normal * ((sin(uTime) + 1.0f) / 2.0f) * magnitude;
	return position + vec4(direction, 0.0f);
}

void main()
{
	vec3 normal = getNormal();

	fColor = gs_in[0].color;
	gl_Position = explode(gl_in[0].gl_Position, normal);
	EmitVertex();

	fColor = gs_in[1].color;
	gl_Position = explode(gl_in[1].gl_Position, normal);
	EmitVertex();

	fColor = gs_in[2].color;
	gl_Position = explode(gl_in[2].gl_Position, normal);
	EmitVertex();

	EndPrimitive();
}