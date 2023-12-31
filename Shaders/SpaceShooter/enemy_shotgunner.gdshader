shader_type canvas_item;


uniform vec3 color = vec3(1.0);


float sdf_pentagon(vec2 p, float r )
{
	const vec3 k = vec3(0.809016994,0.587785252,0.726542528);
	p.x = abs(p.x);
	p -= 2.0 * min( dot( vec2(-k.x,k.y), p ), 0.0 ) * vec2(-k.x,k.y);
	p -= 2.0 * min( dot( vec2( k.x,k.y), p ), 0.0 ) * vec2( k.x,k.y);
	p -= vec2( clamp( p.x, -r*k.z, r*k.z ), r );
	return length(p) * sign(p.y);
}


void fragment() 
{
	float x = 2.0 * (UV.x - 0.5);
	float y = 2.0 * (0.5 - UV.y);
	vec2 uv = vec2(x, y);
	
	float d = sdf_pentagon( uv, 0.5);
	float alpha = pow(1.0 - d, 15.0);
	vec3 col = color;
	col *= 0.9 + 0.3 * cos(80.0 * d + TIME);
	col = mix( col, vec3(1.0), 1.0-smoothstep(0.0,0.02,abs(d)) );
	
	COLOR = vec4(col, alpha);
}
