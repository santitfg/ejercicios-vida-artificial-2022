#ifdef GL_ES
precision mediump float;
precision mediump int;
#endif

#define PROCESSING_TEXTURE_SHADER

uniform sampler2D texFrameAnterior;
uniform sampler2D texCam;
// uniform vec2 texOffset;
// varying vec4 vertColor;
varying vec4 vertTexCoord;

void main(void){
  vec2 uv=vertTexCoord.st;
  
  vec3 col0=texture2D(texFrameAnterior,uv).rgb;
  uv.y=1.-uv.y;
  
  vec3 col1=vec3((texture2D(texCam,uv).r+texture2D(texCam,uv).g+texture2D(texCam,uv).b)/3.);// vec2(uv.x,1.-uv.y);
  
  gl_FragColor=vec4(abs(col1-col0).rgb,1.);
  //gl_FragColor = vec4(col0.rgb, 1.0);
}
