out VS_OUT
{
	vec4 color;
} vs_out;

void main()
{
	vs_out.color = Cd;
    gl_Position = TDWorldToProj(TDDeform(P));
}