// Author @patriciogv - 2015
// http://patriciogonzalezvivo.com

#ifdef GL_ES
precision mediump float;
#endif

#define PI 3.14159265359

uniform sampler2D u_tex0;
uniform sampler2D u_tex1;
//uniform vec2 u_tex0Resolution;

uniform vec2 u_resolution;
uniform vec2 u_mouse;
uniform float u_time;
uniform float cant;
/*
uniform float scale;
uniform float scaleRuido;
uniform float velocidadRuido;
*/
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
        
        void main(){
            vec2 st=gl_FragCoord.xy/u_resolution.xy;
          
            vec4 color=texture2D(u_tex0,st);
	float x=texture2D(u_tex0,st.xx).r;
	float y=texture2D(u_tex0,st.yy).g;


 	color=texture2D(u_tex1,fract(st+vec2(color.x,color.y)*cant));	
//color=texture2D(u_tex1,st+vec2(color.x,color.y)*cant);
	
//color=texture2D(u_tex1,fract(st));
            gl_FragColor=color;
        }