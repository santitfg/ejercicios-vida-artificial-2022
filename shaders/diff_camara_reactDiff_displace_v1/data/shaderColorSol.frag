
uniform vec2 resolution;
uniform sampler2D texture;
uniform vec3 color1;
uniform vec3 color2;
uniform vec3 color3;

float map(float value,float inMin,float inMax,float outMin,float outMax){
    return outMin+(outMax-outMin)*(value-inMin)/(inMax-inMin);
}

void main(void)
{
    vec2 uv=(gl_FragCoord.xy/resolution);
    
    vec3 black=vec3(0.,0.,0.);
    vec3 targetColor=vec3(0.,0.,0.);
    float sourceRamp=texture2D(texture,uv).g*3.;
    
    if(sourceRamp<.1)
    {
        // targetColor = black;
        
        float ramp=map(sourceRamp,0.,.1,0.,1.);
        targetColor=mix(black,color3,min(ramp,1.));
    }
    else if(sourceRamp<.45)
    {
        float ramp=map(sourceRamp,.1,.45,0.,1.);
        targetColor=mix(color3,color2,min(ramp,1.));
    }
    else
    {
        float ramp=map(sourceRamp,.45,1.,0.,1.);
        targetColor=mix(color2,color1,min(ramp,1.));
    }
    
    gl_FragColor=vec4(targetColor,.6);
}
