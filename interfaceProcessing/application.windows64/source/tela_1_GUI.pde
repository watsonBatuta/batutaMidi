void tela1(){
  background(bg); 
  if (frevianaPlayable.isPlaying()==false) {
    if (played){
      state = 2;
      fimAnimacao = false;
      played = false;
      println("entrei aqui");
    }else{
      println("Tocando freviana " + instrumentoAtual);
        switch(instrumentoAtual){
          case 0:{
            frevianaPlayable = freviana1_0;
            freviana2 = freviana2_1;
            frevianaPlayable.play();
            println(" play 0 ");
            
            instrumento = "pelo saxofone";
            
            break;
          }
          case 1:{
            frevianaPlayable = freviana1_1;
            freviana2 = freviana2_1;
            frevianaPlayable.play();
            frevianaPlayable.setGain(5);
            instrumento = "pelo trombone";
            println(" play 1 ");
            break;
          }
          case 2:{
            frevianaPlayable = freviana1_2;
            freviana2 = freviana2_1;
            frevianaPlayable.play();
            instrumento = "pelo trompete";
            println(" play 2 ");
            break;
          }
          case 3:{
            frevianaPlayable = freviana1_3;
            freviana2 = freviana2_1;
            frevianaPlayable.play();
            instrumento = "pela bateria"; 
            println(" play 3 ");
            break;
          }
          case 4:{
            frevianaPlayable = freviana1_4;
            freviana2 = freviana2_5;
            frevianaPlayable.play();
            instrumento = "batuta"; 
            println(" play 4 ");
            break;
          }
        }
      //frevianaPlayable.play();
      frevianaPlayable.setGain(0);
      played =true;
    }
  }
  if(instrumentoAtual == 4){
    String [] textos = {"Olá, sou a Freviana, a inteligência artificial por trás do Batuta", " Percebi que você se interessou pela Batuta", "Com a ajuda do Paço do Frevo compus um frevo único", "mas como sou feita apenas de bits preciso da sua ajuda para orquestrá-lo"};
    int [] delay = {5000,3000,3500,4000};
    println("texto batuta");
    if (fimAnimacao){
      h1(textos[textos.length-1],40, width/2, 230);
      //image(ai, width/2 , height/2, 75,50);
    }else{
      fade(textos, delay, 40, width/2, 230);
    }
  }else{
    String [] textos = {"Olá, sou a Freviana, a inteligência artificial por trás do Batuta", " Percebi que você se interessou " + instrumento + " "," Com a ajuda do Paço do Frevo compus um frevo único", " mas como sou feita apenas de bits preciso da sua ajuda para tocá-lo"};
    int [] delay = {5000,3000,3500,4000};
    
    if (fimAnimacao){
      h1(textos[textos.length-1],40, width/2, 230);
    }else{
      fade(textos, delay, 40, width/2, 230);
      
    }
    //h1("Olá, sou a Freviana, a inteligência artificial por trás do Batuta. Percebi que você se interessou pelo " + instrumento + ". Com a ajuda do Paço do Frevo compus um frevo único, mas como sou feita apenas de bits preciso da sua ajuda para tocá-lo. ",40, width/2, 30);
    //h1("Olá, sou a Freviana, a inteligência artificial por trás do Batuta.", 40, width/2, 40);
    //h1("Percebi que você se interessou pelo "+instrumento+".", 40, width/2, 100);
    //h1("Com a ajuda do Paço do Frevo compus um frevo único,", 40, width/2, 160);
    //h1("mas como sou feita apenas de bits preciso da sua ajuda para tocá-lo.", 40, width/2, 220);
  }
  //myBus.list();
  //mainDraw(width/2, height/2, 60);
  
    
    try{for(int i = 0; i < frevianaPlayable.bufferSize() - 1; i++)
    {
      beginShape();
      fill(225);
      stroke(255, 9, 99);
      line(i, height/2 -50   + frevianaPlayable.left.get(i)*50,  i+25, height/2-50  + frevianaPlayable.left.get(i+1)*50);
      //line(i, height/2 + + frevianaPlayable.right.get(i)*50, i+1, height/2 + frevianaPlayable.right.get(i+1)*50);
      endShape();
    }}catch(Exception e){println(e);};
  
//int x, int y, int scale, float midi, int R, int G, int B, float variableMM, float variableNN1, float variableNN2, float variableNN3

  image(ai, width/2-50, 120, 100,100);
  drawInstrument(tromboneGif,tromboneImage, width/2-600, height/2+100, instruments.get(1) );
  h1("Para aumentar o instrumento",15, width/2-510, height/2+260);
  drawInstrument(bateriaGif, bateriaImage, width/2-350, height/2+100, instruments.get(3));
  h1("Para aumentar o instrumento",15, width/2-260, height/2+260);
  drawInstrument(saxGif, saxImage, width/2-100, height/2+100, instruments.get(0));
  h1("Para aumentar a banda",15, width/2-10, height/2+260);
  drawInstrument(trompeteGif, trompeteImage, width/2+150, height/2+100, instruments.get(2));
  h1("Para aumentar o instrumento",15, width/2+240, height/2+260);
  drawInstrument(batutaGif, batutaImage, width/2+400, height/2+100, instruments.get(4));
  h1("Para aumentar o instrumento",15, width/2+490, height/2+260);
  //instrument(width/2-300, height/2+200, 75, instruments.get(0), 237, 28, 36, 2, map(instruments.get(0), 0,127,0.1,2), 0.5, 0.5);
  //instrument(width/2-100, height/2+200, 75, instruments.get(1), 255, 230, 0, 2, map(instruments.get(1), 0,127,0.1,2), 0.5, 0.5);
  //instrument(width/2+100, height/2+200, 75, instruments.get(2), 0, 0, 179, 2, map(instruments.get(2), 0,127,0.1,2), 0.5, 0.5);
  //instrument(width/2+300, height/2+200, 75, instruments.get(3), 7, 156, 66, 2, map(instruments.get(3), 0,127,0.1,2), 0.5, 0.5);         

  //state = 1;
}