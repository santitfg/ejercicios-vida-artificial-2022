
PGraphics bufferDiff, frameAnterior, sumDiff, buffer;
PShader shaderDiff, shaderSum, shaderSumB; //prefiero procesar las imgs en GPU 
import processing.video.*;

Capture cam;

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

    // The camera can be initialized directly using an element
    // from the array returned by list():
    //cam = new Capture(this, cameras[0]);
    // Or, the settings can be defined based on the text in the list
    cam = new Capture(this, 640, 480);//, "Built-in iSight", 30);

    // Start capturing the images from the camera
    cam.start();
  }
  bufferDiff=createGraphics(cam.width, cam.height, P2D);
  shaderDiff= loadShader("shaderDiff.glsl");
  shaderSum=loadShader("shaderSum.glsl");
  shaderSumB=loadShader("shaderSum.glsl");
  frameAnterior=createGraphics(cam.width, cam.height, P2D);
  sumDiff=createGraphics(cam.width, cam.height, P2D);
  buffer=createGraphics(cam.width, cam.height, P2D);
}
int reads=0;
void draw() {

  //println(cam);
  //println(frameAnterior);
  if (cam.available()) {

    cam.read();

    shaderDiff.set("texCam", cam);
    shaderDiff.set("texFrameAnterior", frameAnterior);
    if (reads%2==0)
    {
      frameAnterior.beginDraw();
      frameAnterior.image(cam, 0, 0, cam.width, cam.height);
      frameAnterior.endDraw();
    }  

    //sumDiff
    bufferDiff.beginDraw();
    bufferDiff.filter(shaderDiff);  
    //bufferDiff.shader(shaderDiff);
    //bufferDiff.rect(0, 0, width, height);
    bufferDiff.endDraw();



    sumDiff.beginDraw();
    sumDiff.filter(shaderSum);
    sumDiff.endDraw();

    shaderSum.set("texture1", bufferDiff);
    shaderSumB.set("texture1", sumDiff);
    //shaderSumB.set("texture", buffer);

    buffer.beginDraw();
    buffer.filter(shaderSumB);
    buffer.endDraw();
    image(cam, 0, 0, width/2, height/2);
    image(buffer, width/2, 0, width/2, height/2);
    image(sumDiff, 0, height/2, width/2, height/2);
    image(bufferDiff, width/2, height/2, width/2, height/2);

    reads++;
  }


  // The following does the same as the above image() line, but 
  // is faster when just drawing the image without any additional 
  // resizing, transformations, or tint.
  //set(0, 0, cam);
}

void exit() {
  cam.stop();
}
