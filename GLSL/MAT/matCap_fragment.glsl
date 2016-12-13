out vec4 fragColor;
uniform sampler2D tMatCap;

in vec2 vectorNormal;

void main() {
    vec3 base = texture2D( tMatCap, vectorNormal ).rgb;
    fragColor = vec4( base, 1.0 );
}
