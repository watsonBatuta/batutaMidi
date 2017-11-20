void h1(String texto, float size , int x, int y){
  beginShape();
  textSize(size);
  textAlign(CENTER);
  text(texto, x, y);
  fill(255);
  
  endShape();
}

void cronometro(){
  beginShape();
    playSolos();
    //background(bg);
    if (millis() - (initialTime) > interval && int(time) > 0){
      println(millis());
      time = nf(begin+(cont - int(millis()/1000)), 2);
      initialTime = millis();
      
    }
    if (int(time) == 0){
      background(bg);
      time = "vamos Frevar!";
      delay(100);
      //setup();
      state = 0;
      
    }
    textSize(60); 
    text(time, width/2, height/2);
  
  endShape();
}