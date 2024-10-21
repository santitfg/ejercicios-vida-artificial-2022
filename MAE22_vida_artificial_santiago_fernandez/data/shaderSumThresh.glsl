#ifdef GL_ES
precision mediump float;
precision mediump int;
#endif

#define PROCESSING_TEXTURE_SHADER

uniform sampler2D texture;
uniform sampler2D texture1;
uniform float f;
uniform float thresh;

varying vec4 vertTexCoord;

void main(void){
  vec2 uv=vertTexCoord.st;
  vec4 col0=texture2D(texture,uv);
  vec4 col1=texture2D(texture1,uv);
  vec4 colFinal=step(thresh,col1)*(1.-f)+col0*f;
  gl_FragColor=vec4(colFinal.rgb,1.);
}
