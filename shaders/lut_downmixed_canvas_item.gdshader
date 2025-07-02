shader_type canvas_item;

uniform sampler2D lut;

vec4 pal_downmix(vec4 c) {
	float cr = floor(c.r * 255.0);
	float cg = floor(c.g * 255.0);
	float cb = floor(c.b * 255.0);

	float lutt = cb * 65536.0 + cg * 256.0 + cr * 1.0;
	float cy = floor(lutt / 4096.0);
	float cx = lutt - cy * 4096.0;

	float tx = (cx + .5) / 4096.0;
	float ty = (cy + .5) / 4096.0;

	return texture(lut, vec2(tx, ty));
}

void fragment() {
	COLOR.rgb = pal_downmix(texture(TEXTURE, UV)).rgb;
}