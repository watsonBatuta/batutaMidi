int timeFade = 0;
boolean textfadesin = true;
int fadeout = 255;
int fadein = -100;
boolean fimAnimacao = false;
int i = 0;
boolean first = true;

void h1(String texto, float size , int x, int y){
  beginShape();
  fill(255);
  textSize(size);
  textAlign(CENTER);
  text(texto, x-600, y, 1200, height);

  
  endShape();
}

void fade(String [] textos,int [] timeDelay, float size , int x, int y){
  //i = 0
  //println ("fade " + textfadesin );
  if (textfadesin) {
    if(first){
      timeFade = millis();
      first = false;
    }
    println ("fade " + textos[i] );
    textSize(size);
    smooth(); 
    textAlign(CENTER); 
    tint(255); 
      
    fill(255, fadein);
    text(textos[i], x-600, y, 1200, height);
    fadein = fadein + 2;
    
    //y =- 200;
  }else{
    if (fadein < -50){
      i++;
      textfadesin = true;      
    }
    if (i==textos.length){
      

    }
    textSize(size);
    smooth(); 
    textAlign(CENTER); 
    tint(255); 
    //tint(255, fadein+100); 
    //for (String t : textos){
    println("i "+i);  
    fill(255, fadein);
    text(textos[i], x-600, y, 1200, height);
    
    if(i ==textos.length-1){
      println("para para");
      fimAnimacao = true;
      first = true;
      i=0;
      fadein = -50;
      return;
    }else{fadein = fadein - 10;}
    
    //fadein = fadein - timeDelay[i]/100;
    //println(fadein);
    
   } 
   if (millis() - timeFade >= timeDelay[i]) {
     println("quando estou aqui");
     timeFade = millis();
     textfadesin = false ;
      
   }
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