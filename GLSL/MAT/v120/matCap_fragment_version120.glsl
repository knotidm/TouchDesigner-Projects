uniform sampler2D tMatCap;

varying vec2 vectorNormal;

void main() {
vec3 base = texture2D( tMatCap, vectorNormal ).rgb;
    gl_FragColor = vec4( base, 1. );
}
