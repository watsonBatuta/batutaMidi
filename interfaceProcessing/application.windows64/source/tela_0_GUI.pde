void tela0(){
  beginShape();
  background(bg);
  textSize(50);
  textAlign(CENTER);
  text("Experimente o 1º Frevo criado por", width/2, height/2-160);
  text("um artista com uso de Inteligência Artificial",  width/2, height/2-110);
  
  image(logo, width/2-180, height/2-10);
  fill(255);
  endShape();
  beginShape();
  textSize(30);
  text("Balance um intrumento para iniciar a interação", width/2, height/2+150);
  h1("Música: Tem coisa no Frevo",25, width/2-530, height-140);
  h1("Autor: Sergio Gaia e I.A",25, width/2-553, height-110);
  h1("Gravação: Spok Frevo Orquestra",25, width/2-498, height-80);
  endShape();
  
  
  image(softex, width/2+50, height-75, 130, 60);
  image(ibm, width/2+200, height-75, 80, 70);
  image(paco, width/2+300, height-80, 50,70);
  image(louco, width/2+400, height-80, 100,70);
  
}