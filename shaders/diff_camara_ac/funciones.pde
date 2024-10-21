


long[] promedio() {
  long[]rgb={0, 0, 0};
  // color promedio de la mitad de arriba de pantalla usando el largo del array/2 de la imagen
  loadPixels(); //cargamos todos los pixeles del video, ya que es un array con pixels.length
  for (int i = 0; i < pixels.length; i++) { //recorremos el array desde el px 0 a la mitad de pantalla, 102400px
    color argb = pixels[i];
    //a += (argb >> 24) & 0xFF; //a es para alfa, que no uso.
    rgb[0] += (argb >> 16) & 0xFF;  // (right shift) la forma mas rápida de obtener los colores red(argb) //>>  El número a la izquierda del operador se desplaza el número de lugares especificado por el número a la derecha.
    rgb[1] += (argb >> 8) & 0xFF;   //  & 0xFF se usa en java para 0x indicar un número hexadecimal
    rgb[2] += argb & 0xFF;          // El  hexadecimal literal para 0xFF es un int(255), por eso es la forma mas r'apida de obtener colores
  }
  rgb[1]=rgb[1]/pixels.length;
  rgb[2]=rgb[2]/pixels.length;
  rgb[0]=rgb[0]/pixels.length;

  return rgb;
}


//una funcion con un array de long podria quizas ser uno de int pero me parecio 
long[] promedio(int inicio, int fin) {
  long[]rgb={0, 0, 0};
  int suma= fin-inicio;

  // color promedio de la mitad de arriba de pantalla usando el largo del array/2 de la imagen
  loadPixels(); //cargamos todos los pixeles del video, ya que es un array con pixels.length
  for (int i = inicio; i < fin; i++) { //recorremos el array desde el px 0 a la mitad de pantalla, 102400px
    color argb = pixels[i];
    //a += (argb >> 24) & 0xFF; //a es para alfa, que no uso.
    rgb[0] += (argb >> 16) & 0xFF;  // (right shift) la forma mas rápida de obtener los colores red(argb) //>>  El número a la izquierda del operador se desplaza el número de lugares especificado por el número a la derecha.
    rgb[1] += (argb >> 8) & 0xFF;   //  & 0xFF se usa en java para 0x indicar un número hexadecimal
    rgb[2] += argb & 0xFF;          // El  hexadecimal literal para 0xFF es un int(255), por eso es la forma mas r'apida de obtener colores
  }
  rgb[1]=rgb[1]/suma;
  rgb[2]=rgb[2]/suma;
  rgb[0]=rgb[0]/suma;

  return rgb;
}


//esto se llama sobrecarga de funciones perimte hacer una funcion con el mismo nombre
//que reciba diversos parametros

long promedioR() {
  loadPixels();
  return promedioR(0, pixels.length);
}
long promedioR(int inicio, int fin) {
  long r =0;
  int suma= fin-inicio;

  // color promedio de la mitad de arriba de pantalla usando el largo del array/2 de la imagen
  loadPixels(); //cargamos todos los pixeles del video, ya que es un array con pixels.length
  for (int i = inicio; i < fin; i++) { //recorremos el array desde el px 0 a la mitad de pantalla, 102400px
    color argb = pixels[i];
    //a += (argb >> 24) & 0xFF; //a es para alfa, que no uso.
    r += (argb >> 16) & 0xFF;  // (right shift) la forma mas rápida de obtener los colores red(argb) //>>  El número a la izquierda del operador se desplaza el número de lugares especificado por el número a la derecha.
  }
  r=r/suma;

  return r;
}


long promedioG() {
  loadPixels();
  return promedioG(0, pixels.length);
}
long promedioG(int inicio, int fin) {
  long g =0;
  int suma= fin-inicio;

  // color promedio de la mitad de arriba de pantalla usando el largo del array/2 de la imagen
  loadPixels(); //cargamos todos los pixeles del video, ya que es un array con pixels.length
  for (int i = inicio; i < fin; i++) { //recorremos el array desde el px 0 a la mitad de pantalla, 102400px
    color argb = pixels[i];
    //a += (argb >> 24) & 0xFF; //a es para alfa, que no uso.
    g += (argb >> 16) & 0xFF;  // (right shift) la forma mas rápida de obtener los colores red(argb) //>>  El número a la izquierda del operador se desplaza el número de lugares especificado por el número a la derecha.
  }
  g=g/suma;

  return g;
}



long promedioB() {
  loadPixels();
  return promedioB(0, pixels.length);
}
long promedioB(int inicio, int fin) {
  long b =0;
  int suma= fin-inicio;

  // color promedio de la mitad de arriba de pantalla usando el largo del array/2 de la imagen
  loadPixels(); //cargamos todos los pixeles del video, ya que es un array con pixels.length
  for (int i = inicio; i < fin; i++) { //recorremos el array desde el px 0 a la mitad de pantalla, 102400px
    color argb = pixels[i];
    //a += (argb >> 24) & 0xFF; //a es para alfa, que no uso.
    b += (argb >> 16) & 0xFF;  // (right shift) la forma mas rápida de obtener los colores red(argb) //>>  El número a la izquierda del operador se desplaza el número de lugares especificado por el número a la derecha.
  }
  b=b/suma;

  return b;
}


long[] promedio(PGraphics pg){
  long[]rgb={0,0,0};
  // color promedio de la mitad de arriba de pantalla usando el largo del array/2 de la imagen
  pg.loadPixels(); //cargamos todos los pixeles del video, ya que es un array con pixels.length
  for (int i = 0; i < pg.pixels.length; i++) { //recorremos el array desde el px 0 a la mitad de pantalla, 102400px
    color argb = pg.pixels[i];
    //a += (argb >> 24) & 0xFF; //a es para alfa, que no uso.
    rgb[0] += (argb >> 16) & 0xFF;  // (right shift) la forma mas rápida de obtener los colores red(argb) //>>  El número a la izquierda del operador se desplaza el número de lugares especificado por el número a la derecha.
    rgb[1] += (argb >> 8) & 0xFF;   //  & 0xFF se usa en java para 0x indicar un número hexadecimal
    rgb[2] += argb & 0xFF;          // El  hexadecimal literal para 0xFF es un int(255), por eso es la forma mas r'apida de obtener colores
  }
  rgb[1]=rgb[1]/pg.pixels.length;
  rgb[2]=rgb[2]/pg.pixels.length;
  rgb[0]=rgb[0]/pg.pixels.length;
  
  return rgb;
  
}


//una funcion con un array de long podria quizas ser uno de int pero me parecio 
long[] promedio(PGraphics pg,int inicio,int fin){
  long[]rgb={0,0,0};
  int suma= fin-inicio;
  
  // color promedio de la mitad de arriba de pantalla usando el largo del array/2 de la imagen
    //pg.loadPixels();
  pg.loadPixels();
; //cargamos todos los pixeles del video, ya que es un array con pixels.length
  for (int i = inicio; i < fin; i++) { //recorremos el array desde el px 0 a la mitad de pantalla, 102400px
    color argb = pg.pixels[i];
    //a += (argb >> 24) & 0xFF; //a es para alfa, que no uso.
    rgb[0] += (argb >> 16) & 0xFF;  // (right shift) la forma mas rápida de obtener los colores red(argb) //>>  El número a la izquierda del operador se desplaza el número de lugares especificado por el número a la derecha.
    rgb[1] += (argb >> 8) & 0xFF;   //  & 0xFF se usa en java para 0x indicar un número hexadecimal
    rgb[2] += argb & 0xFF;          // El  hexadecimal literal para 0xFF es un int(255), por eso es la forma mas r'apida de obtener colores
  }
  rgb[1]=rgb[1]/suma;
  rgb[2]=rgb[2]/suma;
  rgb[0]=rgb[0]/suma;
  
  return rgb;
  
}


//esto se llama sobrecarga de funciones perimte hacer una funcion con el mismo nombre
//que reciba diversos parametros

long promedioR(PGraphics pg){
  pg.loadPixels();
 return promedioR(pg,0, pg.pixels.length);
}
long promedioR(PGraphics pg,int inicio,int fin){
  long r =0;
  int suma= fin-inicio;
  
  // color promedio de la mitad de arriba de pantalla usando el largo del array/2 de la imagen
    pg.loadPixels();
//pg.pixels.length; //cargamos todos los pixeles del video, ya que es un array con pixels.length
  for (int i = inicio; i < fin; i++) { //recorremos el array desde el px 0 a la mitad de pantalla, 102400px
    color argb = pg.pixels[i];
    //a += (argb >> 24) & 0xFF; //a es para alfa, que no uso.
    r += (argb >> 16) & 0xFF;  // (right shift) la forma mas rápida de obtener los colores red(argb) //>>  El número a la izquierda del operador se desplaza el número de lugares especificado por el número a la derecha.
   }
  r=r/suma;
   
  return r;
  
}


long promedioG(PGraphics pg){
    pg.loadPixels();

 return promedioG(pg,0,pg.pixels.length);
}
long promedioG(PGraphics pg,int inicio,int fin){
  long g =0;
  int suma= fin-inicio;
  
  // color promedio de la mitad de arriba de pantalla usando el largo del array/2 de la imagen
    pg.loadPixels();
//pg.pixels.length; //cargamos todos los pixeles del video, ya que es un array con pixels.length
  for (int i = inicio; i < fin; i++) { //recorremos el array desde el px 0 a la mitad de pantalla, 102400px
    color argb = pg.pixels[i];
    //a += (argb >> 24) & 0xFF; //a es para alfa, que no uso.
    g += (argb >> 16) & 0xFF;  // (right shift) la forma mas rápida de obtener los colores red(argb) //>>  El número a la izquierda del operador se desplaza el número de lugares especificado por el número a la derecha.
   }
  g=g/suma;
   
  return g;
  
}



long promedioB(PGraphics pg){
    pg.loadPixels();
//pg.pixels.length;
 return promedioB(pg,0, pg.pixels.length);
}
long promedioB(PGraphics pg,int inicio,int fin){
  long b =0;
  int suma= fin-inicio;
    pg.loadPixels();

  // color promedio de la mitad de arriba de pantalla usando el largo del array/2 de la imagen
  //pg.pixels.length; //cargamos todos los pixeles del video, ya que es un array con pixels.length
  for (int i = inicio; i < fin; i++) { //recorremos el array desde el px 0 a la mitad de pantalla, 102400px
    color argb = pg.pixels[i];
    //a += (argb >> 24) & 0xFF; //a es para alfa, que no uso.
    b += (argb >> 16) & 0xFF;  // (right shift) la forma mas rápida de obtener los colores red(argb) //>>  El número a la izquierda del operador se desplaza el número de lugares especificado por el número a la derecha.
   }
  b=b/suma;
   
  return b;
  
}
