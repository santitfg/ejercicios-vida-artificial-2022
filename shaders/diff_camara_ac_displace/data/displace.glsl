#ifdef GL_ES
precision mediump float;
precision mediump int;
#endif

#define PROCESSING_TEXTURE_SHADER

uniform float mult;
uniform sampler2D texA;
uniform sampler2D texB;
// uniform vec2 texOffset;
// varying vec4 vertColor;
varying vec4 vertTexCoord;

void main(void){
    vec2 uv=vertTexCoord.st;
    uv.x=1.-uv.x;
    vec4 col0=texture2D(texA,uv);
    uv.y=1.-uv.y;
    
    vec4 col1=texture2D(texB,fract(uv+col0.rb*mult));// vec2(uv.x,1.-uv.y);
    // if(col0.r<.01)col1/=pow(length(col1.xy),2.);//<--esta bueno como filtro
    // for(int i=0;i<10;i++){
        //     for(int j=0;i<10;j++){
            //         if(texture2D(texA,uv+vec2(i,j)/100.).r>.2)
            //         {
                //             col1+=.1/pow(length(uv),2.);
                
            // }}}
            gl_FragColor=vec4(col1.rgb,1.);
            //gl_FragColor = vec4(col0.rgb, 1.0);
        }
        