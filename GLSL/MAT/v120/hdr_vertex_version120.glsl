uniform mat4 uViewMatrixInverse;
varying vec3 vWorldNormal;
varying vec3 vWorldIncident;
void main()
{
    // transform position to world space
    vec4 P = uViewMatrixInverse * (gl_ModelViewMatrix * gl_Vertex);
    // transform normal to world space
    vWorldNormal = normalize(mat3(uViewMatrixInverse) * (mat3(gl_NormalMatrix) * gl_Normal));
    vec4 eyePos = uViewMatrixInverse * vec4(0.0, 0.0, 0.0, 1.0);
    // calculate incident vector
    vWorldIncident = P.xyz - eyePos.xyz;

    gl_Position = ftransform(); //same as gl_ProjectionMatrix * gl_ModelViewMatrix * gl_Vertex;
}
