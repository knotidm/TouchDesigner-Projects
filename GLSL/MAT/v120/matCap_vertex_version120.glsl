varying vec2 vN;

void main() {

    vec3 e = normalize( vec3( gl_ModelViewMatrix * gl_Vertex ) );
    vec3 n = normalize( gl_NormalMatrix * gl_Normal );
    vec3 r = reflect( e, n );

    float m = 2.0 * sqrt(
        pow( r.x, 2.0 ) +
        pow( r.y, 2.0 ) +
        pow( r.z + 1.0, 2.0 )
    );

    vN = r.xy / m + 0.5;

    gl_Position = gl_ProjectionMatrix * gl_ModelViewMatrix * gl_Vertex;
}
