shader_type canvas_item;

uniform float u_radius = 0.4;
uniform vec3 color;

float sdf_hexagram(vec2 p, in float r)
{
	const vec4 k = vec4(-0.5,0.8660254038,0.5773502692,1.7320508076);
	p = abs(p);
	p -= 2.0*min(dot(k.xy,p),0.0)*k.xy;
	p -= 2.0*min(dot(k.yx,p),0.0)*k.yx;
	p -= vec2(clamp(p.x,r*k.z,r*k.w),r);
	return length(p)*sign(p.y);
}

void fragment() 
{
	float x = 2.0 * (UV.x - 0.5);
	float y = 2.0 * (0.5 - UV.y);
	vec2 uv = vec2(x, y);
	
	float d = sdf_hexagram(uv, u_radius);
	float alpha = pow(1.0 - d, 10.0);
	vec3 col = color;
	col *= 0.9 + 0.3 * cos(80.0 * d + TIME);
	col = mix( col, vec3(1.0), 1.0-smoothstep(0.0,0.02,abs(d)) );
	
	COLOR = vec4(col, alpha);
}
