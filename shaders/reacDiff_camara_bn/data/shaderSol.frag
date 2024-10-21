
uniform vec2 res;
uniform sampler2D bufferTexture;
uniform sampler2D start;
uniform vec3 brush;
uniform float time;

uniform float dA;
uniform float dB;
uniform float feed;
uniform float k;
uniform float zoom;
uniform float rotate;
uniform float centerX;
uniform float centerY;

uniform float brushSize;
uniform float flow;

uniform int clear;
uniform bool enableBrush;
uniform bool toggle;

uniform float diff1;
uniform float diff2;
uniform float t;

uniform float tNeighbour;
uniform float rNeighbour;

int count=0;

vec2 rotateP(vec2 uv,vec2 pivot,float rotation){
    float sine=sin(rotation);
    float cosine=cos(rotation);
    
    uv-=pivot;
    uv.x=uv.x*cosine-uv.y*sine;
    uv.y=uv.x*sine+uv.y*cosine;
    uv+=pivot;
    
    return uv;
}

void main()
{
    vec4 mixy2;
    vec2 center=vec2(centerX,centerY);
    // load current values for a and b
    if(clear==1){
        gl_FragColor=vec4(0.);
        return;
    }
    
    vec2 pixelT=(1.-.03*zoom)*(gl_FragCoord.xy-center)+center;
    pixelT=rotateP(pixelT,center,rotate*0.);
    
    vec4 currentColor=texture2D(bufferTexture,(pixelT/res.xy));
    vec4 videoColor=texture2D(start,pixelT/res.xy);
    
    float a=currentColor.r;
    float b=currentColor.g;
    
    if(enableBrush){
        float dist=distance(brush.xy,gl_FragCoord.xy);
        if(dist<brushSize){
            float ratio=1.-dist/brushSize;
            b+=.5*ratio*brush.z;
        }
    }
    
    if(toggle){
        vec2 pixel=gl_FragCoord.xy/res.xy;
        vec2 pixelSize=1./res.xy;
        
        vec2 dy=(rNeighbour*vec2(1.,-1.)+tNeighbour)*pixelSize.y;
        vec2 dx=(rNeighbour*vec2(1.,-1.)+tNeighbour)*pixelSize.x;
        
        vec4 N=texture2D(bufferTexture,vec2(pixel.x,pixel.y+dy.y));
        vec4 S=texture2D(bufferTexture,vec2(pixel.x,pixel.y+dy.x));
        vec4 E=texture2D(bufferTexture,vec2(pixel.x+dx.x,pixel.y));
        vec4 W=texture2D(bufferTexture,vec2(pixel.x+dx.y,pixel.y));
        
        vec4 NE=texture2D(bufferTexture,vec2(pixel.x+dx.x,pixel.y+dy.x));
        vec4 NW=texture2D(bufferTexture,vec2(pixel.x+dx.y,pixel.y+dy.x));
        vec4 SE=texture2D(bufferTexture,vec2(pixel.x+dx.x,pixel.y+dy.y));
        vec4 SW=texture2D(bufferTexture,vec2(pixel.x+dx.y,pixel.y+dy.y));
        
        // Lapalace A
        float lapA=0.;
        lapA+=a*-1.;
        lapA+=N.r*diff1;
        lapA+=S.r*diff1;
        lapA+=E.r*diff1;
        lapA+=W.r*diff1;
        lapA+=NE.r*diff2;
        lapA+=NW.r*diff2;
        lapA+=SE.r*diff2;
        lapA+=SW.r*diff2;
        
        // Laplace B
        float lapB=0.;
        lapB+=b*-1.;
        lapB+=N.g*diff1;
        lapB+=S.g*diff1;
        lapB+=E.g*diff1;
        lapB+=W.g*diff1;
        lapB+=NE.g*diff2;
        lapB+=NW.g*diff2;
        lapB+=SE.g*diff2;
        lapB+=SW.g*diff2;
        
        // calculate diffusion reaction
        a+=((dA*lapA)-(a*b*b)+(feed*(1.-a)))*1.;
        b+=((dB*lapB)+(a*b*b)-((k+feed)*b))*1.;
        
        a=clamp(a,0.,1.);
        b=clamp(b,0.,1.);
        
        vec4 newColor=vec4(a,b,1.,1.);
        mixy2=videoColor*t*.1+newColor;
    }
    
    gl_FragColor=(toggle?mixy2:videoColor);
}

