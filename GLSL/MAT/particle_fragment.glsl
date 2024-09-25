uniform sampler2D uLookup;
out float life;
out vec4 fragColor;

void main() {
	fragColor = texture(uLookup, vec2(life, 0.5));
}