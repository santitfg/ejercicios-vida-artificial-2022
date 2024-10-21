
PGraphics bufferDiff, frameAnterior, sumDiff, bufferBlur;
PShader shaderDiff, shaderSum, blur; //prefiero procesar las imgs en GPU 
import processing.video.*;
import controlP5.*;

ControlP5 cp5;
Capture cam;
float filtroLineal, mult;
int reads=0;

void setup() {
  size(640, 480, P2D);
  cp5 = new ControlP5(this);
  cp5.addSlider("filtroLineal")
    .setPosition(20, 50)
    .setRange(0., 1.)
    .setValue(.75)
    ;

  cp5.addSlider("mult")
    .setPosition(20, 75)
    .setRange(0., 10.)
    .setValue(5.)

    ;
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

  shaderDiff= loadShader("shaderDiff.glsl");
  shaderSum=loadShader("shaderSum.glsl");  
  blur=loadShader("blur 3X3.glsl");  

  blur.set("u_resolution", cam.width, cam.height);

  frameAnterior=createGraphics(cam.width, cam.height, P2D);
  bufferDiff=createGraphics(cam.width, cam.height, P2D);
  sumDiff=createGraphics(cam.width, cam.height, P2D);
  bufferBlur=createGraphics(cam.width, cam.height, P2D);
}

void draw() {

  //println(cam);
  //println(frameAnterior);
  if (cam.available()) {
    cam.read();
    shaderDiff.set("texFrameAnterior", frameAnterior);
  }
  shaderDiff.set("texCam", cam);

  if (reads%2==0)
  {

    frameAnterior.beginDraw();
    frameAnterior.image(cam, 0, 0, cam.width, cam.height);
    frameAnterior.endDraw();
  }  

  bufferDiff.beginDraw();
  bufferDiff.filter(shaderDiff);  
  bufferDiff.endDraw();



  shaderSum.set("texture1", bufferDiff);
  shaderSum.set("f", filtroLineal);
  shaderSum.set("mult", mult);

  sumDiff.beginDraw();
  sumDiff.filter(shaderSum);
  sumDiff.endDraw();

  bufferBlur.beginDraw();
  bufferBlur.image(sumDiff,0,0,cam.width, cam.height);

  bufferBlur.filter(blur);
  bufferBlur.endDraw();

  image(cam, 0, 0, width/2, height/2);
  image(sumDiff, 0, height/2, width/2, height/2);
  image(bufferDiff, width/2, height/2, width/2, height/2);
  image(bufferBlur, width/2, 0, width/2, height/2);


  reads++;



  // The following does the same as the above image() line, but 
  // is faster when just drawing the image without any additional 
  // resizing, transformations, or tint.
  //set(0, 0, cam);
}

void exit() {
  cam.stop();
}
