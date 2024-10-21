#ifdef GL_ES
precision mediump float;
precision mediump int;
#endif

#define PROCESSING_TEXTURE_SHADER
uniform bool click;
uniform bool reset;
// varying vec4 vertTexCoord;
uniform vec2 u_resolution;
uniform float u_time;
uniform vec2 u_mouse;
uniform sampler2D texture;
uniform sampler2D texCam;
uniform vec2 texOffset;
uniform float velocidad;
uniform float div;

uniform float ra;// rate of diffusion of A
uniform float rb;// rate of diffusion of B
uniform float feed;// feed rate
uniform float kill;// kill rate

//convolution weights
uniform float center;
uniform float adj;
uniform float diag;
varying vec4 vertColor;
varying vec4 vertTexCoord;

float getR(sampler2D tex,float x,float y)
{
  vec2 st=gl_FragCoord.xy/u_resolution.xy;
  // st=floor(st*div)/div;
  vec2 pixel=1./u_resolution.xy;//vec2 st=vertTexCoord.st;//
  return texture2D(tex,st+pixel*vec2(x,y)).r;
}

float getG(sampler2D tex,float x,float y)
{
  vec2 st=gl_FragCoord.xy/u_resolution.xy;
  // st=floor(st*div)/div;
  vec2 pixel=1./u_resolution.xy;//vec2 st=vertTexCoord.st;//
  return texture2D(tex,st+pixel*vec2(x,y)).g;
}

void main(void){
  //vec2 st=vertTexCoord.xy;//
  vec2 st=gl_FragCoord.xy/u_resolution.xy;
  st=floor(st*div+.0039)/div;
  vec4 final=vec4(st,0,1);
  if(click){
    vec4 sum=vec4(0);
    
    if(length(st.xy-u_mouse.xy)<.1){
      float rnd1=mod(fract(sin(dot(st+u_time*.001,vec2(14.9898,78.233)))*43758.5453),1.);
      float rnd2=mod(fract(sin(dot(st+u_time*.001,vec2(13.9881,79.2343)))*45852.5453),1.);
      
      if(rnd1>.5){
        sum=vec4(rnd1,rnd2,0.,1.);
      }
      
    }
    //gl_FragColor=
    final=clamp(sum+texture2D(texture,st),vec4(0.),vec4(1.));
  }else if(reset){
    //gl_FragColor=
    final=texture2D(texCam,1.-st);//vec4(0,0,0,1);
  }else{
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
    //gl_FragColor=
    final=vec4(clamp(componentA,0.,1.),clamp(componentB,0.,1.),0.,1.);
  }
  
  gl_FragColor=final;
  
}
