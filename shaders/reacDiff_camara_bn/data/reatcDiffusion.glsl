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
//#define PROCESSING_COLOR_SHADER
//uniform sampler2D ppixels;

//este tipo de preprocesador es para filtros
#define PROCESSING_TEXTURE_SHADER
uniform sampler2D texture;

uniform sampler2D camara;
uniform bool click;
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

void main(void)
{
    vec2 st=gl_FragCoord.xy/u_resolution.xy;
    
    if(click){
        if (length(st-u_mouse) < 0.1) {
            float rnd1 = mod(fract(sin(dot(st + u_time * 0.001, vec2(14.9898,78.233))) * 43758.5453), 1.0);
            float rnd2 = mod(fract(sin(dot(st + u_time * 0.001, vec2(13.9881,79.2343))) * 45852.5453), 1.0);
            if (rnd1 > 0.5) {
                gl_FragColor = vec4(rnd1,rnd2,1.,1.);
            } else {
                gl_FragColor = texture2D(texture,st);
            }
        }
    }
    //change in x and y for computing laplacian
    float dx=1./u_resolution.x;
    float dy=1./u_resolution.y;
    
    float componentA=getR(texture,0.,.0);//component A
    float componentB=getG(texture,0.,.0);//component B
    
    //apply convolution (laplacian)
    
    float laplacianA;
    laplacianA=componentA*center;
    
    laplacianA+=getR(texture,1.,.0)*adj;
    laplacianA+=getR(texture,.0,1.)*adj;
    laplacianA+=getR(texture,-1.,.0)*adj;
    laplacianA+=getR(texture,.0,-1.)*adj;
    
    laplacianA+=getR(texture,1.,1.)*diag;
    laplacianA+=getR(texture,-1.,-1.)*diag;
    laplacianA+=getR(texture,-1.,1.)*diag;
    laplacianA+=getR(texture,1.,-1.)*diag;
    
    /*    laplacianA=getR(camara,0.,.0);
    
    laplacianA+=getR(camara,1.,.0);
    laplacianA+=getR(camara,.0,1.);
    laplacianA+=getR(camara,-1.,.0);
    laplacianA+=getR(camara,.0,-1.);
    
    laplacianA+=getR(camara,1.,1.);
    laplacianA+=getR(camara,-1.,-1.);
    laplacianA+=getR(camara,-1.,1.);
    laplacianA+=getR(camara,1.,-1.);
    */
    float laplacianB;
    laplacianB=componentB*center;
    
    laplacianB+=getG(texture,1.,.0)*adj;
    laplacianB+=getG(texture,.0,1.)*adj;
    laplacianB+=getG(texture,-1.,.0)*adj;
    laplacianB+=getG(texture,.0,-1.)*adj;
    
    laplacianB+=getG(texture,1.,1.)*diag;
    laplacianB+=getG(texture,-1.,-1.)*diag;
    laplacianB+=getG(texture,-1.,1.)*diag;
    laplacianB+=getG(texture,1.,-1.)*diag;
    
    //feed and kill rates:
    // float f=getMeanRGB(camara,0.,.0)+feed;
    // float k=componentB+kill;
    
    // Gray-Scott equation
    float da=ra*laplacianA-(componentA*componentB*componentB)+feed*(1.-componentA);
    float db=rb*laplacianB+(componentA*componentB*componentB)-(kill+feed)*componentB;
    
    //"time" controls global rate of change
    componentA+=da*velocidad;
    componentB+=db*velocidad;
    
    //clamp and output components a and b
    gl_FragColor=vec4(clamp(componentA,0.,1.),clamp(componentB,0.,1.),0.,1.);
    
}

