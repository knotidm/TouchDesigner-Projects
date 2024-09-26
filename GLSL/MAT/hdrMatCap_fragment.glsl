uniform sampler2D sCubeTex0;
uniform sampler2D sCubeTex1;
uniform sampler2D sCubeTex2;
uniform sampler2D sCubeTex3;
uniform sampler2D sCubeTex4;
uniform sampler2D sCubeTex5;

uniform sampler2D tMatCap;

in vec2 vN;
in vec3 vWorldNormal;
in vec3 vWorldIncident;

out vec4 fragColor;

vec4 fakeCubeMapLookup(vec3 vec)
{
     vec3 stf;
     vec3 absVec = abs(vec);
     vec3 sgnVec = (-sign(vec) / 2.0) + 0.5; // maps + to 0 and - to 1
     float absMa = max( max(absVec.x, absVec.y), absVec.z);
     vec3 faceBaseVec = vec3( 0.0, 2.0, 4.0);
     vec3 faceVec = faceBaseVec + sgnVec;

     if ( abs(vec.x) == absMa )      { stf = vec3(vec.z, vec.y, faceVec.x); }
     else if ( abs(vec.y) == absMa ) { stf = vec3(vec.x, vec.z, faceVec.y); }
     else if ( abs(vec.z) == absMa ) { stf = vec3(vec.x, vec.y, faceVec.z); }

     vec2 st = (stf.xy/absMa + 1.0) / 2.0;
     int face = int(stf.z);

     vec4 color = texture( sCubeTex0, st, 2.0) * float(face == 0) +
     			  texture( sCubeTex1, st, 2.0) * float(face == 1) +
				  texture( sCubeTex2, st, 2.0) * float(face == 2) +
				  texture( sCubeTex3, st, 2.0) * float(face == 3) +
				  texture( sCubeTex4, st, 2.0) * float(face == 4) +
				  texture( sCubeTex5, st, 2.0) * float(face == 5) ;

     return color;
}

float my_fresnel(vec3 incident, vec3 norm, float power, float scale, float bias)
{
    return bias + (pow(clamp(1.0 - dot(incident, norm), 0.0, 1.0), power) * scale);
}

void main() {

    vec3 incident = normalize(vWorldIncident);
    vec3 norm = normalize(vWorldNormal);
    vec3 R = reflect(incident, norm);
    vec3 T = refract(incident, norm, 0.95);
    float fresnel = my_fresnel(-incident, norm, 5.0, 0.99, 0.01);
    vec3 Creflect = fakeCubeMapLookup(R).rgb; // lookup reflection in HDR cube map
    vec3 Crefract = fakeCubeMapLookup(T).rgb; // refraction
    Crefract *= vec3(0.05, 0.2, 0.05);
    vec3 Cout = mix(Crefract, Creflect,1);

    vec3 base = texture( tMatCap, vN ).rgb;

    fragColor = vec4( base, 1.0 ) + vec4(Cout, 0.5);
}
