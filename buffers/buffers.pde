PGraphics bufferMain;

void setup(){
size(1000,500,P2D);
bufferMain =createGraphics(500,500,P2D);
}

void draw() {
  bufferMain.beginDraw();
  bufferMain.background(100);
  bufferMain.stroke(255);
  bufferMain.line(20, 20, mouseX, mouseY);
  bufferMain.endDraw();
  image(bufferMain, 0, 0,width/2,height); 
  image(bufferMain, width/2, 0,width/2,height);
}
