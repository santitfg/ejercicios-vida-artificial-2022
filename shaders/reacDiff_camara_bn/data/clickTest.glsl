/* Gray Scott Reaction Diffusion

(c) 2019 Simon Alexander-Adams -
MIT License

Reference Materials:
Karl Sims: http://karlsims.com/rd.html
Daniel Shiffman: https://www.youtube.com/watch?v=BV9ny785UNc
Algosome: https://www.algosome.com/articles/reaction-diffusion-gray-scott.html
RDiffusion Cinder Example: https://github.com/cinder/Cinder/tree/master/samples/RDiffusion
Simon Alexander-Adams: https://www.simonaa.media
Sol Sarratea:
*/

#ifdef GL_ES
precision mediump float;
precision mediump int;
#endif

//este tipo de preprocesador es para vertex ejemplo el circle o rect
// #define PROCESSING_COLOR_SHADER
//uniform sampler2D ppixels;

//este tipo de preprocesador es para filtros
#define PROCESSING_TEXTURE_SHADER
uniform sampler2D texture;
uniform vec2 texOffset;

varying vec4 vertColor;
varying vec4 vertTexCoord;

// uniform sampler2D camara;
uniform int click;
// varying vec4 vertTexCoord;
uniform vec2 u_resolution;
uniform float u_time;
uniform float u_mouse;
uniform float velocidad;

uniform float ra;// rate of diffusion of A
uniform float rb;// rate of diffusion of B
uniform float feed;// feed rate
uniform float kill;// kill rate

//convolution weights
uniform float center;
uniform float adj;
uniform float diag;

//time
/*
float getMeanRGB(sampler2D tex,float x,float y)
{
    vec2 st=gl_FragCoord.xy/u_resolution.xy;
    vec2 pixel=1./u_resolution.xy;//vec2 st=vertTexCoord.st;//
    vec3 rgb=texture2D(tex,fract(st+pixel*vec2(x,y))).rgb;
    return(rgb.r+rgb.g+rgb.b)/3.;
}

float getR(sampler2D tex,float x,float y)
{
    vec2 st=gl_FragCoord.xy/u_resolution.xy;
    vec2 pixel=1./u_resolution.xy;//vec2 st=vertTexCoord.st;//
    return texture2D(tex,st+pixel*vec2(x,y)).r;
}

float getG(sampler2D tex,float x,float y)
{
    vec2 st=gl_FragCoord.xy/u_resolution.xy;
    vec2 pixel=1./u_resolution.xy;//vec2 st=vertTexCoord.st;//
    return texture2D(tex,st+pixel*vec2(x,y)).g;
}
*/
void main(void)
{
    //   vec2 st=vertTexCoord;//gl_FragCoord.xy/u_resolution.xy;
    
    if(click==1){
        // if(length(st-u_mouse)<.1){
            //     float rnd1=mod(fract(sin(dot(st+u_time*.001,vec2(14.9898,78.233)))*43758.5453),1.);
            //     float rnd2=mod(fract(sin(dot(st+u_time*.001,vec2(13.9881,79.2343)))*45852.5453),1.);
            //     if(rnd1>.5){
                //         gl_FragColor=vec4(rnd1,rnd2,1.,1.);
            //     }
        // }
        gl_FragColor=vec4(1.,0.,0.,1.);
        
    }else{
        gl_FragColor=vec4(0.,0.,1.,1.);
    }
    //change
    gl_FragColor=vec4(1.,0.,1.,1.);
    
}

