uniform sampler2D bump;
uniform sampler2D colour;
out vec4 pixelColor;

void main()
{
    vec4 bumpPixel = texture(bump, uv[0].st);
    vec4 colourPixel = texture(colour, uv[0].st);
    vec3 outCoords = vec3(P.x, P.y, P.z + bumpPixel);
    pixelColor = colourPixel*((bumpPixel*4));
    gl_Position = TDWorldToProj(TDDeform(outCoords));
}
