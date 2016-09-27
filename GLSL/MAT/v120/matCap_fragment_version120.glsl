uniform sampler2D tMatCap;

varying vec2 vN;

void main() {
vec3 base = texture2D( tMatCap, vN ).rgb;
    gl_FragColor = vec4( base, 1. );
}
