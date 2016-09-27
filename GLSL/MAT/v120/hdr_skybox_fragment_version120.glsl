uniform sampler2D sCubeTex0;
uniform sampler2D sCubeTex1;
uniform sampler2D sCubeTex2;
uniform sampler2D sCubeTex3;
uniform sampler2D sCubeTex4;
uniform sampler2D sCubeTex5;

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
	      else return vec4(1.0, 0.0, 0.0, 1.0);

     vec2 st = (stf.xy/absMa + 1.0) / 2.0;
     int face = int(stf.z);

     vec4 color = texture2D( sCubeTex0, st) * float(face == 0) +
     		      texture2D( sCubeTex1, st) * float(face == 1) +
		          texture2D( sCubeTex2, st) * float(face == 2) +
		          texture2D( sCubeTex3, st) * float(face == 3) +
		          texture2D( sCubeTex4, st) * float(face == 4) +
		          texture2D( sCubeTex5, st) * float(face == 5) ;
     return color;
}

void main()
{
    gl_FragColor = fakeCubeMapLookup(normalize(gl_TexCoord[0].stp));
}
