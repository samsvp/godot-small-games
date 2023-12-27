shader_type canvas_item;

uniform vec3 bullet_color;


float sdf_circle(vec2 p, float r)
{
	return length(p) - r;
}


void fragment() 
{
	float x = 2.0 * (UV.x - 0.5);
	float y = 2.0 * (0.5 - UV.y);
	vec2 uv = vec2(x, y);
	
	float d = sdf_circle( uv, 0.8 );
	float alpha = pow(1.0 - d, 15.0);
	vec3 col = bullet_color;
	col *= 0.8 + 0.2 * cos(10.0 * d + TIME);
	col = mix( col, vec3(1.0), 1.0-smoothstep(0.0,0.2,abs(d)) );
	
	COLOR = vec4(col, alpha);
}
