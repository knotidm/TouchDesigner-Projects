uniform float uBlurAmount;
uniform float uEffectAmount;
uniform float uExposure;
uniform float uGamma;

out vec4 fragColor;

// vignetting effect (makes corners of image darker)
float vignette(vec2 pos, float inner, float outer)
{
  return 1.0 - smoothstep(inner, outer, length(pos));
}

// radial blur
vec4 radial(sampler2D tex, vec2 texcoord, int samples, float startScale, float scaleMul)
{
    vec4 c = vec4(0.0);
    float scale = startScale;
    
    for(int i = 0; i < samples; i++)
    {
        vec2 uv = ((texcoord - 0.5) * scale) + 0.5;
        vec4 s = texture(tex, uv);
        c += s;
        scale *= scaleMul;
    }
    
    c /= float(samples);
    return c;
}

void main()
{
    // sum original and blurred image
    vec4 scene = texture(sTD2DInputs[0], vUV.st);
    vec4 blurred = texture(sTD2DInputs[1], vUV.st);
	vec4 effect = radial(sTD2DInputs[1], vUV.st, 30, 1.0, 0.95);
    vec4 mixScene = mix(scene, blurred, uBlurAmount);

	mixScene += effect * uEffectAmount;
    // exposure
    mixScene = mixScene * uExposure;
    // vignette effect
    mixScene *= vignette(vUV.st * 2.0 - 1.0, 0.7, 1.5);
    // gamma correction
    mixScene.rgb = pow(mixScene.rgb, vec3(uGamma));

    fragColor = mixScene;
}