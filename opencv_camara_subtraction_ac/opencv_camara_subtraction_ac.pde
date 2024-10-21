/**
 OPENCV CAMARA SUBTRACCION AC
 Creado:  2022/09/18
 Version: 1.0
 Autor:  Santiago Fernandez
 Contacto:  stfg.prof@gmail.com
 
 Descripcion: 
 Ejemplo de Acutomata Celular Y openCV
 este mismo es descartado ya que el uso de opencv en processing(java)
 no es muy optimo, ver ejemplo contruir a base de shaders, 
 si bien tiene algunos defrectos, es verboso y requiere amortiguacion para su uso practico
 lo mas importante no dropea frames y facimente se le pueden añadir los filtros de erode y dilate  
 **/

PGraphics  bufferAc, bufferDisplace;
PShader  ac, displace; 
import gab.opencv.*;
import processing.video.*;
import controlP5.*;

OpenCV opencv;
ControlP5 cp5;
Capture cam;
float thresh;
float filtroLineal, mult, multDisplace, div;
int reads=0;
PImage temp;

void setup() {
  size(640, 480, P2D);
  //  size(1280, 960, P2D);
  cp5 = new ControlP5(this);

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


  ac=loadShader("ac.glsl");  
  displace=loadShader("displace.glsl");  


  bufferAc=createGraphics(cam.width, cam.height, P2D);
  bufferDisplace=createGraphics(cam.width, cam.height, P2D);
  opencv = new OpenCV(this, cam.width, cam.height);
  opencv.startBackgroundSubtraction(5, 3, 0.5);//que son esos parametros?
}

void draw() {

  if (cam.available()) {
    cam.read();
  }

  temp=opencv.getOutput();

  ac.set("u_resolution", float(bufferAc.width), float(bufferAc.height));
  ac.set("camara", temp);
  ac.set("div", div);

  opencv.loadImage(cam);
  opencv.updateBackground();

  //opencv.dilate();
  //opencv.erode();


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
  image(temp, 0, height/2, width/2, height/2);
  image(bufferDisplace, 0, 0, width, height);
}

void exit() {
  cam.stop();
}
