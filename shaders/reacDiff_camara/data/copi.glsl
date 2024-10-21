/* Gray Scott Reaction Diffusion

(c) 2019 Simon Alexander-Adams - https://www.simonaa.media
MIT License

Reference Materials:
Karl Sims: http://karlsims.com/rd.html
Daniel Shiffman: https://www.youtube.com/watch?v=BV9ny785UNc
Algosome: https://www.algosome.com/articles/reaction-diffusion-gray-scott.html
RDiffusion Cinder Example: https://github.com/cinder/Cinder/tree/master/samples/RDiffusion
*/

uniform vec2 res;

uniform float ra;// rate of diffusion of A
uniform float rb;// rate of diffusion of B
uniform float feed;// feed rate
uniform float kill;// kill rate

//convolution weights
uniform float center;
uniform float adj;
uniform float diag;

//time
uniform float time;

out vec4 FragColor;

vec2 get(float x,float y){
    vec2 uv=vUV.st+vec2(x,y);
    return texture(sTD2DInputs[0],uv).rg;
}

void main(void)
{
    
    //change in x and y for computing laplacian
    float dx=1./res.x;
    float dy=1./res.y;
    
    vec2 c=texture(sTD2DInputs[0],vUV.st).rg;//sample pixel value
    float a=c.r;//component A
    float b=c.g;//component B
    
    //apply convolution (laplacian)
    vec2 l
    =(get(-dx,-dy)+get(dx,-dy)+get(dx,dy)+get(-dx,dy))*diag
    +(get(-dx,0.)+get(dx,0.)+get(0.,dy)+get(0.,-dy))*adj
    +c*center;
    
    //feed and kill rates:
    float f=texture(sTD2DInputs[1],vUV.st).r+feed;
    float k=texture(sTD2DInputs[1],vUV.st).g+kill;
    
    // Gray-Scott equation
    float da=ra*l.r-(a*b*b)+f*(1.-a);
    float db=rb*l.g+(a*b*b)-(k+f)*b;
    
    //"time" controls global rate of change
    a+=da*time;
    b+=db*time;
    
    //clamp and output components a and b
    FragColor=vec4(clamp(a,0.,1.),clamp(b,0.,1.),0.,1.);
    
}

