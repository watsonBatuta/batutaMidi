void tela5(){
  
      
      println("Tocando agradecimentos");
      background(bg);  
      h1("AGRADECIMENTOS", 40, width/2, height-700);
       
      image(softex, width/2+50, height-75, 130, 60);
      image(ibm, width/2+200, height-75, 80, 70);
      //image(paco, width/2+300, height-80, 50,70);
      image(logo, width-1100, height-70);
      
      h1("Empresas apoiadoras",20, width/2, height/2);
      
      //Coluna 1
      h1("Softex", 18, width-1000, (height/2)+40);
      h1("Pitang", 18, width-1000, (height/2)+60);
      h1("CESAR", 18, width-1000, (height/2)+80);
      h1("RH3", 18, width-1000, (height/2)+100);
      h1("Facilit", 18, width-1000, (height/2)+120);
      h1("Procenge", 18, width-1000, (height/2)+140);
      
      //Coluna 2
      h1("Neurotech", 18, width/2, (height/2)+40);
      h1("In Forma", 18, width/2, (height/2)+60);
      h1("Inhalt", 18, width/2, (height/2)+80);
      h1("Cmtech", 18, width/2, (height/2)+100);
      h1("Serttel", 18, width/2, (height/2)+120);
      h1("Avantia", 18, width/2, (height/2)+140);
      h1("Batebit", 18, width/2, (height/2)+160);
      
      //Coluna 3
      h1("Qualinfo", 18, width-300, (height/2)+40);
      h1("Pluri", 18, width-300, (height/2)+60);
      h1("Corptech", 18, width-300, (height/2)+80);
      h1("DataXpert ", 18, width-300, (height/2)+100);
      h1("Teleport", 18, width-300, (height/2)+120);
      h1("LOUCO", 18, width-300, (height/2)+140);
      h1("Daccord", 18, width-300, (height/2)+160);
      
  
  if (frevo_agradecimento.isPlaying()==false) {
    if (played){
    again();
    println("agradecimentos encerrado");
  }else{
    frevo_agradecimento.play();  
    played = true;
   }    
 }  
}