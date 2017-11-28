boolean played2 = false;

void tela2(){
  background(bg);
  textAlign(CENTER);
  if(instrumentoAtual == 4){
    
    String [] textos = {" Hoje você é o Maestro", "Aponte a batuta pra cima e pra baixo e aumente ou diminua o volume de todos.", "E se quiser animar a banda balance a batuta o mais rápido que puder"};
    int [] delay = {2000,5000,5000};
    println("texto batuta");
    if (fimAnimacao){
      h1(textos[textos.length-1],40, width/2, 230);
    }else{
      fade(textos, delay, 40, width/2, 230);
    }
  }else{
    String [] textos = {"Você pode me ajudar com a música", "Balance seu objeto pra cima e pra baixo e aumente ou diminua o volume"};
    int [] delay = {3000,5000};
    println("texto batuta");
    if (fimAnimacao){
      h1(textos[textos.length-1],40, width/2, 230);
    }else{
      fade(textos, delay, 40, width/2, 230);
    }
  }

  for(int i = 0; i < freviana2.bufferSize() - 1; i++){
      beginShape();
      stroke(255, 9, 99);
      line(i, height/2 -50   + freviana2.left.get(i)*50,  i+25, height/2-50  + freviana2.left.get(i+1)*50);
      //line(i, height/2 + + freviana2.right.get(i)*50, i+1, height/2 + freviana2.right.get(i+1)*50);
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
  
//int x, int y, int scale, float midi, int R, int G, int B, float variableMM, float variableNN1, float variableNN2, float variableNN3
  //instrument(width/2-300, height/2+200, 75, instruments.get(0), 237, 28, 36, 2, map(instruments.get(0), 0,127,0.1,2), 0.5, 0.5);
  //instrument(width/2-100, height/2+200, 75, instruments.get(1), 255, 230, 0, 2, map(instruments.get(1), 0,127,0.1,2), 0.5, 0.5);
  
  //instrument(width/2+100, height/2+200, 75, instruments.get(2), 0, 0, 179, 2, map(instruments.get(2), 0,127,0.1,2), 0.5, 0.5);
  //instrument(width/2+300, height/2+200, 75, instruments.get(3), 7, 156, 66, 2, map(instruments.get(3), 0,127,0.1,2), 0.5, 0.5);    
  
  if (freviana2.isPlaying()==false) {
    if (played){
      //println("estado da tela mudar de estado");
      state = 3;
      fimAnimacao = false;
      played = false;
      delay(1500);
      
              
    }else{
      println("play freviana");
      freviana2.play();
      freviana2.setGain(5);
      played =true;
    }
  }
}