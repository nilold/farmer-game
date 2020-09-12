shader_type canvas_item;

//uniform is like export
uniform bool redish = true;

// fragment will execute in every single pixel
void fragment() {
	vec4 previous_color = texture(TEXTURE, UV);
	vec4 new_color = previous_color;
	if(redish){
		new_color = vec4(1.0, 0.0, 0.0, previous_color.a)/3.0;
		new_color += previous_color;
	}
	COLOR = new_color;
}