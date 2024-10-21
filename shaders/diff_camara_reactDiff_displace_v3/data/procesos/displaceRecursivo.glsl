#ifdef GL_ES
precision mediump float;
precision mediump int;
#endif

#define PROCESSING_TEXTURE_SHADER

uniform float u_time;
uniform float scale;
uniform float mult;
uniform float blend;
uniform float multNoise;
uniform vec2 t_noise;
uniform sampler2D texture;
uniform sampler2D texA;
// uniform sampler2D texB;

// varying vec4 vertColor;
varying vec4 vertTexCoord;

float random(vec2 st){
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
            
            // Smooth Interpolation
            
            // Cubic Hermine Curve.  Same as SmoothStep()
            vec2 u=f*f*(3.-2.*f);
            // u = smoothstep(0.,1.,f);
            
            // Mix 4 coorners percentages
            return mix(a,b,u.x)+
            (c-a)*u.y*(1.-u.x)+
            (d-b)*u.x*u.y;
        }
        
        vec2 random2(vec2 st){
            st=vec2(dot(st,vec2(127.1,311.7)),
            dot(st,vec2(269.5,183.3)));
            return-1.+2.*fract(sin(st)*43758.5453123);
        }
        float noise2(vec2 st){
            vec2 i=floor(st);
            vec2 f=fract(st);
            
            vec2 u=f*f*(3.-2.*f);
            
            return mix(mix(dot(random2(i+vec2(0.,0.)),f-vec2(0.,0.)),
            dot(random2(i+vec2(1.,0.)),f-vec2(1.,0.)),u.x),
            mix(dot(random2(i+vec2(0.,1.)),f-vec2(0.,1.)),
            dot(random2(i+vec2(1.,1.)),f-vec2(1.,1.)),u.x),u.y);
        }
        
        void main(void){
            vec2 uv=vertTexCoord.st;
            
            vec4 col0=texture2D(texture,uv);
            vec4 acumulado=texture2D(texture,fract(uv+col0.rb*mult+noise2(uv*scale+(u_time*t_noise))*multNoise));// vec2(uv.x,1.-uv.y);
            //+noise2(uv+u_time*scale)*multNoise
            uv.y=1.-uv.y;
            
            vec4 col1=texture2D(texA,fract(uv+col0.rb*mult));// vec2(uv.x,1.-uv.y);
            //aca tengo que pensarlo mejor!
            
            vec4 color=mix(acumulado,col1,blend);
//color=vec4(noise2(uv*scale+(u_time*t_noise))*multNoise);
            gl_FragColor=vec4(color.rgb,1.);
            //gl_FragColor = vec4(col0.rgb, 1.0);
        }
        