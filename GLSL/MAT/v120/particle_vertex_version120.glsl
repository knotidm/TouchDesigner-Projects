#extension GL_EXT_gpu_shader4 : enable

uniform sampler2D uPos;
uniform sampler2D uOldPos;
uniform mat4 uMat;
uniform float res = 1024;
varying float life;

void main() {
	float id = gl_VertexID + (gl_InstanceID * 512);
	float off = mod(id, 2);
	id = floor(id / 2);
    float u = mod(id, res) / res;
    float v = floor(id / res) / res;	
	vec2 vTexOffset = vec2(u, v);	
	vec4 pos;
	float life0, life1;
	vec4 pos0 = texture2D(uPos, vTexOffset);
	vec4 pos1 = texture2D(uOldPos, vTexOffset);
	
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
	vec4 worldSpaceVert = deform(pos);
	//vec4 camSpaceVert = uTDMat.cam * worldSpaceVert;
	gl_Position = TouchTransformModelToProjection(worldSpaceVert);
}