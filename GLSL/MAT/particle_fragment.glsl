uniform sampler2D uLookup;
varying float life;

void main() {
	gl_FragColor = texture(uLookup, vec2(life, 0.5));
}