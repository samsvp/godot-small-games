shader_type canvas_item;

uniform vec3 bullet_color;
uniform float time;


mat2 rotate2d(float _angle){
	float s = sin(_angle);
	float c = cos(_angle);
    return mat2(vec2(c, -s),
                vec2(s, c));
}


float sdf_cross(vec2 pos, vec2 wh, float corner_radius)
{
	pos = abs(pos); 
	pos = (pos.y>pos.x) ? pos.yx : pos.xy;
    vec2  q = pos - wh;
    float k = max(q.y,q.x);
    vec2  w = (k>0.0) ? q : vec2(wh.y-pos.x,-k);
    return sign(k)*length(max(w,0.0)) + corner_radius;
}


void fragment() 
{
	float x = 2.0 * (UV.x - 0.5);
	float y = 2.0 * (0.5 - UV.y);
	vec2 uv = rotate2d(100.0 * time) * vec2(x, y);
	
	float d = sdf_cross( uv, vec2(0.75, 0.25), 0.1 );
	float alpha = pow(1.0 - d, 15.0);
	vec3 col = bullet_color;
	col *= 0.8 + 0.2 * cos(10.0 * d + TIME);
	col = mix( col, vec3(1.0), 1.0-smoothstep(0.0,0.1,abs(d)) );
	
	COLOR = vec4(col, alpha);
}
