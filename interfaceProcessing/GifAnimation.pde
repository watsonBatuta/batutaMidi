import gifAnimation.*;

Gif saxGif, trompeteGif,tromboneGif , bateriaGif;
PImage saxImage, trompeteImage, troboneImage, bateriaImage;


void drawInstrument(Gif gif, PImage img, int X, int Y, Boolean shake){
  
  if (shake){
    image(gif, X, Y - gif.height / 2);
    
  }else{
    image(img, X, Y - img.height / 2);
  }

}

void loadGif(){
  saxGif = new Gif(this,"");
  trompeteGif = new Gif(this,"");
  tromboneGif  = new Gif(this,"");
  bateriaGif = new Gif(this,"");
  
  saxImage = loadImage("");
  trompeteImage = loadImage("");
  troboneImage = loadImage("");
  bateriaImage = loadImage("");

  


}