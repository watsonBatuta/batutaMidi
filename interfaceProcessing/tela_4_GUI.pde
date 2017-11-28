void tela4(){
  background(bg);
  String [] textos = {"Obrigado  por ter me ajudado a tocar o frevo","Não sei o que seria de mim sem vocês", "Como provavelmente não terei braços tão cedo", "posso te ligar quando o carnaval começar?" }  ;
  int [] delay = {3000,3000,3000,4000};
  
    if (freviana_agradecimentos.isPlaying()==false) {
      if (played){
        //setup();
        state = 6;
        played = false;
                
      }else{
        println("play freviana");
        freviana_agradecimentos.play();
        freviana_agradecimentos.setGain(5);
        played =true;
      }
    }
  
  
  if (fimAnimacao){
    h1(textos[textos.length-1],40, width/2, 230);
  }else{
    fade(textos, delay, 40, width/2, 230);
  }
  
  //h1("Agradecimentos", 40, width/2, height-700);
  
  image(softex, width/2+50, height-75, 130, 60);
  image(ibm, width/2+200, height-75, 80, 70);
  //image(paco, width/2+300, height-80, 50,70);
  image(logo, width-1100, height-70);
  
  
  
  for(int i = 0; i < freviana_agradecimentos.bufferSize() - 1; i++){
    beginShape();
      stroke(255, 9, 99);
      line(i, height/2 -50   + freviana_agradecimentos.left.get(i)*50,  i+25, height/2-50  + freviana_agradecimentos.left.get(i+1)*50);
      //line(i, height/2 + + freviana_agradecimentos.right.get(i)*50, i+1, height/2 + freviana_agradecimentos.right.get(i+1)*50);
      fill(225);
    endShape();
  }
  

}  