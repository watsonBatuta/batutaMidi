void tela5(){
  
      
      println("Tocando agradecimentos");
      background(bg);  
      h1("AGRADECIMENTOS", 40, width/2, height-700);
       
      image(softex, width/2-110, (height/2)-200, 260, 120);
      image(ibm, width/2-400, (height/2)-200, 160, 140);
      image(paco, width/2+330, (height/2)-200, 100,140);
      image(logo, width/2-190, height-100);
      
      h1("Empresas apoiadoras",20, width/2, height/2);
      
      //Coluna 1
      h1("Softex", 18, width-1000, (height/2)+40);
      h1("Pitang", 18, width-1000, (height/2)+60);
      h1("CESAR", 18, width-1000, (height/2)+80);
      h1("RH3 Software", 18, width-1000, (height/2)+100);
      h1("Facilit", 18, width-1000, (height/2)+120);
      h1("Procenge", 18, width-1000, (height/2)+140);
      
      //Coluna 2

      h1("NeuroTech", 18, width/2, (height/2)+40);
      h1("In Forma", 18, width/2, (height/2)+60);
      h1("Inhalt", 18, width/2, (height/2)+80);
      h1("CMTech", 18, width/2, (height/2)+100);
      h1("Serttel", 18, width/2, (height/2)+120);
      h1("Avantia", 18, width/2, (height/2)+140);
      h1("Batebit", 18, width/2, (height/2)+160);
      
      //Coluna 3

      h1("Qualinfo Tecnologia", 18, width-300, (height/2)+40);
      h1("Pluri Educacional", 18, width-300, (height/2)+60);
      h1("Corptech", 18, width-300, (height/2)+80);
      h1("DataXpert ", 18, width-300, (height/2)+100);
      h1("Teleport", 18, width-300, (height/2)+120);
      h1("L.O.U.Co", 18, width-300, (height/2)+140);
      h1("D'accord", 18, width-300, (height/2)+160);

     
  
  if (frevo_agradecimento.isPlaying()==false) {
    if (played){
    again();
    println("agradecimentos encerrado");
  }else{
    frevo_agradecimento.play();
    frevo_agradecimento.setGain(0);
    played = true;
   }    
 }  
}