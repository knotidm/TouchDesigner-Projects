out vec3 texCoord;

void main()
{
    vec4 eyePos = uTDMat.worldInverse * vec4(0.0, 0.0, 0.0, 1.0);
    texCoord = TDInstanceTexCoord(uv[0]);
    texCoord.stp = normalize(P.xyz - eyePos.xyz);

    gl_Position = TDWorldToProj(TDDeform(P));
}