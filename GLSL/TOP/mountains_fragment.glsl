uniform vec4 iResolution;
uniform float iGlobalTime;

uniform vec2 iMouse;

out vec4 fragColor;

vec3 noised(in vec2 x)
{
    vec2 p = floor(x);
    vec2 f = fract(x);
    vec2 u = f*f*(3.0-2.0*f);
    float a = texture(sTD2DInputs[0], (p+vec2(0.5, 0.5))/256.0, -100.0).x;
    float b = texture(sTD2DInputs[0], (p+vec2(1.5, 0.5))/256.0, -100.0).x;
    float c = texture(sTD2DInputs[0], (p+vec2(0.5, 1.5))/256.0, -100.0).x;
    float d = texture(sTD2DInputs[0], (p+vec2(1.5, 1.5))/256.0, -100.0).x;
    return vec3(a+(b-a)*u.x+(c-a)*u.y+(a-b-c+d)*u.x*u.y,
    6.0*f*(1.0-f)*(vec2(b-a, c-a)+(a-b-c+d)*u.yx));
}


const mat2 m2 = mat2(0.8, -0.6, 0.6, 0.8);
float terrain(in vec2 x)
{
    vec2  p = x*0.003;
    float a = 0.0;
    float b = 1.0;
    vec2  d = vec2(0.0);
    for (int i=0; i<6; i++)
    {
        vec3 n = noised(p);
        d += n.yz;
        a += b*n.x/(1.0+dot(d, d));
        b *= 0.5;
        p = m2*p*2.0;
    }


    return 140.0*a;
}


float terrain2(in vec2 x)
{
    vec2  p = x*0.003;
    float a = 0.0;
    float b = 1.0;
    vec2  d = vec2(0.0);
    for (int i=0; i<14; i++)
    {
        vec3 n = noised(p);
        d += n.yz;
        a += b*n.x/(1.0+dot(d, d));
        b *= 0.5;
        p = m2*p*2.0;
    }


    return 140.0*a;
}


float terrain3(in vec2 x)
{
    vec2  p = x*0.003;
    float a = 0.0;
    float b = 1.0;
    vec2  d = vec2(0.0);
    for (int i=0; i<4; i++)
    {
        vec3 n = noised(p);
        d += n.yz;
        a += b*n.x/(1.0+dot(d, d));
        b *= 0.5;
        p = m2*p*2.0;
    }


    return 140.0*a;
}


float map(in vec3 p)
{
    return p.y - terrain(p.xz);
}


float interesct(in vec3 ro, in vec3 rd, in float tmin, in float tmax)
{
    float t = tmin;
    for (int i=0; i<120; i++)
    {
        float h = map(ro + t*rd);
        if (h<(0.002*t) || t>tmax) break;
        t += 0.5*h;
    }


    return t;
}


float softShadow(in vec3 ro, in vec3 rd)
{
    // real shadows
    float res = 1.0;
    float t = 0.001;
    for (int i=0; i<48; i++)
    {
        vec3  p = ro + t*rd;
        float h = map(p);
        res = min(res, 16.0*h/t);
        t += h;
        if (res<0.001 ||p.y>200.0) break;
    }

    return clamp(res, 0.0, 1.0);
}


vec3 calcNormal(in vec3 pos, float t)
{
    vec2  eps = vec2(0.002*t, 0.0);
    return normalize(vec3(terrain2(pos.xz-eps.xy) - terrain2(pos.xz+eps.xy),
    2.0*eps.x,
    terrain2(pos.xz-eps.yx) - terrain2(pos.xz+eps.yx)));
}


vec3 camPath(float time)
{
    return 1100.0*vec3(cos(0.0+0.23*time), 0.0, cos(1.5+0.21*time));
}


float fbm(vec2 p)
{
    float f = 0.0;
    f += 0.5000*texture(sTD2DInputs[0], p/256.0).x;
    p = m2*p*2.02;
    f += 0.2500*texture(sTD2DInputs[0], p/256.0).x;
    p = m2*p*2.03;
    f += 0.1250*texture(sTD2DInputs[0], p/256.0).x;
    p = m2*p*2.01;
    f += 0.0625*texture(sTD2DInputs[0], p/256.0).x;
    return f/0.9375;
}


mat3 setCamera(in vec3 ro, in vec3 ta, in float cr)
{
    vec3 cw = normalize(ta-ro);
    vec3 cp = vec3(sin(cr), cos(cr), 0.0);
    vec3 cu = normalize(cross(cw, cp));
    vec3 cv = normalize(cross(cu, cw));
    return mat3(cu, cv, cw);
}


void main(void)
{
    vec2 xy = -1.0 + 2.0*gl_FragCoord.xy/iResolution.xy;
    vec2 s = xy*vec2(iResolution.x/iResolution.y, 1.0);
    #ifdef STEREO
    float isCyan = mod(gl_FragCoord.x + mod(gl_FragCoord.y, 2.0), 2.0);
    #endif

    float time = iGlobalTime*0.15 + 0.3 + 4.0*iMouse.x/iResolution.x;
    vec3 light1 = normalize(vec3(-0.8, 0.4, -0.3));
    // camera position
    vec3 ro = camPath(time);
    vec3 ta = camPath(time + 3.0);
    ro.y = terrain3(ro.xz) + 11.0;
    ta.y = ro.y - 20.0;
    float cr = 0.2*cos(0.1*time);
    // camera2world transform
    mat3 cam = setCamera(ro, ta, cr);
    // camera ray
    vec3 rd = cam * normalize(vec3(s.xy, 2.0));
    #ifdef STEREO
    ro += 2.0*cu*isCyan;
    // move camera to the right - the rd vector is still good
    #endif

    // bounding plane
    float tmin = 2.0;
    float tmax = 2000.0;
    float maxh = 210.0;
    float tp = (maxh-ro.y)/rd.y;
    if (tp>0.0)
    {
        if (ro.y>maxh) tmin = max(tmin, tp);
        else tmax = min(tmax, tp);
    }


    float sundot = clamp(dot(rd, light1), 0.0, 1.0);
    vec3 col;
    float t = interesct(ro, rd, tmin, tmax);
    if (t>tmax)
    {
        // sky
        col = vec3(0.3, .55, 0.8)*(1.0-0.8*rd.y)*0.9;
        // sun
        col += 0.25*vec3(1.0, 0.7, 0.4)*pow(sundot, 5.0);
        col += 0.25*vec3(1.0, 0.8, 0.6)*pow(sundot, 64.0);
        col += 0.2*vec3(1.0, 0.8, 0.6)*pow(sundot, 512.0);
        // clouds
        vec2 sc = ro.xz + rd.xz*(1000.0-ro.y)/rd.y;
        col = mix(col, vec3(1.0, 0.95, 1.0), 0.5*smoothstep(0.5, 0.8, fbm(0.0005*sc)));
        // horizon
        col = mix(col, vec3(0.7, 0.75, 0.8), pow(1.0-max(rd.y, 0.0), 8.0));
    }

    else
    {
        // mountains
        vec3 pos = ro + t*rd;
        vec3 nor = calcNormal(pos, t);
        vec3 ref = reflect(rd, nor);
        float fre = clamp(1.0+dot(rd, nor), 0.0, 1.0);
        // rock
        float r = texture(sTD2DInputs[0], 7.0*pos.xz/256.0).x;
        col = (r*0.25+0.75)*0.9*mix(vec3(0.08, 0.05, 0.03), vec3(0.10, 0.09, 0.08), texture(sTD2DInputs[0], 0.00007*vec2(pos.x, pos.y*48.0)).x);
        col = mix(col, 0.20*vec3(0.45, .30, 0.15)*(0.50+0.50*r), smoothstep(0.70, 0.9, nor.y));
        col = mix(col, 0.15*vec3(0.30, .30, 0.10)*(0.25+0.75*r), smoothstep(0.95, 1.0, nor.y));
        // snow
        float h = smoothstep(55.0, 80.0, pos.y + 25.0*fbm(0.01*pos.xz));
        float e = smoothstep(1.0-0.5*h, 1.0-0.1*h, nor.y);
        float o = 0.3 + 0.7*smoothstep(0.0, 0.1, nor.x+h*h);
        float s = h*e*o;
        col = mix(col, 0.29*vec3(0.62, 0.65, 0.7), smoothstep(0.1, 0.9, s));
        // lighting
        float amb = clamp(0.5+0.5*nor.y, 0.0, 1.0);
        float dif = clamp(dot(light1, nor), 0.0, 1.0);
        float bac = clamp(0.2 + 0.8*dot(normalize(vec3(-light1.x, 0.0, light1.z)), nor), 0.0, 1.0);
        float sh = 1.0;
        if (dif>=0.0001) sh = softShadow(pos+light1*20.0, light1);
        vec3 lin  = vec3(0.0);
        lin += dif*vec3(7.00, 5.00, 3.00)*vec3(sh, sh*sh*0.5+0.5*sh, sh*sh*0.8+0.2*sh);
        lin += amb*vec3(0.40, 0.60, 0.80)*1.2;
        lin += bac*vec3(0.40, 0.50, 0.60);
        col *= lin;
        col += s*0.1*pow(fre, 4.0)*vec3(7.0, 5.0, 3.0)*sh * pow(clamp(dot(light1, ref), 0.0, 1.0), 16.0);
        col += s*0.1*pow(fre, 4.0)*vec3(0.4, 0.5, 0.6)*smoothstep(0.0, 0.6, ref.y);
        // fog
        float fo = 1.0-exp(-0.0000011*t*t);
        vec3 fco = 0.8*vec3(0.5, 0.7, 0.9) + 0.1*vec3(1.0, 0.8, 0.5)*pow(sundot, 4.0);
        col = mix(col, fco, fo);
        // sun scatter
        col += 0.3*vec3(1.0, 0.8, 0.4)*pow(sundot, 8.0)*(1.0-exp(-0.002*t));
    }


    // gamma
    col = pow(col, vec3(0.4545));
    // vignetting
    col *= 0.5 + 0.5*pow((xy.x+1.0)*(xy.y+1.0)*(xy.x-1.0)*(xy.y-1.0), 0.1);
    #ifdef STEREO
    col *= vec3(isCyan, 1.0-isCyan, 1.0-isCyan);
    #endif

    fragColor=vec4(col, 1.0);
}
