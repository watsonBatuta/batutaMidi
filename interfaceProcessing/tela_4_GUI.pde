void tela4(){
  background(bg);
  String [] textos = {"Obrigado  por ter me ajudado a tocar o frevo,"," Não sei o que seria de mim sem vocês.", "Como provavelmente não terei braços tão cedo posso te ligar quando o carnaval começar?" }  ;
  int [] delay = {6000,7000,6000};
  
    if (freviana_agradecimentos.isPlaying()==false) {
      if (played){
        //setup();
        again();
                
      }else{
        println("play freviana");
        freviana_agradecimentos.play();
        freviana_agradecimentos.setGain(-20);
        played =true;
      }
    }
  
  
  if (fimAnimacao){
    h1(textos[textos.length-1],40, width/2, height/2-250);
  }else{
    fade(textos, delay, 40, width/2, height/2-250);
  }
  
  h1("Agradecimentos", 40, width/2, height-700);
  
  image(softex, width/2+50, height-75, 130, 60);
  image(ibm, width/2+200, height-75, 80, 70);
  image(paco, width/2+300, height-80, 50,70);
  image(logo, width-1100, height-70);
  
  
  
  for(int i = 0; i < freviana_agradecimentos.bufferSize() - 1; i++){
    beginShape();
      stroke(10, 10, 255);
      line(i, height/2 -50   + freviana_agradecimentos.left.get(i)*50,  i+1, height/2-50  + freviana_agradecimentos.left.get(i+1)*50);
      line(i, height/2 + + freviana_agradecimentos.right.get(i)*50, i+1, height/2 + freviana_agradecimentos.right.get(i+1)*50);
      fill(225);
    endShape();
  }

}  