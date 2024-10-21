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
uniform int frame;

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
    float div=250.;
    st=floor(st*div)/div;
    vec2 pixel=1./u_resolution.xy;//vec2 st=vertTexCoord.st;//
    return texture2D(tex,fract(st+pixel*vec2(x,y))).rgb;
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
    
    // if(frame%60==0){
        //     color.rgb+=texture2D(camara,st).rgb;
    // }
    // else if(frame%3==0)
    // {
        /*
        st*4.;
        st+=pxDisplace(1.,0.);
        st+=pxDisplace(0.,1.);
        st+=pxDisplace(-1.,0.);
        st+=pxDisplace(0.,-1.);
        st+=pxDisplace(1.,1.);
        st+=pxDisplace(-1.,1.);
        st+=pxDisplace(1.,-1.);
        st+=pxDisplace(-1.,-1.);
        
        st/=9.;
        */
        
        //gaussian blur 4 + 2*4 + 1*4 = 16
        // color.rgb = getRGB(ppixels,.0,.0);
        // camara
        
        color.rgb = getRGB(camara,1.0,.0);
        color.rgb += getRGB(camara,.0,1.0);
        color.rgb += getRGB(camara,-1.0,.0);
        color.rgb += getRGB(camara,.0,-1.0);
        
        color.rgb += getRGB(camara,1.,1.);
        color.rgb += getRGB(camara,-1.,-1.);
        color.rgb += getRGB(camara,-1.,1.);
        color.rgb += getRGB(camara,1.,-1.);
        
        
        // color.rgb/=8.;
        
        if ((color.r >= 2.9) && (color.r <= 3.1)) {
            color.rgb = vec3(1);
        }
        // else if ( getRGB(ppixels,.0,.0).b > 0.004) {
            //     color.rgb = vec3(1);
        // }
        else {
            
            color.rgb = getRGB(ppixels,1.0,.0);
            color.rgb += getRGB(ppixels,.0,1.0);
            color.rgb += getRGB(ppixels,-1.0,.0);
            color.rgb += getRGB(ppixels,.0,-1.0);
            
            color.rgb += getRGB(ppixels,1.,1.);
            color.rgb += getRGB(ppixels,-1.,-1.);
            color.rgb += getRGB(ppixels,-1.,1.);
            color.rgb += getRGB(ppixels,1.,-1.);
            if ((color.r >= 2.9) && (color.r <= 3.1)) {
                color.rgb = vec3(1);
            }
            // else if ( getRGB(ppixels,.0,.0).b > 0.004) {
                //     color.rgb = vec3(1);
            // }
            else {
                color.rgb = vec3(0);
            }
        }
        //color.rgb += step(0.5,getRGB(camara,0.,0.));
        // color.rgb += getRGB(ppixels,0.,0.);
        
        
        // color.rgb=vec3(0);
        //color.rgb/=16.;
        
        /*
        //box blur 9*1.=9
        color.rgb = getRGB(ppixels,.0,.0);
        
        color.rgb += getRGB(ppixels,1.0,.0);
        color.rgb += getRGB(ppixels,.0,1.0);
        color.rgb += getRGB(ppixels,-1.0,.0);
        color.rgb += getRGB(ppixels,.0,-1.0);
        
        color.rgb += getRGB(ppixels,1.,1.);
        color.rgb += getRGB(ppixels,-1.,-1.);
        color.rgb += getRGB(ppixels,-1.,1.);
        color.rgb += getRGB(ppixels,1.,-1.);
        
        color.rgb/=9.;
        */
        // color=mix(color,texture2D(ppixels,st),sin(u_time));
    // }
    gl_FragColor=vec4(color.rgb,1.);
}
