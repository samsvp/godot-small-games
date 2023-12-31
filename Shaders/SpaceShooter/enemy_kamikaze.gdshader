shader_type canvas_item;

uniform vec3 color = vec3(1.0);

float sdf_pie( vec2 p, float angle, in float r )
{
	p.x = abs(p.x);
	vec2 c = vec2(sin(angle), cos(angle));
	float l = length(p) - r;
	float m = length(p - c*clamp(dot(p,c),0.0,r) );
	return max(l,m*sign(c.y*p.x-c.x*p.y));
}


void fragment() 
{
	float x = 2.0 * (UV.x - 0.5);
	float y = 2.0 * (0.5 - UV.y);
	vec2 uv = vec2(x, y);
	
	float d = sdf_pie( uv, 0.5, 0.8 );
	float alpha = pow(1.0 - d, 15.0);
	vec3 col = color;
	col *= 0.9 + 0.3 * cos(80.0 * d + TIME);
	col = mix( col, vec3(1.0), 1.0-smoothstep(0.0,0.02,abs(d)) );
	
	COLOR = vec4(col, alpha);
}
