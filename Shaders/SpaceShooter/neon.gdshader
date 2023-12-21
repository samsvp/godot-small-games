shader_type canvas_item;

uniform float u_radius = 0.015;
uniform float u_intensity = 1.5;

float glow(float dist, float radius, float intensity)
{
	return pow(radius / dist, intensity);
}


float sdf_box(float radius, vec2 p)
{
	float x_dist = max(p.x - radius, 0);
	float y_dist = max(p.y - radius, 0);
	return length(vec2(x_dist, y_dist));
}


void fragment() 
{
	float x = 2.0 * (UV.x - 0.5);
	float y = 2.0 * (0.5 - UV.y);
	vec2 uv = vec2(x, y);
	
	y = 0.0;
	float eps = 0.05;
	
	float c = smoothstep(y-eps, y, uv.y) -
			  smoothstep(y, y+eps, uv.y);
	vec4 col = vec4(c);
	float dist = abs(uv.y - y);
	col += glow(dist, u_radius, u_intensity) * vec4(1.0,0.05,0.3, 0.95);
	
	col = 1.0 - exp(-col);
	col = pow(col, vec4(0.25));
	
	COLOR = col;
}
