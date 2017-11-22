void h1(String texto, float size , int x, int y){
  beginShape();
  fill(255,0,0);
  textSize(size);
  textAlign(CENTER);
  text(texto, x-600, y, 1200, height);

  
  endShape();
}

String time = "10";
int cont = 10;
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
    if(int(time) == 3){
      audioCronometro.play();
    }else if (int(time) == 0){
      background(bg);
      time = " ";
      delay(100);
      state = 4;
      played2 = false;
      //setup();
      playSong(); 
      
    }
    textSize(60); 
    text(time, width/2, height/2);
  
  endShape();
}