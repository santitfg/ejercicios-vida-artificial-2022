
PGraphics bufferDiff, frameAnterior, sumDiff, buffer, bufferDisplace;
PShader shaderDiff, shaderSum, shaderSumThresh, shaderDisplace; //prefiero procesar las imgs en GPU 
import processing.video.*;
import controlP5.*;

ControlP5 cp5;
Slider2D s;

Capture cam;
float filtroLineal;
float thresh;
float multDiff;
float displace;
float blend, multNoise, scale;
;
void setup() {
  size(640, 480, P2D);
  cp5 = new ControlP5(this);

  cp5.addSlider("multDiff")
    .setPosition(20, 25)
    .setRange(0., 5.)
    .setValue(1.5)
    ;
  cp5.addSlider("filtroLineal")
    .setPosition(20, 50)
    .setRange(0., 1.)
    .setValue(.97)

    ;
  cp5.addSlider("thresh")
    .setPosition(20, 75)
    .setRange(0., 1.)
    .setValue(0.02)
    ;

  cp5.addSlider("displace")
    .setPosition(20, 100)
    .setRange(0., .40)
    .setValue(.02)
    ;
  cp5.addSlider("blend")
    .setPosition(20, 125)
    .setRange(0., 1.)
    .setValue(.11)
    ;
  cp5.addSlider("multNoise")
    .setPosition(20, 150)
    .setRange(0., 0.5)
    .setValue(.04)
    ;
  cp5.addSlider("scale")
    .setPosition(20, 175)  
    .setRange(0., 25.)
    .setValue(3.78)
    ;
  s= cp5.addSlider2D("mult_T")
    .setPosition(20, 200)
    .setSize(100, 100)
    .setMinMax(0, 0,1000, 1000)
    .setValue(10, 1)
//    .disableCrosshair()
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

    // The camera can be initialized directly using an element
    // from the array returned by list():
    //cam = new Capture(this, cameras[0]);
    // Or, the settings can be defined based on the text in the list
    cam = new Capture(this, 640, 480);//, "Built-in iSight", 30);

    // Start capturing the images from the camera
    cam.start();
  }
  bufferDiff=createGraphics(cam.width, cam.height, P2D);

  frameAnterior=createGraphics(cam.width, cam.height, P2D);
  sumDiff=createGraphics(cam.width, cam.height, P2D);
  buffer=createGraphics(cam.width, cam.height, P2D);
  bufferDisplace=createGraphics(cam.width, cam.height, P2D);

  shaderDiff= loadShader("shaderDiff.glsl");
  shaderSum=loadShader("shaderSum.glsl");
  shaderSumThresh=loadShader("shaderSumThresh.glsl");
  shaderDisplace=loadShader("displaceRecursivo.glsl");//displace.glsl");
  //shaderDisplace=loadShader("displaceBlend.glsl");//displace.glsl");
}
int reads=0;
void draw() {
  float time= millis();
  //println(cam);
  //println(frameAnterior);
  if (cam.available()) {

    cam.read();
    reads++;

  }
    shaderDiff.set("texCam", cam);
    shaderDiff.set("multDiff", multDiff);//0.9);

    if (reads%2==0) //en teoria tendria que por usarlo sin un interruptor pero en processing si fijo al final el frame no tengo lecturas
    {
      frameAnterior.beginDraw();
      frameAnterior.image(cam, 0, 0, cam.width, cam.height);
      frameAnterior.endDraw();
    }  
    
    shaderDiff.set("texFrameAnterior", frameAnterior);
    shaderDisplace.set("mult", displace);//0.9);
    shaderDisplace.set("blend", blend);//0.9);
    shaderDisplace.set("texA", cam);//0.9);sumDiff
    // shaderDisplace.set("texB", cam);//0.9);
    shaderDisplace.set("multNoise", multNoise);//0.9);
    shaderDisplace.set("scale", scale);//0.9);
    shaderDisplace.set("u_time", time);//0.9);
    shaderDisplace.set("t_noise",s.getArrayValue()[0]/10000.,s.getArrayValue()[1]/10000.);

    bufferDiff.beginDraw();
    bufferDiff.filter(shaderDiff);  
    //bufferDiff.shader(shaderDiff);
    //bufferDiff.rect(0, 0, width, height);
    bufferDiff.endDraw();



    sumDiff.beginDraw();
    sumDiff.filter(shaderSum);
    sumDiff.endDraw();

    shaderSum.set("texture1", bufferDiff);
    shaderSumThresh.set("texture1", sumDiff);
    shaderSumThresh.set("f", filtroLineal);//0.9);
    shaderSumThresh.set("thresh", thresh);//0.9);

    buffer.beginDraw();
    buffer.filter(shaderSumThresh);
    buffer.endDraw();

    bufferDisplace.beginDraw();
    bufferDisplace.filter(shaderDisplace);
    bufferDisplace.endDraw();

    image(cam, 0, 0, width/2, height/2);
    image(buffer, width/2, 0, width/2, height/2);
    image(sumDiff, 0, height/2, width/2, height/2);
    //image(bufferDiff, width/2, height/2, width/2, height/2);
    image(bufferDisplace, width/2, height/2, width/2, height/2);

  


  // The following does the same as the above image() line, but 
  // is faster when just drawing the image without any additional 
  // resizing, transformations, or tint.
  //set(0, 0, cam);
}

void exit() {
  cam.stop();
}
void mousePressed()
{
  if (mouseX>=width/2&&mouseY>=height/2&&mouseX<=width&&mouseY<=height)
  {
    String date=String.valueOf(year())+"_"+String.valueOf(month())+"_"+String.valueOf(day())+"_"+String.valueOf(millis());
    /*

     millis();
     second();
     minute();
     hour();
     month();
     year();
     String.valueOf();*/
    buffer.save("/out/"+date+".jpg");
  }
}
