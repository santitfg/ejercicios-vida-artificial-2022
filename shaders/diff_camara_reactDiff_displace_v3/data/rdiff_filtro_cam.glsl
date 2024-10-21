
/*
formula de  Karl Sims (https://www.karlsims.com/rd.html)
estudiada a partir de sol Sarratea (https://visualizer.solsarratea.world/04-gray-scott/) (https://github.com/solsarratea)
y Simon Alexander-Adams desde donde adapte partes del codigo provenientes de la case sobre sistemas complejos (https://www.simonaa.media/tutorials/complex-systems-workshop)
*/
#ifdef GL_ES
precision mediump float;
precision mediump int;
#endif

#define PROCESSING_TEXTURE_SHADER
uniform bool click;
uniform bool reset;
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
uniform float mixer;
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
  
  vec2 st=gl_FragCoord.xy/u_resolution.xy;
  
  st=floor(st*div)/div;//+.0039
  
  vec4 final=vec4(st,0,1);
  
  float componentA=getR(texture,0.,.0);
  
  float componentB=getG(texture,0.,.0);
  // convoluciones
  
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
  
  // Gray-Scott equation
  float da=ra*laplacianA-(componentA*componentB*componentB)+feed*(1.-componentA);
  float db=rb*laplacianB+(componentA*componentB*componentB)-(kill+feed)*componentB;
  
  //velocidad con la que se acumula la reaccion
  componentA+=da*velocidad;
  componentB+=db*velocidad;
  
  //filtro en caso de que los valores salgan de normalizados
  final=vec4(clamp(componentA,0.,1.),clamp(componentB,0.,1.),0.,1.);
  
  //filtro de mix para mezclar el bufer con la imagen entrante
  final=mix(final,texture2D(texCam,1.-st),mixer);
  
  gl_FragColor=final;
  
}
