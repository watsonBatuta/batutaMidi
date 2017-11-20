import gifAnimation.*;

Gif saxGif, trompeteGif,tromboneGif , bateriaGif;
PImage saxImage, trompeteImage, tromboneImage, bateriaImage;

void drawInstrument(Gif gif, PImage img, int X, int Y, int shake){
  
  if (shake > 30){
    image(gif, X, Y , 180,140);
    
  }else{
    image(img, X, Y, 180,140);
  }

}

void loadGif(){
  saxGif = new Gif(this,"sax_gif.gif");
  trompeteGif = new Gif(this,"sax_gif.gif");
  tromboneGif  = new Gif(this,"sax_gif.gif");
  bateriaGif = new Gif(this,"sax_gif.gif");
  saxGif.loop();
  trompeteGif.loop();
  tromboneGif.loop();
  bateriaGif.loop();

  saxImage = loadImage("sax_white.png");
  trompeteImage = loadImage("sax_white.png");
  tromboneImage = loadImage("sax_white.png");
  bateriaImage = loadImage("sax_white.png");
  

  


}