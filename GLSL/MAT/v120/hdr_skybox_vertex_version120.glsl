void main()
{
    vec4 eyePos = gl_ModelViewMatrixInverse * vec4(0.0, 0.0, 0.0, 1.0);
    gl_TexCoord[0].stp = normalize(gl_Vertex.xyz - eyePos.xyz);
    //normalize(mat3(gl_ModelViewMatrix) * gl_Vertex.xyz);
    //gl_TexCoord[0].st = gl_MultiTexCoord0.st;
    gl_Position = gl_ModelViewProjectionMatrix * gl_Vertex;
}