shader_type canvas_item;

uniform sampler2D screen_texture: hint_screen_texture, filter_nearest;
uniform vec2 lights[100];
uniform int number_of_lights = 1;
uniform vec4 modulate_color: source_color = vec4(0.0);
uniform float light_radius = 32.0;

float distance_to_light(vec2 coords) {
	float dist = 1000.0;
	
	for (int i = 0; i < number_of_lights; i++) {
		float new_dist = distance(coords, lights[i]);
		
		if(new_dist < dist) {
			dist = new_dist;
		}
	}
	
	return dist;
}

	// Called for every pixel the material is visible on.
void fragment() {
	COLOR = texture(screen_texture, SCREEN_UV);
	float dist = distance_to_light(FRAGCOORD.xy);
	
	if(dist > light_radius) {
		COLOR = COLOR * modulate_color;
	} else {
		vec4 adjusted_color = vec4(modulate_color.rgb, (dist / light_radius) * modulate_color.a);
		COLOR = COLOR * adjusted_color;
	}
}
