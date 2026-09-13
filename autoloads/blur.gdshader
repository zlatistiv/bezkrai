/*
shader_type spatial;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	// Called for every pixel the material is visible on.
}

//void light() {
//	// Called for every pixel for every light affecting the material.
//	// Uncomment to replace the default light processing function with this one.
//}
*/

shader_type canvas_item;

uniform sampler2D screen_tex : hint_screen_texture, filter_linear_mipmap;
uniform float radius : hint_range(0.0, 1.0) = 0.30;
uniform float softness : hint_range(0.0, 1.0) = 0.40;
uniform float blur : hint_range(0.0, 8.0) = 3.0;   // max mip LOD at the edge
uniform float darkness : hint_range(0.0, 1.0) = 0.85;
uniform vec2 center = vec2(0.5, 0.5);              // screen-space, 0..1

void fragment() {
	// aspect-correct so the falloff is a circle, not an ellipse
	vec2 res = 1.0 / SCREEN_PIXEL_SIZE;
	float aspect = res.x / res.y;
	vec2 diff = SCREEN_UV - center;
	diff.x *= aspect;
	float d = length(diff);

	float edge = smoothstep(radius, radius + softness, d);

	// blur by sampling a higher mip level the further out we are
	vec3 col = textureLod(screen_tex, SCREEN_UV, blur * edge).rgb;
	// darken toward black at the edges
	col = mix(col, vec3(0.0), darkness * edge);

	COLOR = vec4(col, 1.0);
}