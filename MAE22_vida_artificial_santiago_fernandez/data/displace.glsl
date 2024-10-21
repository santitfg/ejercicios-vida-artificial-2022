#ifdef GL_ES
precision mediump float;
precision mediump int;
#endif

#define PROCESSING_TEXTURE_SHADER

uniform float mult;
uniform sampler2D texA;
uniform sampler2D texB;
varying vec4 vertTexCoord;

void main(void){
    vec2 uv=vertTexCoord.st;///cordenadas de textura aprovechando el macro que pasa processing
    uv.y=1.-uv.y;//inversion de uv en vertical
    
    vec4 col0=texture2D(texA,uv);
    //adaptado a los canales rojo y verde
    uv.x=1.-uv.x;//inversion de uv en horizontal
    
    vec4 col1=texture2D(texB,fract(uv+col0.rg*mult));
    
    gl_FragColor=vec4(col1.rgb,1.);
    //gl_FragColor = vec4(col0.rgb, 1.0);
}
