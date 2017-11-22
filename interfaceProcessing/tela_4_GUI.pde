void tela4(){
  background(bg);
  String [] textos = {"Obrigado  por ter me ajudado a tocar o frevo, adorei!"," Não sei o que seria de mim   sem vocês.", "Como provavelmente  não terei braços tão cedo posso te ligar quando o carnaval  começar?" }  ;
  int [] delay = {5000,5000,6000};
  
  if (fimAnimacao){
    h1(textos[textos.length-1],40, width/2, 30);
  }else{
    fade(textos, delay, 40, width/2, 30);
  }
  
  h1("Agradecimentos", 40, width/2, height-700);
  
  image(softex, width/2+50, height-75, 130, 60);
  image(ibm, width/2+200, height-75, 80, 70);
  image(paco, width/2+300, height-80, 50,70);
  image(logo, width-1100, height-70);
  
  freviana_agradecimentos.play();
  
  for(int i = 0; i < freviana_agradecimentos.bufferSize() - 1; i++){
    beginShape();
      stroke(10, 10, 255);
      line(i, height/2 -50   + freviana_agradecimentos.left.get(i)*50,  i+1, height/2-50  + freviana_agradecimentos.left.get(i+1)*50);
      line(i, height/2 + + freviana_agradecimentos.right.get(i)*50, i+1, height/2 + freviana_agradecimentos.right.get(i+1)*50);
      fill(225);
    endShape();
  }

}