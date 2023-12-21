shader_type canvas_item;

uniform float u_radius = 0.4;

float sdf_box(float radius, vec2 p)
{
	p = abs(p);
	float dx = p.x - radius;
	float dy = p.y - radius;
	return length(max(vec2(dx, dy), 0.0)) + min(max(dx, dy), 0.0);
}

void fragment() 
{
	float x = 2.0 * (UV.x - 0.5);
	float y = 2.0 * (0.5 - UV.y);
	vec2 uv = vec2(x, y);
	
	float d = sdf_box(u_radius, uv);
	float alpha = pow(1.0 - d, 20.0);
	vec3 col = vec3(0.95, 0.5, 0.5);
	col *= 0.9 + 0.3 * cos(80.0 * d + TIME);
	col = mix( col, vec3(1.0), 1.0-smoothstep(0.0,0.02,abs(d)) );
	
	COLOR = vec4(col, alpha);
}
