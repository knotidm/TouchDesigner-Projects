out vec4 fragColor;

uniform float exposure;
uniform float decay;
uniform float density;
uniform float weight;
uniform vec2 lightPositionOnScreen;
uniform sampler2D sInput1;
const int NUM_SAMPLES = 100 ;

void main()
{
	vec2 deltaTextCoord = vec2(vUV.st - lightPositionOnScreen.xy);
	vec2 textCoo = vUV.st;
	deltaTextCoord *= 1.0 /  float(NUM_SAMPLES) * density;
	float illuminationDecay = 1.0;

	for(int i=0; i < NUM_SAMPLES ; i++)
	{
			textCoo -= deltaTextCoord;
			vec4 textureSample = texture2D(sInput1, textCoo);
			textureSample *= illuminationDecay * weight;
			fragColor += textureSample;
			illuminationDecay *= decay;
	}
	fragColor *= exposure;
}
