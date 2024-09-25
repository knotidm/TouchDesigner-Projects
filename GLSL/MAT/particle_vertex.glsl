uniform sampler2D uPos;
uniform sampler2D uOldPos;
uniform float res;
out float life;

void main() {
	float id = gl_VertexID + (gl_InstanceID * res);
	float off = mod(id, 2);
	id = floor(id / 2);
    float u = mod(id, res) / res;
    float v = floor(id / res) / res;	
	vec2 vTexOffset = vec2(u, v);	
	vec4 pos;
	float life0, life1;
	vec4 pos0 = texture(uPos, vTexOffset);
	vec4 pos1 = texture(uOldPos, vTexOffset);
	
	if (off == 0) {
		pos = pos0;
	} else {
		pos = pos1;
		pos.x += 0.1f;
	}
	
	if (pos0.w > pos1.w) {
		life = -1;	
	} else {
		life = pos.w;	
	}
	
	pos.w = 1;
	vec4 worldSpaceVert = TDDeform(pos);
	vec4 camSpaceVert = uTDMat.cam * worldSpaceVert;
	gl_Position = TDCamToProj(camSpaceVert);
}