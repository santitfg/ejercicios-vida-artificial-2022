#ifdef GL_ES
precision mediump float;
precision mediump int;
#endif

#define PROCESSING_TEXTURE_SHADER

uniform float mult;
uniform float blend;
uniform sampler2D texture;
uniform sampler2D texA;
uniform sampler2D texB;

// uniform vec2 texOffset;
// varying vec4 vertColor;
varying vec4 vertTexCoord;

void main(void){
    vec2 uv=vertTexCoord.st;
    
    vec4 anterior=texture2D(texture,uv);
    vec4 col0=texture2D(texture,uv);
    uv.y=1.-uv.y;
    vec4 col1=texture2D(texB,fract(uv+col0.rb*mult));// vec2(uv.x,1.-uv.y);
    vec4 color=mix(anterior,col1,blend);
    gl_FragColor=vec4(color.rgb,1.);
    //gl_FragColor = vec4(col0.rgb, 1.0);
}
