uniform sampler2D uLookup;
out vec4 fragColor;

in float life;

void main() {
	vec4 c = texture(uLookup, vec2(life,0.5));
	fragColor = c;
}