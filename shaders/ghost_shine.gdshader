/* 
@LURGX 2024 ghost shine
*/
shader_type canvas_item;

uniform bool active = false; //Activate shader
//Flash effects
uniform bool flash = false; //Activate shader
uniform vec3 flash_color : source_color = vec3(1.0);
//Ghost Outline effects
uniform bool shain = false; //Activate the rainbow or select you color
uniform bool onecolor = false; //Activate the rainbow or select you color
uniform vec4 line_color : source_color = vec4(1.0, 1.0, 1.0, 1.0); //color line
uniform float line_scale : hint_range(0, 1.5) = 1.0;    // thickness of the line
uniform float shadow : hint_range(0, 1.6) = 1.6;    // shadow lenght
uniform float shadow_mult : hint_range(0, 1.6) = 1.6;    // shadow alpha
uniform float frequency : hint_range(0.0, 5.0) = 2;  // frequency of the shine
uniform float transparency: hint_range(0.0, 5.0) = 0;  // transparency of shadow/if you use a onecolor please up the transparency



void fragment() {
	if ( active == true ){
		if ( flash == true ){
			vec4 t = texture(TEXTURE, UV);
			if (active == true) {
				COLOR = vec4(flash_color, t.a);
			}
		}
		else
		{
			float alpha = 0.6;
			vec2 size = TEXTURE_PIXEL_SIZE * line_scale;
			float outline = texture(TEXTURE, UV + vec2(-size.x, 0)).a;
			outline += texture(TEXTURE, UV + vec2(0, size.y)).a;
			outline += texture(TEXTURE, UV + vec2(size.x, 0)).a;
			outline += texture(TEXTURE, UV + vec2(0, -size.y)).a;
			outline += texture(TEXTURE, UV + vec2(-size.x, size.y)).a;
			outline += texture(TEXTURE, UV + vec2(size.x, size.y)).a;
			outline += texture(TEXTURE, UV + vec2(-size.x, -size.y)).a;
			outline += texture(TEXTURE, UV + vec2(size.x, -size.y)).a;
			outline = min(outline, shadow*shadow_mult);

			vec4 animated_line_color = vec4(0.5 + sin(2.0*3.14*frequency*TIME),
									   0.5 + sin(2.0*3.14*frequency*TIME + radians(120.0)) +transparency,
									   0.5 + sin(2.0*3.14*frequency*TIME + radians(240.0)),
									   alpha );
		//							   alpha + cos(2.0*3.14*frequency*TIME + radians(240.0)));
			vec4 one_color = vec4(line_color.r,line_color.g,line_color.b,0) + vec4(line_color.r * sin(frequency*2.0*TIME) + line_color.r-0.2,
									   line_color.g * sin(frequency*2.0*TIME) + line_color.g-0.2,
									   line_color.b * sin(frequency*2.0*TIME) + line_color.b-0.2,
									   alpha );


			vec4 animated = vec4(line_color.r ,
									   line_color.g,
									   line_color.b,
									   alpha);




			vec4 color = texture(TEXTURE, UV);

			if (onecolor == true){
				COLOR = mix(color,one_color*transparency,outline+color.a);
			}


			if (shain == true && onecolor == false){
				COLOR = mix(color,animated_line_color, outline + color.a);
				
			}
			else if (shain == false && onecolor == false){
				COLOR = mix(color,animated, outline + color.a);
			}
		}
	}
}