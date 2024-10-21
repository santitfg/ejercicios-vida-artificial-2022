#ifdef GL_ES
precision mediump float;
precision mediump int;
#endif

#define PROCESSING_TEXTURE_SHADER

uniform sampler2D texture;
uniform sampler2D texCam;
// uniform vec2 texOffset;

// varying vec4 vertColor;
varying vec4 vertTexCoord;

void main(void) {
  // // Grouping texcoord variables in order to make it work in the GMA 950. See post #13
  // // in this thread:
  // // http://www.idevgames.com/forums/thread-3467.html
//  vec2 tc0 = vertTexCoord.st + vec2(-texOffset.s, -texOffset.t);
   vec2 uv = vertTexCoord.st;
  //uv.y=1.-uv.y;

  vec4 col0 = texture2D(texture, 1.-uv);
  vec4 col1 = texture2D(texCam, 1.-uv);
          
  gl_FragColor = vec4((col1*0.49+col0).rgb*0.5, 1.0);  
  // gl_FragColor = vec4((col1+col0).rgb, 1.0);  
}
