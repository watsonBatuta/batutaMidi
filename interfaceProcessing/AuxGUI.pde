void h1(String texto, float size , int x, int y){
  beginShape();
  textSize(size);
  textAlign(CENTER);
  text(texto, x, y);
  fill(255,0,0);
  
  endShape();
}

String time = "5";
int cont = 5;
int initialTime;
int interval = 1000;//one second

void cronometro(){
  beginShape();
    playSolos();
    //background(bg);
    println("time " + time);
    println("milis "+millis());
    if (millis() - (initialTime) > interval && int(time) > 0){
      println("inside if cronometro");
      time = nf(begin+(cont - int(millis()/1000)), 1);
      println("time " + time);
      initialTime = millis();
      
    }
    if (int(time) == 0){
      background(bg);
      time = " ";
      delay(100);
      state = 3;
      //setup();
      playSong();
      
      
    }
    textSize(60); 
    text(time, width/2, height/2);
  
  endShape();
}