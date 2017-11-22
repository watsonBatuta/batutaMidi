void tela3(){
  background(bg);
  textAlign(CENTER);
  println("___________________TELA 3");
  String [] textos = {"Estão todos prontos? É hora de afinar os instrumentos. ", "O Bloco está prestes a sair e ninguém pode ficar pra trás!"};
  int [] delay = {5000,5000,5000};
  println("texto batuta");
  if (fimAnimacao){
    h1(textos[textos.length-1],40, width/2, 30);
  }else{
    fade(textos, delay, 40, width/2, 30);
  }
  
  for(int i = 0; i < freviana3.bufferSize() - 1; i++){
    beginShape();
      stroke(10, 10, 255);
      line(i, height/2 -50   + freviana3.left.get(i)*50,  i+1, height/2-50  + freviana3.left.get(i+1)*50);
      line(i, height/2 + + freviana3.right.get(i)*50, i+1, height/2 + freviana3.right.get(i+1)*50);
      fill(225);
    endShape();
  }

  drawInstrument(saxGif,saxImage, width/2-600, height/2+100, instruments.get(0) );
  h1("Para aumentar o instrumento",15, width/2-510, height/2+260);
  drawInstrument(tromboneGif, tromboneImage, width/2-350, height/2+100, instruments.get(1));
  h1("Para aumentar o instrumento",15, width/2-260, height/2+260);
  drawInstrument(batutaGif, batutaImage, width/2-100, height/2+100, instruments.get(4));
  h1("Para aumentar a banda",15, width/2-10, height/2+260);
  drawInstrument(trompeteGif, trompeteImage, width/2+150, height/2+100, instruments.get(2));
  h1("Para aumentar o instrumento",15, width/2+240, height/2+260);
  drawInstrument(bateriaGif, bateriaImage, width/2+400, height/2+100, instruments.get(3));
  h1("Para aumentar o instrumento",15, width/2+490, height/2+260);
  
  if (freviana3.isPlaying()==false) {
    if (played){
      println("estado 1 da tela mudar de estado");
      println("cronometro");
      background(bg);
      textAlign(CENTER);
      h1("O Bloco está prestes a sair e ninguém pode ficar pra trás!", 40 ,width/2, 160);
      cronometro();
      drawInstrument(saxGif,saxImage, width/2-600, height/2+100, instruments.get(0) );
      h1("Para aumentar o instrumento",15, width/2-510, height/2+260);
      drawInstrument(tromboneGif, tromboneImage, width/2-350, height/2+100, instruments.get(1));
      h1("Para aumentar o instrumento",15, width/2-260, height/2+260);
      drawInstrument(batutaGif, batutaImage, width/2-100, height/2+100, instruments.get(4));
      h1("Para aumentar a banda",15, width/2-10, height/2+260);
      drawInstrument(trompeteGif, trompeteImage, width/2+150, height/2+100, instruments.get(2));
      h1("Para aumentar o instrumento",15, width/2+240, height/2+260);
      drawInstrument(bateriaGif, bateriaImage, width/2+400, height/2+100, instruments.get(3));
      h1("Para aumentar o instrumento",15, width/2+490, height/2+260);    
              
    }else{
      println("play freviana");
      freviana3.play();
      freviana3.setGain(-20);
      played =true;
      delay(1000);
    }
  }
  
}