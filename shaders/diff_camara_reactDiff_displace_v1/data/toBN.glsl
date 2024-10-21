#ifdef GL_ES
precision mediump float;
precision mediump int;
#endif

#define PROCESSING_TEXTURE_SHADER

// varying vec4 vertTexCoord;
// uniform vec2 u_resolution;
// uniform float u_time;
// uniform vec2 u_mouse;
uniform sampler2D texture;
// uniform float bajo;
// uniform float alto;

varying vec4 vertColor;
varying vec4 vertTexCoord;

void main(void){
  vec2 st=vertTexCoord.xy;//
  // gl_FragColor=vec4(1.-vec3(smoothstep(bajo,alto,abs(texture2D(texture,st).r-texture2D(texture,st).g))),1.);
  
  // gl_FragColor=vec4(1.-vec3(abs(texture2D(texture,st).r-texture2D(texture,st).g)),1.);
  gl_FragColor=vec4(1.-vec3(step(.25,abs(texture2D(texture,st).r-texture2D(texture,st).g))),1.);
  
}
