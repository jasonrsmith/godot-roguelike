shader_type canvas_item;

// Based on crt-easymode
// https://github.com/libretro/glsl-shaders/blob/master/crt/shaders/crt-easymode.glsl
uniform float size_x=0.003;
uniform float size_y=0.003;

vec2 uv = SCREEN_UV;
uv-=mod(uv,vec2(size_x,size_y));

COLOR.rgb= texscreen(uv);