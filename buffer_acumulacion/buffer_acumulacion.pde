PGraphics bufferMain;

void setup() {
  size(1000, 500, P2D);
  bufferMain =createGraphics(500, 500, P2D);


}

void draw() {
  bufferMain.beginDraw();
  // bufferMain.background(100);
  bufferMain.image(bufferMain, 0., 0.001, 500, 500);
  
  bufferMain.noStroke();
  bufferMain.colorMode(HSB, 1., 1., 1.);

  bufferMain.fill(sin(millis()*0.001)*0.5+0.5,
                  sin(millis()*0.005)*0.25+0.75,
                  sin(millis()*0.005)*0.25+0.75);

  bufferMain.circle(noise(millis()*0.001)*250+250, 
                    noise(millis()*0.001+100)*250+250,
                    20);
  
  bufferMain.endDraw();
  
  
  image(bufferMain, 0, 0);
}
