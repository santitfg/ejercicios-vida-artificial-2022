PGraphics bufferMain,bufferAC,bufferDisplace;

void setup(){
size(500,500,P2D);
bufferMain =createGraphics(500,500,P2D);
bufferAC =createGraphics(500,500,P2D);
bufferDisplace =createGraphics(500,500,P2D);
}

void draw() {
  bufferMain.beginDraw();
 // bufferMain.background(100);
  bufferMain.image(bufferMain, 0, 0,50*sin(millis()*0.01)+450,500);
  bufferMain.stroke(255);
  bufferMain.line(20, 20, mouseX, mouseY);
  bufferMain.endDraw();
  image(bufferMain, 0, 0); 
}
