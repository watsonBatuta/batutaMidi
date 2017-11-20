void tela1(){
  background(bg); 
  if (frevianaPlayable.isPlaying()==false) {
    if (played){
      state = 2;
      played = false;
      println("entrei aqui");
    }else{
      println("Tocando freviana " + instrumentoAtual);
        switch(instrumentoAtual){
          case 0:{
            frevianaPlayable = freviana1_0;
            frevianaPlayable.play();
            instrumento = "Saxofone";
            println(" play 0 ");
            break;
          }
          case 1:{
            frevianaPlayable = freviana1_1;
            frevianaPlayable.play();
            instrumento = "trombone";
            println(" play 1 ");
            break;
          }
          case 2:{
            frevianaPlayable = freviana1_2;
            frevianaPlayable.play();
            instrumento = "trompete";
            println(" play 2 ");
            break;
          }
          case 3:{
            frevianaPlayable = freviana1_3;
            frevianaPlayable.play();
            instrumento = "bateria"; 
            println(" play 3 ");
            break;
          }
        }
      //frevianaPlayable.play();
      frevianaPlayable.setGain(-20);
      played =true;
    }
  }       
  h1("Olá, sou a Freviana, a inteligência artificial por trás do Batuta.", 40, width/2, 40);
  h1("Percebi que você se interessou pelo "+instrumento+".", 40, width/2, 100);
  h1("Com a ajuda do Paço do Frevo compus um frevo único,", 40, width/2, 160);
  h1("mas como sou feita apenas de bits preciso da sua ajuda para tocá-lo.", 40, width/2, 220);
    
  //myBus.list();
  //mainDraw(width/2, height/2, 60);
  
    
    try{for(int i = 0; i < frevianaPlayable.bufferSize() - 1; i++)
    {
      beginShape();
      fill(225);
      stroke(10, 10, 255);
      line(i, height/2 -50   + frevianaPlayable.left.get(i)*50,  i+1, height/2-50  + frevianaPlayable.left.get(i+1)*50);
      line(i, height/2 + + frevianaPlayable.right.get(i)*50, i+1, height/2 + frevianaPlayable.right.get(i+1)*50);
      endShape();
    }}catch(Exception e){println(e);};
  
//int x, int y, int scale, float midi, int R, int G, int B, float variableMM, float variableNN1, float variableNN2, float variableNN3
  drawInstrument(saxGif,saxImage, width/2-390, height/2+100, instruments.get(0) );
  drawInstrument(tromboneGif, tromboneImage, width/2-190, height/2+100, instruments.get(1));
  drawInstrument(trompeteGif, trompeteImage, width/2+10, height/2+100, instruments.get(2));
  drawInstrument(bateriaGif, bateriaImage, width/2+210, height/2+100, instruments.get(3));
  //instrument(width/2-300, height/2+200, 75, instruments.get(0), 237, 28, 36, 2, map(instruments.get(0), 0,127,0.1,2), 0.5, 0.5);
  //instrument(width/2-100, height/2+200, 75, instruments.get(1), 255, 230, 0, 2, map(instruments.get(1), 0,127,0.1,2), 0.5, 0.5);
  //instrument(width/2+100, height/2+200, 75, instruments.get(2), 0, 0, 179, 2, map(instruments.get(2), 0,127,0.1,2), 0.5, 0.5);
  //instrument(width/2+300, height/2+200, 75, instruments.get(3), 7, 156, 66, 2, map(instruments.get(3), 0,127,0.1,2), 0.5, 0.5);         

  //state = 1;
}