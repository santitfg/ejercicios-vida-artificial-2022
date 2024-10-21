#ifdef GL_ES
precision mediump float;
precision mediump int;
#endif

#define PROCESSING_TEXTURE_SHADER

uniform sampler2D texture;
uniform sampler2D texture1;

// uniform vec2 texOffset;
// varying vec4 vertColor;
varying vec4 vertTexCoord;

void main(void){
    vec2 uv=vertTexCoord.st;
    vec4 col0=texture2D(texture,uv);
    uv.y=1.-uv.y;//compesnacion de que los cord de la camara vienen invertidas
    vec4 col1=texture2D(texture1,uv);
    
    gl_FragColor=vec4(col0.rgb*col1.rgb,1.);
}
