#ifdef GL_ES
precision mediump float;
precision mediump int;
#endif
#define PROCESSING_TEXTURE_SHADER

uniform sampler2D texture;
varying vec4 vertTexCoord;
uniform vec2 u_resolution;
// uniform float u_time;

// uniform vec2 textureResolution;
// uniform vec2 u_resolution;
// uniform vec2 u_mouse;
// uniform float u_time;

vec2 pxDisplace(float x,float y)
{
    vec2 st=gl_FragCoord.xy/u_resolution.xy;vec2 pixel=1./u_resolution.xy;//vec2 st=vertTexCoord.st;//
    return st+pixel*vec2(x,y);
}
float getA(sampler2D tex,float x,float y)
{
    vec2 st=gl_FragCoord.xy/u_resolution.xy;vec2 pixel=1./u_resolution.xy;//vec2 st=vertTexCoord.st;//
    return texture2D(tex,st+pixel*vec2(x,y)).a;
}

vec3 getRGB(sampler2D tex,float x,float y)
{
    vec2 st=gl_FragCoord.xy/u_resolution.xy;vec2 pixel=1./u_resolution.xy;//vec2 st=vertTexCoord.st;//
    return texture2D(tex,fract(st+pixel*vec2(x,y))).rgb;
}
vec4 getRGBA(sampler2D tex,float x,float y)
{
    vec2 st=gl_FragCoord.xy/u_resolution.xy;vec2 pixel=1./u_resolution.xy;//vec2 st=vertTexCoord.st;//
    return texture2D(tex,st+pixel*vec2(x,y));
}
void main(){
    vec2 st=vertTexCoord.st;//
    //vec2 st=gl_FragCoord.xy/u_resolution.xy;// st = 41./u_resolution.xy;
    vec4 color=vec4(st.x,st.y,0.,1.);
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
    color.rgb = getRGB(texture,.0,.0)*4.;
    
    color.rgb += getRGB(texture,1.0,.0)*2.;
    color.rgb += getRGB(texture,.0,1.0)*2.;
    color.rgb += getRGB(texture,-1.0,.0)*2.;
    color.rgb += getRGB(texture,.0,-1.0)*2.;
    
    color.rgb += getRGB(texture,1.,1.);
    color.rgb += getRGB(texture,-1.,-1.);
    color.rgb += getRGB(texture,-1.,1.);
    color.rgb += getRGB(texture,1.,-1.);
    
    color.rgb/=16.;
    
    /*
    //box blur 9*1.=9
    color.rgb = getRGB(texture,.0,.0);
    
    color.rgb += getRGB(texture,1.0,.0);
    color.rgb += getRGB(texture,.0,1.0);
    color.rgb += getRGB(texture,-1.0,.0);
    color.rgb += getRGB(texture,.0,-1.0);
    
    color.rgb += getRGB(texture,1.,1.);
    color.rgb += getRGB(texture,-1.,-1.);
    color.rgb += getRGB(texture,-1.,1.);
    color.rgb += getRGB(texture,1.,-1.);
    
    color.rgb/=9.;
    */
    color=mix(color,texture2D(texture,st),.5);
    gl_FragColor=vec4(color.rgb,1.);
}
