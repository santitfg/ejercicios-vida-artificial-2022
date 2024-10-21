#ifdef GL_ES
precision mediump float;
precision mediump int;
#endif

#define PROCESSING_TEXTURE_SHADER

uniform sampler2D texFrameAnterior;
uniform sampler2D texCam;
varying vec4 vertTexCoord;

void main(void){
  vec2 uv=vertTexCoord.st;
  vec4 col0=texture2D(texFrameAnterior,uv);
  uv.y=1.-uv.y;
  vec4 col1=texture2D(texCam,uv);
  vec3 colFinal=vec3(abs(col1-col0).r+abs(col1-col0).b+abs(col1-col0).g)/3.;
  gl_FragColor=vec4(colFinal,1.);
}
