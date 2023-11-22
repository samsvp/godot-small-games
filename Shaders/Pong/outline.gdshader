shader_type canvas_item;


uniform float outline_width = 1.0;
uniform vec4 outline_color = vec4(0.0, 0.0, 0.0, 1.0);

void fragment() 
{
	vec4 col = texture(TEXTURE, UV);
	vec2 ps = TEXTURE_PIXEL_SIZE;
	
	float a;
	float maxa = col.a;
	float mina = col.a;
	
	a = texture(TEXTURE, UV + vec2(0.0, -outline_width) * ps).a;
	maxa = max(a, maxa);
	mina = min(a, mina);
	
	a = texture(TEXTURE, UV + vec2(0.0, outline_width) * ps).a;
	maxa = max(a, maxa);
	mina = min(a, mina);
	
	a = texture(TEXTURE, UV + vec2(outline_width, 0.0) * ps).a;
	maxa = max(a, maxa);
	mina = min(a, mina);
	
	a = texture(TEXTURE, UV + vec2(-outline_width, 0.0) * ps).a;
	maxa = max(a, maxa);
	mina = min(a, mina);
	
	vec4 out_col = mix(vec4(UV.yx, 0.5, 1.0), outline_color, 0.7);
	COLOR = mix(col, out_col, maxa - mina);
}
