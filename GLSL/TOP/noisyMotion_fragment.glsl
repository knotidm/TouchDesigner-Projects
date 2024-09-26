uniform float noiseStrength;
uniform float noiseScale;
uniform float stepSize;
out vec4 fragColor;

float rand(vec2 co){
    return fract(sin(dot(co.xy, vec2(12.9898, 78.233))) * 43758.5453);
}

void main()
{
    float stepSize1 = rand(vec2(1.5))*0.01;

    vec4 initial = texture(sTD2DInputs[1], vUV.st);
    vec4 previous = texture(sTD2DInputs[1], vUV.st);
    vec4 perlin = texture(sTD2DInputs[2], vUV.st);

    float angle = texture(sTD2DInputs[2], vec2(previous.r/noiseScale, previous.g/noiseScale)).r*noiseStrength;

    float anglex = cos(angle) * stepSize;
    float angley = sin(angle) * stepSize;

    anglex = previous.r + anglex;
    angley = previous.g + angley;

    if (anglex < 0.1 || angley < 0.1  || anglex > 0.9 || angley > 0.9){
        anglex = rand(vUV.st+previous.st);
        angley = rand(vUV.st+initial.st+vec2(0.1));
    }

    fragColor.rg = vec2(anglex, angley);
}