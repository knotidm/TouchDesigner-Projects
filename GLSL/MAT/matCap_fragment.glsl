out vec4 fragColor;
uniform sampler2D tMatCap;

in vec2 vN;

void main() {
    vec3 base = texture2D( tMatCap, vN ).rgb;
    fragColor = vec4( base, 1.0 );
}
