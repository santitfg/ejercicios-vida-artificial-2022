
PGraphics bufferDiff;
PShader shaderDiff; //prefiero procesar las imgs en GPU 

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
}

void draw() {
  if (cam.available() == true) {
    cam.read();
    shaderDiff.set("texCam", cam);
  }
  bufferDiff.beginDraw();
  bufferDiff.filter(shaderDiff);  
  bufferDiff.endDraw();
  image(bufferDiff, 0, 0, width, height);
  // The following does the same as the above image() line, but 
  // is faster when just drawing the image without any additional 
  // resizing, transformations, or tint.
  //set(0, 0, cam);
}

void exit(){
 cam.stop();

}
