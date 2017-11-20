void tela0(){
  beginShape();
  background(bg);
  textSize(50);
  textAlign(CENTER);
  text("Experimente o Frevo com", width/2, height/2-100);
  fill(255);
  endShape();
  beginShape();
  textSize(30);
  text("Balance um intrumento para iniciar a interação", width/2, height/2+150);
  endShape();
  
  image(logo, width/2-180, height/2-60);
  image(softex, width/2+50, height-75, 130, 60);
  image(ibm, width/2+200, height-75, 80, 70);
  image(paco, width/2+300, height-80, 50,70);
  
}