/**
 SHADERS CAMARA SUBTRACCION AC
 Creado:  2022/09/18
 Version: 1.0
 Autor:  Santiago Fernandez
 Contacto:  stfg.prof@gmail.com
 
 Descripcion: 
 
 conjunto de 5 shaders 
 3 para generar una substraccion de movimiento
 1 de automata celular reaccion diffusion
 1 un filtro de displace
 
 RoadMap:
 agregar archivo de configuracion 
 save de un XML con el estado (no sobrescrivbiendo la config)
 migrar a OF, estabilizar o remplazar los shaders de la substraccion
 pasar a una experimentacion con mas control ya no utilizar el operador laplaciano en 3 secciones (centro, adyacentes y diagonales )
 sino utilizar el modelo de rosa de los vientos teniendo 9 parametros a controlar
 mejorarla densidad 
 */
PGraphics bufferDiff, frameAnterior, sumDiff, bufferAc, bufferDisplace, buffer;
PShader shaderDiff, shaderSum, reactDiff, displace, shaderSumThresh; //prefiero procesar las imgs en GPU 
import processing.video.*;
import controlP5.*;

ControlP5 cp5;
Capture cam;
float thresh;
float filtroLineal, mult, multDisplace, div;
int reads=0, cantidadFrame;
float velocidad;
float ra;// rate of diffusion of A
float rb;// rate of diffusion of B
float feed;// feed rate
float kill;// kill rate
//convolution weights
float center;
float adj;
float diag;
float mixer;//,filtro;

void setup() {
  size(640, 480, P2D);
  //  size(1280, 960, P2D);
  cp5 = new ControlP5(this);
  cp5.addSlider("filtroLineal")
    .setPosition(20, 50)
    .setRange(0., 1.)
    .setValue(.93)
//.setValue(.84)
    ;
  cp5.addSlider("thresh")
    .setPosition(20, 75)
    .setRange(0., 1.)
    .setValue(0.03)
    ;
  cp5.addSlider("mult")
    .setPosition(20, 100)
    .setRange(0., 10.)
    .setValue(1.51)
    ;
  cp5.addSlider("multDisplace")
    .setPosition(20, 125)
    .setRange(0., 1.)
    .setValue(.07)
    ;
  cp5.addSlider("div")
    .setPosition(20, 150)
    .setRange(1., float(width))
    .setValue(200)
    ;
  //cp5.addSlider("cantidadFrame")
  //  .setPosition(20, 175)
  //  .setRange(0, 24)
  //  .setValue(2)
  //  ;
  cp5.addSlider("velocidad")
    .setPosition(20, 200)
    .setRange(0., 1.)
    .setValue(.45)//.69
    ; 
  cp5.addSlider("ra")
    .setPosition(20, 225)
    .setRange(0., 1.)
    .setValue(.79)
    ;
  cp5.addSlider("rb")
    .setPosition(20, 250)
    .setRange(0., 1.)
    .setValue(0.86)
    ;
  cp5.addSlider("feed")
    .setPosition(20, 275)
    .setRange(0., 1.)
    .setValue(.77)
    ;
  cp5.addSlider("kill")
    .setPosition(20, 300)
    .setRange(0., 1.)
    .setValue(.44)
    ;
  cp5.addSlider("center")
    .setPosition(20, 325)
    .setRange(-1., 1.)
    .setValue(.13)
    ;
  cp5.addSlider("adj")
    .setPosition(20, 350)
    .setRange(-1., 1.)
    .setValue(-.65)
    ; 
  cp5.addSlider("diag")
    .setPosition(20, 375)
    .setRange(-1., 1.)
    .setValue(0.71)//-51.
    ;
  cp5.addSlider("mixer")
    .setPosition(20, 400)
    .setRange(0., 1.)
    .setValue(.40)
    ;  
    //cp5.addSlider("filtro")
    //.setPosition(20, 425)
    //.setRange(0., 1.)
    //.setValue(.40)
    //;
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
  reactDiff=loadShader("rdiff_filtro_cam.glsl");  
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
    //  shaderDiff.set("texFrameAnterior", frameAnterior);
    //    shaderDiff.set("texFrameAnterior", bufferDiff); esto genera un feedback q ya no es subtraccion
    //sino feedback de una diferencia infinita. que alimenta de manera muy interesante a la reaccion
    reads++;
  }
  shaderDiff.set("texCam", cam);

  if (reads%2==0)
  {

    frameAnterior.beginDraw();
    frameAnterior.image(cam, 0, 0, cam.width, cam.height);
    frameAnterior.endDraw();
    //shaderDiff.set("texFrameAnterior", frameAnterior);
  }  
  bufferDiff.beginDraw();
  bufferDiff.filter(shaderDiff);  
  bufferDiff.endDraw();
  //shaderDiff.set("texFrameAnterior", bufferDiff);
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

  buffer.beginDraw();
  buffer.filter(shaderSumThresh);
  buffer.endDraw();


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
  reactDiff.set("mixer", mixer);
  reactDiff.set("texCam", buffer);
  reactDiff.set("div", div);
  //reactDiff.set("frame", frameCount);
  //reactDiff.set("cantidadFrame", cantidadFrame);

  bufferAc.beginDraw();
  bufferAc.filter(reactDiff);
  //bufferAc.background(0);
  //bufferAc.shader(reactDiff);
  //bufferAc.rect(0, 0, bufferAc.width, bufferAc.height);
  bufferAc.endDraw();

  displace.set("texB", cam);
  displace.set("texA", bufferAc);
  displace.set("mult", multDisplace);
  //displace.set("filtro", filtro);
  bufferDisplace.beginDraw();
  bufferDisplace.filter(displace);
  bufferDisplace.endDraw();

  image(bufferAc, 0, 0, width/2, height/2);
  //image(sumDiff, 0, height/2, width/2, height/2);
  image(buffer, width/2, 0, width/2, height/2);
  image(bufferDiff, width/2, height/2, width/2, height/2);
  //image(bufferDisplace, 0, 0, width, height);
    image(bufferDisplace, 0, height/2, width/2, height/2);


  //println(promedio(sumDiff));
  /*
 sumDiff.loadPixels();
   println(sumDiff.pixels.length);
   */

  // println(sumDiff.pixelHeight);



  // The following does the same as the above image() line, but 
  // is faster when just drawing the image without any additional 
  // resizing, transformations, or tint.
  //set(0, 0, cam);
}

void exit() {
  cam.stop();
}
