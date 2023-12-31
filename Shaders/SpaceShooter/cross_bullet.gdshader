shader_type canvas_item;

uniform vec3 bullet_color;


mat2 rotate2d(float _angle){
	float s = sin(_angle);
	float c = cos(_angle);
    return mat2(vec2(c, -s),
                vec2(s, c));
}


float sdf_rounded_X( in vec2 p, in float w, in float r )
{
	p = abs(p);
	return length(p-min(p.x+p.y,w)*0.5) - r;
}


void fragment() 
{
	float x = 2.0 * (UV.x - 0.5);
	float y = 2.0 * (0.5 - UV.y);
	vec2 uv = rotate2d(100.0 * TIME) * vec2(x, y);
	
	float d = sdf_rounded_X(uv, 0.8, 0.2);
	float alpha = pow(1.0 - d, 15.0);
	vec3 col = bullet_color;
	col *= 0.8 + 0.2 * cos(10.0 * d + TIME);
	col = mix( col, vec3(1.0), 1.0-smoothstep(0.0,0.1,abs(d)) );
	
	COLOR = vec4(col, alpha);
}
