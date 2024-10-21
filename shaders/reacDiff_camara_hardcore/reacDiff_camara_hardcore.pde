
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
PShader reactDiff;

float velocidad;

float ra;// rate of diffusion of A
float rb;// rate of diffusion of B
float feed;// feed rate
float kill;// kill rate
//convolution weights
float center;
float ss, nn, oo, ee, se, so, no, ne;
float div;
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


  //reactDiff=loadShader("clickTest.glsl");
  //reactDiff=loadShader("rdiff.glsl");
  reactDiff=loadShader("rdiff_filtro_cam hardcore.glsl");  
  //reactDiff=loadShader("rdiff_col.glsl");  
  bufferReactDiff=createGraphics(width, height, P2D);




  //  size(1280, 960, P2D);
  cp5 = new ControlP5(this);
  cp5.addSlider("velocidad")
    .setPosition(20, 25)
    .setRange(0., 1.)
    .setValue(.19)
    ; 
  cp5.addSlider("ra")
    .setPosition(20, 50)
    .setRange(0., 1.)
    .setValue(1.)
    ;
  cp5.addSlider("rb")
    .setPosition(20, 75)
    .setRange(0., 1.)
    .setValue(0.327)
    ;
  cp5.addSlider("feed")
    .setPosition(20, 100)
    .setRange(0., 1.)
    .setValue(.028)
    ;
  cp5.addSlider("kill")
    .setPosition(20, 125)
    .setRange(0., 1.)
    .setValue(.064)
    ;
  cp5.addSlider("center")
    .setPosition(20, 150)
    .setRange(-1., 1.)
    .setValue(-1.)
    ;
  cp5.addSlider("ss")
    .setPosition(20, 175)
    .setRange(-1., 1.)
    .setValue(.198)
    ;   
  cp5.addSlider("nn")
    .setPosition(20, 200)
    .setRange(-1., 1.)
    .setValue(.198)
    ;   
  cp5.addSlider("oo")
    .setPosition(20, 225)
    .setRange(-1., 1.)
    .setValue(.198)
    ;   
  cp5.addSlider("ee")
    .setPosition(20, 250)
    .setRange(-1., 1.)
    .setValue(.198)
    ; 

  cp5.addSlider("se")
    .setPosition(20, 275)
    .setRange(-1., 1.)
    .setValue(0.053)
    ;
  cp5.addSlider("so")
    .setPosition(20, 300)
    .setRange(-1., 1.)
    .setValue(0.053)
    ;
  cp5.addSlider("no")
    .setPosition(20, 325)
    .setRange(-1., 1.)
    .setValue(0.053)
    ;
  cp5.addSlider("ne")
    .setPosition(20, 350)
    .setRange(-1., 1.)
    .setValue(0.053)
    ;
  cp5.addSlider("div")
    .setPosition(20, 375)
    .setRange(1., float(cam.width))
    .setValue(225.)
    ;
}


void draw() {
  if (cam.available()) {
    cam.read();
  }
  reactDiff.set("texCam", cam);


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
  reactDiff.set("ss", ss);  
  reactDiff.set("nn", nn);  
  reactDiff.set("oo", oo);  
  reactDiff.set("ee", ee);  
  reactDiff.set("se", se);  
  reactDiff.set("so", so);  
  reactDiff.set("no", no);  
  reactDiff.set("ne", ne);  
  bufferReactDiff.beginDraw();
  bufferReactDiff.filter(reactDiff);
  //bufferReactDiff.shader(reactDiff);
  //bufferReactDiff.rect(0, 0, bufferReactDiff.width, bufferReactDiff.height);
  bufferReactDiff.endDraw();
  image(bufferReactDiff, 0, 0);
}

void exit() {
  cam.stop();
}
