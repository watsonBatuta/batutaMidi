void tela2(){
  background(bg);
  textAlign(CENTER);
  h1("Agora, chegou a hora,", 40 ,width/2, 40);
  h1("de juntar a orquestra e afinar os instrumentos.", 40 ,width/2, 100);
  h1("Quanto mais rápido você balancar,", 40 ,width/2, 160);
  h1("mais alto o volume do seu intrumento será!", 40 ,width/2, 220);
  for(int i = 0; i < freviana2_1.bufferSize() - 1; i++)
    {
      beginShape();
      stroke(10, 10, 255);
      line(i, height/2 -50   + freviana2_1.left.get(i)*50,  i+1, height/2-50  + freviana2_1.left.get(i+1)*50);
      line(i, height/2 + + freviana2_1.right.get(i)*50, i+1, height/2 + freviana2_1.right.get(i+1)*50);
      fill(225);
      endShape();
    }
  
  drawInstrument(saxGif,saxImage, width/2-390, height/2+100, instruments.get(0) );
  drawInstrument(tromboneGif, tromboneImage, width/2-190, height/2+100, instruments.get(1));
  drawInstrument(trompeteGif, trompeteImage, width/2+10, height/2+100, instruments.get(2));
  drawInstrument(bateriaGif, bateriaImage, width/2+210, height/2+100, instruments.get(3));
  
//int x, int y, int scale, float midi, int R, int G, int B, float variableMM, float variableNN1, float variableNN2, float variableNN3
  //instrument(width/2-300, height/2+200, 75, instruments.get(0), 237, 28, 36, 2, map(instruments.get(0), 0,127,0.1,2), 0.5, 0.5);
  //instrument(width/2-100, height/2+200, 75, instruments.get(1), 255, 230, 0, 2, map(instruments.get(1), 0,127,0.1,2), 0.5, 0.5);
  
  //instrument(width/2+100, height/2+200, 75, instruments.get(2), 0, 0, 179, 2, map(instruments.get(2), 0,127,0.1,2), 0.5, 0.5);
  //instrument(width/2+300, height/2+200, 75, instruments.get(3), 7, 156, 66, 2, map(instruments.get(3), 0,127,0.1,2), 0.5, 0.5);    
  
  if (freviana2_1.isPlaying()==false) {
    if (played){
      println("cronometro");
      background(bg);
      textAlign(CENTER);
      h1("Agora, chegou a hora,", 40 ,width/2, 40);
      h1("de juntar a orquestra e afinar os instrumentos.", 40 ,width/2, 100);
      h1("Quanto mais rápido você balancar,", 40 ,width/2, 160);
      h1("mais alto o volume do seu intrumento será!", 40 ,width/2, 220);
      cronometro();
      drawInstrument(saxGif,saxImage, width/2-390, height/2+100, instruments.get(0) );
      drawInstrument(tromboneGif, tromboneImage, width/2-190, height/2+100, instruments.get(1));
      drawInstrument(trompeteGif, trompeteImage, width/2+10, height/2+100, instruments.get(2));
      drawInstrument(bateriaGif, bateriaImage, width/2+210, height/2+100, instruments.get(3));
      //instrument(width/2-300, height/2+200, 75, instruments.get(0), 237, 28, 36, 2, map(instruments.get(0), 0,127,0.1,2), 0.5, 0.5);
      //instrument(width/2-100, height/2+200, 75, instruments.get(1), 255, 230, 0, 2, map(instruments.get(1), 0,127,0.1,2), 0.5, 0.5);
      //instrument(width/2+100, height/2+200, 75, instruments.get(2), 0, 0, 179, 2, map(instruments.get(2), 0,127,0.1,2), 0.5, 0.5);
      //instrument(width/2+300, height/2+200, 75, instruments.get(3), 7, 156, 66, 2, map(instruments.get(3), 0,127,0.1,2), 0.5, 0.5);              

    }else{
      println("play freviana");
      freviana2_1.play();
      freviana2_1.setGain(-20);
      played =true;
      begin = millis()/1000+10;
    }
  }
}