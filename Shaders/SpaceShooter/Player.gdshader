shader_type canvas_item;

uniform vec3 color = vec3(0, 1, 0);

float sdf_triangle_iso( in vec2 p, in vec2 q )
{
	p.y = - p.y + q.y / 2.0;
	p.x = abs(p.x);
	vec2 a = p - q * clamp( dot(p,q)/dot(q,q), 0.0, 1.0 );
	vec2 b = p - q * vec2( clamp( p.x/q.x, 0.0, 1.0 ), 1.0 );
	float s = -sign( q.y );
	vec2 d = min( vec2( dot(a,a), s*(p.x*q.y-p.y*q.x) ),
                  vec2( dot(b,b), s*(p.y-q.y)  ));
	return -sqrt(d.x) * sign(d.y);
}


void fragment() 
{
	// make coordinates go from (-1,-1) to (1, 1)
	// where (-1cone,-1) is the bottom left corner and
	// (1,1) the top right
	float x = 2.0 * (UV.x - 0.5);
	float y = 2.0 * (0.5 - UV.y);
	vec2 uv = vec2(x, y);
	
	float d = sdf_triangle_iso( uv, vec2(0.5, 1.3) );
	float alpha = pow(1.0 - d, 15.0);
	vec3 col = color;
	col *= 0.8 + 0.37 * cos(80.0 * d + TIME);
	col += clamp(vec3(10.0/d), 0., 1.) * 15.0; // add glow
	
	COLOR = vec4(col, alpha);
}
