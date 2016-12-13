varying vec2 vectorNormal;

void main() {
    vec3 eye = normalize( vec3( gl_ModelViewMatrix * gl_Vertex ) );
    vec3 normal = normalize( gl_NormalMatrix * gl_Normal );
    vec3 rreflect = reflect( eye, normal );

    float matCapFormula = 2.0 * sqrt(
        pow( rreflect.x, 2.0 ) +
        pow( rreflect.y, 2.0 ) +
        pow( rreflect.z + 1.0, 2.0 )
    );
    vectorNormal = rreflect.xy / matCapFormula + 0.5;
    gl_Position = gl_ProjectionMatrix * gl_ModelViewMatrix * gl_Vertex;
}