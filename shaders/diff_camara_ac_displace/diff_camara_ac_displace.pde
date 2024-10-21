
PGraphics bufferDiff, frameAnterior, sumDiff, bufferAc, bufferDisplace, buffer;
PShader shaderDiff, shaderSum, ac, displace, shaderSumThresh; //prefiero procesar las imgs en GPU 
import processing.video.*;
import controlP5.*;

ControlP5 cp5;
Capture cam;
float thresh;
float filtroLineal, mult, multDisplace, div;
int reads=0;

void setup() {
  size(640, 480, P2D);
  //  size(1280, 960, P2D);
  cp5 = new ControlP5(this);
  cp5.addSlider("filtroLineal")
    .setPosition(20, 50)
    .setRange(0., 1.)
    .setValue(.9)
    ;
  cp5.addSlider("thresh")
    .setPosition(20, 75)
    .setRange(0., 1.)
    .setValue(0.03)
    ;
  cp5.addSlider("mult")
    .setPosition(20, 100)
    .setRange(0., 10.)
    .setValue(5.8)
    ;
  cp5.addSlider("multDisplace")
    .setPosition(20, 125)
    .setRange(0., 1.)
    .setValue(.2)
    ;
  cp5.addSlider("div")
    .setPosition(20, 150)
    .setRange(1., float(width))
    .setValue(200)
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
  ac=loadShader("ac.glsl");  
  displace=loadShader("displace.glsl");  

  frameAnterior=createGraphics(cam.width, cam.height, P2D);
  bufferDiff=createGraphics(cam.width, cam.height, P2D);
  sumDiff=createGraphics(cam.width, cam.height, P2D);
  bufferAc=createGraphics(cam.width, cam.height, P2D);
  bufferDisplace=createGraphics(cam.width, cam.height, P2D);

  buffer=createGraphics(cam.width, cam.height, P2D);

  shaderSumThresh=loadShader("shaderSumThresh.glsl");
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

  shaderSumThresh.set("texture1", sumDiff);
  shaderSumThresh.set("f", filtroLineal);//0.9);
  shaderSumThresh.set("thresh", thresh);//0.9);

  buffer.beginDraw();
  buffer.filter(shaderSumThresh);
  buffer.endDraw();

  ac.set("u_resolution", float(bufferAc.width), float(bufferAc.height));
  ac.set("camara", buffer);
  ac.set("div", div);

  bufferAc.beginDraw();
  bufferAc.background(0);
  bufferAc.shader(ac);
  bufferAc.rect(0, 0, bufferAc.width, bufferAc.height);
  bufferAc.endDraw();

  displace.set("texB", cam);
  displace.set("texA", bufferAc);
  displace.set("mult", multDisplace);
  bufferDisplace.beginDraw();
  bufferDisplace.filter(displace);
  bufferDisplace.endDraw();

  image(bufferAc, 0, 0, width/2, height/2);
  image(sumDiff, 0, height/2, width/2, height/2);
  image(buffer, width/2, 0, width/2, height/2);
  image(bufferDiff, width/2, height/2, width/2, height/2);
  //image(bufferDisplace, 0, 0, width, height);

  //println(promedio(sumDiff));
  /*
 sumDiff.loadPixels();
   println(sumDiff.pixels.length);
   */

  // println(sumDiff.pixelHeight);
  reads++;



  // The following does the same as the above image() line, but 
  // is faster when just drawing the image without any additional 
  // resizing, transformations, or tint.
  //set(0, 0, cam);
}

void exit() {
  cam.stop();
}
