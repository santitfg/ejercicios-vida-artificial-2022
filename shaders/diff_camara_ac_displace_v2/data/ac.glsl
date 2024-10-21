#ifdef GL_ES
precision mediump float;
precision mediump int;
#endif

#define PROCESSING_COLOR_SHADER

uniform sampler2D ppixels;
uniform sampler2D camara;
// varying vec4 vertTexCoord;
uniform vec2 u_resolution;
uniform float u_time;
uniform float div;

// uniform vec2 textureResolution;
// uniform vec2 u_resolution;
// uniform vec2 u_mouse;
// uniform float u_time;

vec2 pxDisplace(float x,float y)
{
    vec2 st=gl_FragCoord.xy/u_resolution.xy;
    vec2 pixel=1./u_resolution.xy;//vec2 st=vertTexCoord.st;//
    return st+pixel*vec2(x,y);
}
float getA(sampler2D tex,float x,float y)
{
    vec2 st=gl_FragCoord.xy/u_resolution.xy;
    vec2 pixel=1./u_resolution.xy;//vec2 st=vertTexCoord.st;//
    return texture2D(tex,st+pixel*vec2(x,y)).a;
}

vec3 getRGB(sampler2D tex,float x,float y)
{
    vec2 st=gl_FragCoord.xy/u_resolution.xy;
    // float div=250.;
    st=floor(st*div)/div;
    vec2 pixel=1./u_resolution.xy;//vec2 st=vertTexCoord.st;//
    return texture2D(tex,fract(st+pixel*vec2(x,y))).rgb;
}

float getMeanRGB(sampler2D tex,float x,float y)
{
    vec2 st=gl_FragCoord.xy/u_resolution.xy;
    // float div=250.;
    st=floor(st*div)/div;
    vec2 pixel=1./u_resolution.xy;//vec2 st=vertTexCoord.st;//
    vec3 rgb=texture2D(tex,fract(st+pixel*vec2(x,y))).rgb;
    return(rgb.r+rgb.g+rgb.b)/3.;
}
vec4 getRGBA(sampler2D tex,float x,float y)
{
    vec2 st=gl_FragCoord.xy/u_resolution.xy;
    vec2 pixel=1./u_resolution.xy;//vec2 st=vertTexCoord.st;//
    return texture2D(tex,st+pixel*vec2(x,y));
}
void main(){
    //vec2 st=vertTexCoord.st;//
    vec2 st=(gl_FragCoord.xy/(u_resolution.xy));// st = 41./u_resolution.xy;
    vec2 uv=st;
    // float div=100.;
    // st=floor(st*div)/div;
    vec4 color=texture2D(ppixels,st);
    
    color.rgb=getRGB(camara,1.,.0);
    color.rgb+=getRGB(camara,.0,1.);
    color.rgb+=getRGB(camara,-1.,.0);
    color.rgb+=getRGB(camara,.0,-1.);
    
    color.rgb+=getRGB(camara,1.,1.);
    color.rgb+=getRGB(camara,-1.,-1.);
    color.rgb+=getRGB(camara,-1.,1.);
    color.rgb+=getRGB(camara,1.,-1.);
    
    // color.rgb/=8.;
    
    if((color.r>=2.9)&&(color.r<=3.1)){
        color.rgb=vec3(1);
    }
    
    else{
        
        color.rgb=getRGB(ppixels,1.,.0);
        color.rgb+=getRGB(ppixels,.0,1.);
        color.rgb+=getRGB(ppixels,-1.,.0);
        color.rgb+=getRGB(ppixels,.0,-1.);
        
        color.rgb+=getRGB(ppixels,1.,1.);
        color.rgb+=getRGB(ppixels,-1.,-1.);
        color.rgb+=getRGB(ppixels,-1.,1.);
        color.rgb+=getRGB(ppixels,1.,-1.);
        if((color.r>=2.9)&&(color.r<=3.1)){
            color.rgb=vec3(1);
        }
        
        else{
            color.rgb=vec3(0);
        }
    }
    
    gl_FragColor=vec4(color.rgb,1.);
}
