
/**
 SHADERS CAMARA SUBTRACCION AC
 Creado:  2022/09/18
 Version: 1.0
 Autor:  Santiago Fernandez
 Contacto:  stfg.prof@gmail.com
 
 Descripcion: 
 */
import processing.video.*;
import controlP5.*;
ControlP5 cp5;
Capture cam;

PGraphics bufferReactDiff;
PShader reactDiff, bn;
PGraphics bufferDiff, frameAnterior, sumDiff, bufferAc, bufferDisplace, bufferThresh;
PShader shaderDiff, shaderSum, ac, displace, shaderSumThresh; //prefiero procesar las imgs en GPU 

float velocidad;
float ra;// rate of diffusion of A
float rb;// rate of diffusion of B
float feed;// feed rate
float kill;// kill rate
//convolution weights
float center;
float adj;
float diag;
float div;

float thresh;
float filtroLineal, mult, multDisplace;
int reads=0;
//mouseClicked()
void setup() {
  size(640, 480, P2D);

  String[] cameras = Capture.list();

  if (cameras == null) {
    println("Failed to retrieve the list of available cameras, will try the default...");
    cam = new Capture(this, 640, 480);
  } else if (cameras.length == 0) {
    println("There are no cameras available for capture.");
    exit();
  } else {
    println("Available cameras:");
    printArray(cameras);
    cam = new Capture(this, 640, 480);//, "Built-in iSight", 30);
    cam.start();
  }


  bn=loadShader("toBN.glsl");
  reactDiff=loadShader("rdiff_filtro_cam.glsl");  

  shaderDiff= loadShader("shaderDiff.glsl");
  shaderSum=loadShader("shaderSum.glsl");  
  shaderSumThresh=loadShader("shaderSumThresh.glsl");

  bufferReactDiff=createGraphics(cam.width, cam.height, P2D);


  //displace=loadShader("displace.glsl");  

  frameAnterior=createGraphics(cam.width, cam.height, P2D);
  bufferDiff=createGraphics(cam.width, cam.height, P2D);
  sumDiff=createGraphics(cam.width, cam.height, P2D);
  bufferThresh=createGraphics(cam.width, cam.height, P2D);

  //bufferAc=createGraphics(cam.width, cam.height, P2D);
  //bufferDisplace=createGraphics(cam.width, cam.height, P2D);

  //  size(1280, 960, P2D);
  cp5 = new ControlP5(this);
  cp5.addSlider("velocidad")
    .setPosition(20, 25)
    .setRange(0., 1.)
    .setValue(.83)
    ; 
  cp5.addSlider("ra")
    .setPosition(20, 50)
    .setRange(0., 1.)
    .setValue(1.)
    ;
  cp5.addSlider("rb")
    .setPosition(20, 75)
    .setRange(0., 1.)
    .setValue(0.99)
    ;
  cp5.addSlider("feed")
    .setPosition(20, 100)
    .setRange(0., 1.)
    .setValue(.32)
    ;
  cp5.addSlider("kill")
    .setPosition(20, 125)
    .setRange(0., 1.)
    .setValue(.87)
    ;
  cp5.addSlider("center")
    .setPosition(20, 150)
    .setRange(-1., 1.)
    .setValue(-.89)
    ;
  cp5.addSlider("adj")
    .setPosition(20, 175)
    .setRange(-1., 1.)
    .setValue(.99)
    ; 
  cp5.addSlider("diag")
    .setPosition(20, 200)
    .setRange(-1., 1.)
    .setValue(-0.53)
    ;
  cp5.addSlider("div")
    .setPosition(20, 225)
    .setRange(1., float(cam.width))
    .setValue(float(cam.width))
    ;
  cp5.addSlider("mult")
    .setPosition(20, 250)
    .setRange(0., 10.)
    .setValue(5.8)
    ;
  cp5.addSlider("thresh")
    .setPosition(20, 275)
    .setRange(0., 1.)
    .setValue(0.03)
    ;
  cp5.addSlider("filtroLineal")
    .setPosition(20, 300)
    .setRange(0., 1.)
    .setValue(.9)
    ;
}


void draw() {
  if (cam.available()) {
    cam.read();
  }


  //if (reads%2==0)
  //{

  //  frameAnterior.beginDraw();
  //  frameAnterior.image(cam, 0, 0, cam.width-50, cam.height-50);
  //  frameAnterior.filter(ERODE);
  //  frameAnterior.filter(DILATE);
  //  frameAnterior.endDraw();
  //}  

  shaderDiff.set("texCam", cam);

  bufferDiff.beginDraw();
  bufferDiff.filter(shaderDiff);  
  bufferDiff.endDraw();

  frameAnterior.beginDraw();
  frameAnterior.image(bufferDiff, 0, 0, cam.width, cam.height);
  //frameAnterior.filter(ERODE);
  //frameAnterior.filter(BLUR, 6);
  //frameAnterior.filter(DILATE);
  frameAnterior.endDraw();
  shaderDiff.set("texFrameAnterior", frameAnterior);

  shaderSum.set("texture1", bufferDiff);
  shaderSum.set("f", filtroLineal);
  shaderSum.set("mult", mult);

  sumDiff.beginDraw();
  sumDiff.filter(shaderSum);
  sumDiff.endDraw();


  shaderSumThresh.set("texture1", sumDiff);
  shaderSumThresh.set("f", filtroLineal);//0.9);
  shaderSumThresh.set("thresh", thresh);//0.9);

  bufferThresh.beginDraw();
  bufferThresh.filter(shaderSumThresh);
  bufferThresh.endDraw();


  reactDiff.set("texCam", bufferThresh);
  reactDiff.set("div", div);
  reactDiff.set("reset", keyPressed);
  reactDiff.set("u_resolution", float(width), float(height));
  reactDiff.set("u_time", float(millis()));
  float x = map(mouseX, 0, width, 0, 1);
  float y = map(mouseY, 0, height, 1, 0);
  reactDiff.set("u_mouse", x, y);
  reactDiff.set("velocidad", velocidad);

  reactDiff.set("ra", ra);
  reactDiff.set("rb", rb);
  reactDiff.set("feed", feed);
  reactDiff.set("kill", kill); 

  reactDiff.set("center", center);
  reactDiff.set("adj", adj);  
  reactDiff.set("diag", diag);

  bufferReactDiff.beginDraw();
  bufferReactDiff.filter(reactDiff);
  //bufferReactDiff.shader(reactDiff);
  //bufferReactDiff.rect(0, 0, bufferReactDiff.width, bufferReactDiff.height);
  bufferReactDiff.endDraw();
  image(bufferReactDiff, 0, 0, width/2, height/2);
  image(sumDiff, 0, height/2, width/2, height/2);
  image(bufferThresh, width/2, 0, width/2, height/2);
  image(bufferDiff, width/2, height/2, width/2, height/2);
  //filter(bn);
}

void exit() {
  cam.stop();
}
