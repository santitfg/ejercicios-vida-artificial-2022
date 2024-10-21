PGraphics bufferMain, bufferAC, bufferDisplace;
PShader displace;  
PImage imagen;

void setup() {
  size(1000, 500, P2D);
    imagen = loadImage("imagen.jpg");


  bufferMain =createGraphics(500, 500, P2D);
  bufferAC =createGraphics(500, 500, P2D);
  bufferDisplace =createGraphics(500, 500, P2D);


  displace = loadShader("displace.frag");
  displace.set("u_resolution", float(bufferDisplace.width), float(bufferDisplace.height));
  displace.set("u_tex0", bufferDisplace);
  displace.set("u_tex0Resolution", float(bufferDisplace.width), float(bufferDisplace.height));
}

void draw() {
  bufferMain.beginDraw();
  bufferMain.background(0);
  //bufferMain.image(bufferMain, 0., 0.001, 500, 500);
  bufferMain.noStroke();
  bufferMain.colorMode(HSB, 1., 1., 1.);
  bufferMain.fill(sin(millis()*0.001)*0.5+0.5, sin(millis()*0.005)*0.25+0.75, sin(millis()*0.005)*0.25+0.75);
  bufferMain.circle(noise(millis()*0.001)*500, noise(millis()*0.001+100)*250+250, 100);
  bufferMain.endDraw();

  bufferAC.beginDraw();
      bufferAC.background(255);

  bufferAC.colorMode(HSB, 1., 1., 1.);
  bufferAC.fill(0.7,1,1);

//  bufferAC.fill(sin(millis()*0.001)*0.5+0.5, sin(millis()*0.005)*0.25+0.75, sin(millis()*0.005)*0.25+0.75);
  bufferAC.rectMode(CENTER);
//  bufferAC.rect(bufferAC.width/2, bufferAC.height/2, bufferAC.width/2, bufferAC.height/2);
    bufferAC.image(imagen, 0, 0);

  bufferAC.endDraw();

  displace.set("u_time", float(millis()) / 1000.0);
  displace.set("cant", .025);//float(mouseX)/float(width));
  displace.set("u_mouse", float(mouseX), float(mouseY));//valor entre 0. y 1.0
  displace.set("u_tex0", bufferMain);
  displace.set("u_tex1", bufferAC);

  bufferDisplace.beginDraw();
    bufferDisplace.background(0);

  bufferDisplace.rect(0, 0, bufferDisplace.width, bufferDisplace.height);
  bufferDisplace.shader(displace);
  bufferDisplace.endDraw();

  image(bufferMain, 0, 0);
  image(bufferDisplace, 500, 0);
}
