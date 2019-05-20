uniform int u_number_of_lights;
uniform vec2 u_render_resolution;
uniform vec3 u_view_direction;

uniform float u_shininess = 16.0;
uniform vec3 u_specular_color;

uniform sampler2D u_positions_sampler;
uniform sampler2D u_normals_sampler;
uniform sampler2D u_colors_sampler;
uniform sampler2D u_uvs_sampler;

uniform samplerBuffer u_light_positions;
uniform samplerBuffer u_light_colors;
uniform samplerBuffer u_light_falloffs; // constant, linear, quadratic

out vec4 o_color;

void main()
{
	vec2 screenspace_uv = vUV.st;
	
	// Parse data from G-buffer
	vec3 position = texture(sTD2DInputs[0], screenspace_uv).rgb;
	vec3 normal = texture(sTD2DInputs[1], screenspace_uv).rgb;
	vec3 color = texture(sTD2DInputs[2], screenspace_uv).rgb;
	vec2 uv = texture(sTD2DInputs[3], screenspace_uv).rg;
	
	vec3 final_color = vec3(0.0);
	for (int i = 0; i < u_number_of_lights; ++i)
	{
		// Parse lighting data based on the current light index
		vec3 light_position = texelFetchBuffer(u_light_positions, i).xyz;
		vec3 light_color = texelFetchBuffer(u_light_colors, i).xyz;
		vec3 light_falloff = texelFetchBuffer(u_light_falloffs, i).xyz;
		
		// Calculate the distance between the current fragment and the light source
		float distance = length(light_position - position);
	
		// Diffuse contribution
    	vec3 to_light = normalize(light_position - position);
    	vec3 diffuse = max(dot(normal, to_light), 0.0) * color * light_color;
    
    	// Specular contribution
    	vec3 to_viewer = normalize(position - u_view_direction);
    	vec3 h = normalize(to_light - to_viewer);  
    	float spec = pow(max(dot(normal, h), 0.0), u_shininess);
    	vec3 specular = light_color * spec * u_specular_color; 
    
    	// Attenuation
    	float attenuation = 1.0 / (1.0 + light_falloff.y * distance + light_falloff.z * distance * distance);
    	diffuse *= attenuation;
    	specular *= attenuation;
    	
    	// Accumulate lighting
    	final_color += diffuse + specular;
    }
            
	o_color = vec4(final_color, 1.0);
}