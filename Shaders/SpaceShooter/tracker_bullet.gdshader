shader_type canvas_item;

uniform vec3 bullet_color;

float ndot(vec2 a, vec2 b ) { return a.x*b.x - a.y*b.y; }
float sdf_rhombus(vec2 position, vec2 diags) 
{
	position = abs(position);
	float h = clamp( ndot(diags - 2.0 * position,diags) / dot(diags,diags), 
					 -1.0, 
					  1.0 );
    float d = length( position - 0.5 * diags * vec2(1.0-h,1.0+h) );
    return d * sign( position.x * diags.y + position.y * diags.x - diags.x * diags.y );
}

void fragment() 
{
	float x = 2.0 * (UV.x - 0.5);
	float y = 2.0 * (0.5 - UV.y);
	vec2 uv = vec2(x, y);
	
	float d = sdf_rhombus( uv, vec2(0.8) );
	float alpha = pow(1.0 - d, 15.0);
	vec3 col = bullet_color;
	col *= 0.8 + 0.2 * cos(10.0 * d + TIME);
	col = mix( col, vec3(1.0), 1.0-smoothstep(0.0,0.2,abs(d)) );
	
	COLOR = vec4(col, alpha);
}