// Author @patriciogv - 2015
// http://patriciogonzalezvivo.com

#ifdef GL_ES
precision mediump float;
#endif

#define PI 3.14159265359

uniform sampler2D u_tex0;
uniform sampler2D u_tex1;
//uniform vec2 u_tex0Resolution;
uniform vec3 u_color;
uniform vec2 u_resolution;
uniform vec2 u_mouse;
uniform float u_time;
uniform float scale;


// Based on Morgan
// https://www.shadertoy.com/view/4dS3Wd
float random(in vec2 st){
    return fract(sin(dot(st.xy,
                vec2(12.9898,78.233)))*
            43758.5453123);
        }
        
        float noise(in vec2 st){
            vec2 i=floor(st);
            vec2 f=fract(st);
            
            // Four corners in 2D of a tile
            float a=random(i);
            float b=random(i+vec2(1.,0.));
            float c=random(i+vec2(0.,1.));
            float d=random(i+vec2(1.,1.));
            
            vec2 u=f*f*(3.-2.*f);
            
            return mix(a,b,u.x)+
            (c-a)*u.y*(1.-u.x)+
            (d-b)*u.x*u.y;
        }
vec2 random2(vec2 st){
    st = vec2( dot(st,vec2(127.1,311.7)),
              dot(st,vec2(269.5,183.3)) );
    return -1.0 + 2.0*fract(sin(st)*43758.5453123);
}
float noise2(vec2 st) {
    vec2 i = floor(st);
    vec2 f = fract(st);

    vec2 u = f*f*(3.0-2.0*f);

    return mix( mix( dot( random2(i + vec2(0.0,0.0) ), f - vec2(0.0,0.0) ),
                     dot( random2(i + vec2(1.0,0.0) ), f - vec2(1.0,0.0) ), u.x),
                mix( dot( random2(i + vec2(0.0,1.0) ), f - vec2(0.0,1.0) ),
                     dot( random2(i + vec2(1.0,1.0) ), f - vec2(1.0,1.0) ), u.x), u.y);
}

        vec3 rgb2hsb( in vec3 c ){
    vec4 K = vec4(0.0, -1.0 / 3.0, 2.0 / 3.0, -1.0);
    vec4 p = mix(vec4(c.bg, K.wz),
                 vec4(c.gb, K.xy),
                 step(c.b, c.g));
    vec4 q = mix(vec4(p.xyw, c.r),
                 vec4(c.r, p.yzx),
                 step(p.x, c.r));
    float d = q.x - min(q.w, q.y);
    float e = 1.0e-10;
    return vec3(abs(q.z + (q.w - q.y) / (6.0 * d + e)),
                d / (q.x + e),
                q.x);
}
        void main(){
            vec2 st=gl_FragCoord.xy/u_resolution.xy;
          	st-=0.5;
	st*=scale;
	st+=0.5;
           	vec4 color=vec4(rgb2hsb(u_color),1);
	color.rgb*=vec3(step(0.05,noise2(st+u_time)));
	//color.rgb*=vec3(noise2(st+u_time));
          	gl_FragColor=color;
        }