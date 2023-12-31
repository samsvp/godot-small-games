shader_type canvas_item;

#define N 100

uniform vec2 u_resolution = vec2(900, 500);
uniform vec2[N] u_spotlight;
/*
 * Generates a random number between 0 and 1
 */
float rand1d(float v)
{
    return cos(v + cos(v * 90.1415) * 100.1415) * 0.5 + 0.5;
}

float rand1d_range(float v, float min_v, float max_v)
{
    return (max_v - min_v) * rand1d(v) + min_v;
}

float rand1d_vec2_seed(vec2 coord, vec2 seed)
{
    return fract(
        sin(
            dot(coord, seed)
        ) * 43758.5453
    );
}

float rand1d_vec2(vec2 coord)
{
    return rand1d_vec2_seed(coord, vec2(12.9898, 78.233));
}

vec2 rand2d(vec2 value)
{
	return vec2(
		rand1d_vec2_seed(value, vec2(12.989, 78.233)),
		rand1d_vec2_seed(value, vec2(39.346, 11.135))
	);
}

vec2 rand2d_range(vec2 v, float min_v, float max_v)
{
    return (max_v - min_v) * rand2d(v) + min_v;
}

/*
 * Returns wheter p1 is close to p2
 */
bool close(float p1, float p2, float eps)
{
    return p1 < p2 + eps && p1 > p2 - eps;
}


float deg2rad(float angle)
{
    return PI * angle / 180.0;
}


/*
 * Rotates the given coordinates by
 * theta rads. This changes the input
 * coordinates
 */
void rotate_coord(float theta, out vec2 coord)
{
    mat2 R = mat2(vec2(cos(theta), -sin(theta)),
                  vec2(sin(theta), cos(theta)));

    coord *= R;
}


/*
 * Scales the given coordinates by s.
 * This changes the input coordinates
 */
void scale_coord(float s, vec2 coord)
{
    coord /= s;
}


/*
 * Rotates the given coordinates by
 * theta rads
 */
vec2 rotate(float theta, vec2 coord)
{
    mat2 R = mat2(vec2(cos(theta), -sin(theta)),
                  vec2(sin(theta), cos(theta)));

    return coord * R;
}

vec2 rotate_ellipsis(float k, float theta, vec2 coord)
{
    mat2 R = mat2(vec2(cos(theta), -k * sin(theta)),
                  vec2(sin(theta) / k, cos(theta)));

    return coord * R;
}

/*
 * Scales the given coordinates by s
 */
vec2 scale(float s, vec2 coord)
{
    return coord / s;
}


/*
 * Creates a point of light
 */
vec3 light_point_bright(vec2 point, float brightness)
{
    vec3 color = vec3(0.);

    float l = pow(length(point), 1.3);
    color += 0.00008 / l * brightness;

    return color;
}


vec3 light_point(vec2 point)
{
    return light_point_bright(point, 5.0);
}


void fragment()
{
	vec2 coord = (2.0 * FRAGCOORD.xy - u_resolution) / 
		min(u_resolution.y, u_resolution.x);
	
	vec2 grid_size = vec2(16);
	vec2 r = mod(u_resolution * UV, grid_size);
	vec2 lines = smoothstep(1.0 - 0.1, 1, r / grid_size);
	float intensity = dot(lines, vec2(1.0, 1.0));
	float sd = 0.25;
	for (int i = 0; i < N; i++) {
		vec2 s = u_spotlight[i];
		if (s.x > 100.0) {
			break;
		}
		sd += 2.0 * (1.0 - clamp(2.5 * length(coord - s), 0.0, 1.0));
	}
	sd = clamp(sd, 0.0, 1.0);
	vec3 grid = sd * 0.4 * vec3(
		0.125 * intensity,
		0.25 * intensity,
		intensity
	);
	
	vec3 color = vec3(0.0);
	
	// generate random values to place stars in
	for (float i=1.0; i < 45.0; i++) 
	{
		float value1 = rand1d_range(.2 * i, -1., 1.);
		float value2 = rand1d_range(.2 * i + rand1d(.2 * i), -1., 1.);
		
		vec2 point1 = vec2(value1, value2);
		
		vec2 n_coord = rotate(
			0.25 * distance(point1, vec2(0.0)) * TIME,
			coord);
			
		float brightness = 40.0 * (0.5 * 
			sin(.02 * PI * TIME * rand1d_range(value1, 1.0, 2.0)) + 0.6);
			
		color += light_point_bright(n_coord + point1, brightness);
		
		if (fract(i / 10.0) == 0.0) {
			color.r *= rand1d_range(0.2 * i, 0.2, 0.9);
			color.g *= rand1d_range(0.9 * i, 0.7, 0.8);
			color.b *= rand1d_range(2.0 * i, 0.3, 0.5);
		}
	}

	color += grid;
	COLOR = vec4(0.5 * color, 1.0);
}