

/** 
 MAE 2022 TP FINAL VIDA ARTIFICIAL (Emiliano Causa y Matías Romero Costas)
 
 Espejo transformante a base de diferencia de  movimiento utilizando algoritmos de Reacción Difusión y Displace.
 
 Creado:  2022/09/19
 Versión: 0.22
 Autor:  Santiago Fernández
 Contacto:  stfg.prof@gmail.com
 
 Descripción: 
 utilizando las facilides de processing para construir una interfaz grafica 
 y manipular buffers de imagen y shaders, el programa realiza una sustracción de movimiento con el método de diferencia absoluta entre dos imágenes
 y luego esta información es procesada para realizar una deformación en la imagen de la cámara.
 
 por comodidad dejo a la vista la interfaz grafica y con presionar una tecla se cambia el modo de ver los buffers y la imagen resultante.
 
 Funcionamiento:
 conjunto de 5 shaders en cascada, concatenando procesamiento en buffers 
 y luego bindiando la textura al siguiente shaders
 (utilizo los shaders como filtros en vez que como procesamiento de geometrías
 ya que no estoy generando la textura de un plano sino procesando imágenes).
 
 los tres primeros para generar una substraccion de movimiento
 el esquema general seria 
 Cámara [si le carga la imagen y sino hay frames carga la imagen anterior] (antes esto lo resolvía con un contador)
 >>
 buffer con un filtro de diferencia absoluta a una textura, en este caso a un buffer con el frame anterior de la cámara
 >>
 un buffer-filtro que suma y multiplica la imagen
 >>
 un buffer-filtro que amortigua la imagen linealmente y le agrega un threshhold
 >>
 un buffer filtro con la formula de  Karl Sims (https://www.karlsims.com/rd.html) 
 estudiada a partir de Simon Alexander-Adams (https://www.simonaa.media/tutorials/complex-systems-workshop) 
 y sol Sarratea (https://visualizer.solsarratea.world/04-gray-scott/) (https://github.com/solsarratea)
 >>
 y por ultimo un filtro de displace sobre la captura de la imagen en base al Autómata Celular (solo por comodidad puesto dentro de un buffer)
 
 
 RoadMap:
 agregar archivo de configuración 
 save de un XML con el estado (no sobrescribiendo la config)
 migrar a OF, estabilizar o remplazar los shaders de la sustracción
 pasar a una experimentación con mas control ya no utilizar el operador laplaciano en 3 secciones (centro, adyacentes y diagonales )
 sino utilizar el modelo de rosa de los vientos teniendo 9 parámetros a controlar
 añadir un seteo de tamaño del AC en pixeles al shader
 agregar dos shaders y buffers para hacer un desplazamiento recursivo y coloreado
 PD:
 Discupen si los shaders no estan comentados y algo desprolijos (a esta altura del año el tiempo escasea).
 */

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////VARIABLES GLOBALES//////////VARIABLES GLOBALES//////////VARIABLES GLOBALES//////////VARIABLES GLOBALES/////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

PGraphics bufferDiff, frameAnterior, sumDiff, bufferAc, bufferDisplace, buffer;
PShader shaderDiff, shaderSum, reactDiff, displace, shaderSumThresh; //prefiero procesar las imgs en GPU 
import processing.video.*;
import controlP5.*;

ControlP5 cp5;
Capture cam;
float thresh;
float filtroLineal, mult, multDisplace, div;
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
boolean verRegiones;

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////SETUP//////////SETUP//////////SETUP//////////SETUP//////////SETUP//////////SETUP//////////SETUP//////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
void setup() {
  //size(640, 480, P2D);
  size(1280, 960, P2D);


  //INTERFAZ GRAFICA
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
    .setValue(float(width))
    ;

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


  verRegiones=false;


  //INICIALIZACION DE CAMARA
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

  //CARGA DE SHADERS 
  shaderDiff= loadShader("shaderDiff.glsl");
  shaderSum=loadShader("shaderSum.glsl");  
  reactDiff=loadShader("rdiff_filtro_cam.glsl");  
  displace=loadShader("displace.glsl");  
  shaderSumThresh=loadShader("shaderSumThresh.glsl");

  //INICIALIZACION DE BUFFERS (PGRAPHICS)
  frameAnterior=createGraphics(cam.width, cam.height, P2D);
  bufferDiff=createGraphics(cam.width, cam.height, P2D);
  sumDiff=createGraphics(cam.width, cam.height, P2D);
  bufferAc=createGraphics(cam.width, cam.height, P2D);
  bufferDisplace=createGraphics(cam.width, cam.height, P2D);
  buffer=createGraphics(cam.width, cam.height, P2D);


  //evito que el frameAnterior este vacio en el primer bucle, y no ingrese en el shader sin pixeles 
  frameAnterior.beginDraw();
  frameAnterior.rect(0, 0, cam.width, cam.height);
  frameAnterior.endDraw();
}

void draw() {

  if (cam.available()) {
    cam.read();
    //shaderDiff.set("texFrameAnterior", frameAnterior);
    //shaderDiff.set("texFrameAnterior", bufferDiff); esto genera un feedback q ya no es subtraccion
    //sino feedback de una diferencia infinita. que alimenta de manera muy interesante a la reaccion
    shaderDiff.set("texCam", cam);
  } else {

    frameAnterior.beginDraw();
    frameAnterior.image(cam, 0, 0, cam.width, cam.height);
    frameAnterior.endDraw();
  }
  shaderDiff.set("texFrameAnterior", frameAnterior);

  bufferDiff.beginDraw();
  bufferDiff.filter(shaderDiff);  
  bufferDiff.endDraw();

  bufferDiff.beginDraw();
  bufferDiff.filter(shaderDiff);  
  bufferDiff.endDraw();

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


  reactDiff.set("u_resolution", float(cam.width), float(cam.height));
  //  reactDiff.set("reset", keyPressed);
  //reactDiff.set("u_time", float(millis()));
  //float x = map(mouseX, 0, width, 0, 1);
  //float y = map(mouseY, 0, height, 1, 0);
  //reactDiff.set("u_mouse", x, y);
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


  bufferAc.beginDraw();
  bufferAc.filter(reactDiff);

  bufferAc.endDraw();

  displace.set("texB", cam);
  displace.set("texA", bufferAc);
  displace.set("mult", multDisplace);

  bufferDisplace.beginDraw();
  bufferDisplace.filter(displace);
  bufferDisplace.endDraw();


  if (verRegiones) {
    image(bufferAc, 0, 0, width/2, height/2);
    image(sumDiff, 0, height/2, width/2, height/2);
    image(buffer, width/2, 0, width/2, height/2);
    image(bufferDiff, width/2, height/2, width/2, height/2);
    //image(bufferDisplace, 0, height/2, width/2, height/2);
  } else {
    image(bufferDisplace, 0, 0, width, height);
  }
}
void keyPressed() {
  verRegiones=!verRegiones;
}
void exit() {
  cam.stop();
}
