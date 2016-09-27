uniform sampler2D uLookup;
varying float life;

void main() {
	vec4 c = texture(uLookup, vec2(life, 0.5));
	gl_FragColor = c;
}