import themidibus.*; //Import the library
import ddf.minim.*;

MidiBus sax, trompete, trombone, percussao, batuta; // The MidiBus

float scaler = 75;
int m = 2;
float n1 = 18;
float n2 = 1;
float n3 = 1;
IntList instruments;
AudioPlayer soloBateria, soloSax, soloTrompete, soloTrombone, freviana1_2, freviana2_1;
Minim minim;//audio context
boolean played;

String time = "10";
int cont = 10;
int initialTime;
int interval = 1000;//one second
color bg = color (0);
int begin = 0;

int state;

PImage logo, softex, ibm, paco;

void setup() {
  // Load audios,
  minim = new Minim(this);
  loadSolos();
  freviana1_2 = minim.loadFile("freviana_1_2.mp3",2048);
  freviana2_1 = minim.loadFile("freviana_2_1.mp3",2048);


  //saxValue = 0 , tromboneValue = 1, trompeteValue=2 ,percussaoValue=3, batutaValue=4 ;
  instruments = new IntList(0,0,0,0,0);

  //fullScreen();
  size(800,600);
  smooth();
  noFill();
  state = 1;
  // sax, trombone,trompete, percussao, batuta; 
  sax = new MidiBus(this, 1, -1,"0");
  trombone = new MidiBus(this, 0, 4,"1");
/* trompete = new MidiBus(this, 0, 4,"2");
  percussao = new MidiBus(this, 0, 4,"3");
  batuta = new MidiBus(this, 0, 4,"4");*/
  
  
  sax.list();
  
  
  logo = loadImage("logoBatuta.png");
  softex = loadImage("logoSoftex.png");
  ibm = loadImage("logoIBM.png");
  paco = loadImage("logoPaco.png");

  
}

void controllerChange(int channel, int number, int value) {
  // Receive a controllerChange
  println("state");
  println(state);
  //println("Channel:"+channel);
  //println("Number:"+number);
  //println("Value:"+value);
  switch(state){
    case 0:{
      if(value>40){
        state = 1;
        instruments.set(channel,value);
        println(channel);
        delay(3000);
        
      }
      break;
    }
    case 1:{
      instruments.set(channel,value);
      println(channel);
      //sendAbleton(channel,1,value);
      break;
    }case 2:{
      println("channel "+ channel);
      println("value "+ value);
      instruments.set(channel,value);
      
      
    }
    case 3:{
      //sendAbleton(channel, number, value);
      break;
    }
  } 
}

void sendAbleton(int intrumento,int note, int value){
    //saxValue = 0 , tromboneValue = 1, trompeteValue=2 ,percussaoValue=3, batutaValue=4 ;
  switch(intrumento){
    case 0:{
      sax.sendControllerChange(0, note, value);
    }
    case 1:{
      trombone.sendControllerChange(1, note, value);
    }
    case 2:{
      trompete.sendControllerChange(2, note,value);
    }
    case 3:{
      percussao.sendControllerChange(3, note, value);
    }
    case 4:{
      batuta.sendControllerChange(4, note, value);
    }
  }
}


void draw() {
  
  switch(state){
    case 0:{
      
      tela0();
      
      break;
    }
    case 1:{
      background(0);
      
      h1("Olá, sou a Freviana, a inteligência artificial por trás do Batuta.", 20, width/2, height/2 -200);
      h1("Percebi que você se interessou pelo TROMPETE.", 20, width/2, height/2 -170);
      h1("Com a ajuda do Paço do Frevo compus um frevo único,", 20, width/2, height/2 -140);
      h1("mas como sou feita apenas de bits preciso da sua ajuda para tocá-lo.", 20, width/2, height/2 -110);
        
      //myBus.list();
      //mainDraw(width/2, height/2, 60);
      for(int i = 0; i < freviana1_2.bufferSize() - 1; i++)
        {
          line(i, height/2 -50   + freviana1_2.left.get(i)*50,  i+1, height/2-50  + freviana1_2.left.get(i+1)*50);
          line(i, height/2 + + freviana1_2.right.get(i)*50, i+1, height/2 + freviana1_2.right.get(i+1)*50);
        }
      
//int x, int y, int scale, float midi, int R, int G, int B, float variableMM, float variableNN1, float variableNN2, float variableNN3
      instrument(width/2-300, height/2+200, 75, instruments.get(0), 0, 0, 255, 2, map(instruments.get(0), 0,127,0.1,2), 0.5, 0.5);
      instrument(width/2-100, height/2+200, 40, instruments.get(1), 0, 255, 0, 3, map(instruments.get(1), 0,127,4,16), 10, 10);
      
      instrument(width/2+100, height/2+200, 40, instruments.get(2) , 255, 0, 255, 4, map(instruments.get(2), 0,127,4,7), 15, 15);
      instrument(width/2+300, height/2+200, 40, instruments.get(3), 255, 255, 255, 5,map(instruments.get(3), 0,127,4,16), 10, 10);
      
      if (freviana1_2.isPlaying()==false) {
        if (played){
          state = 2;
          played = false;
        }else{
          freviana1_2.play();
          played =true;
        }
      }       
      //state = 1;
      break;
    }
    case 2:{
      background(bg);
      textAlign(CENTER);
      h1("Agora, chegou a hora de juntar a orquestra e afinar os instrumentos.", 20 ,width/2, 80);
      h1("Quanto mais rápido você balancar, mais alto o volume do seu intrumento será!", 20 ,width/2, 120);
      for(int i = 0; i < freviana2_1.bufferSize() - 1; i++)
        {
          line(i, height/2 -50   + freviana2_1.left.get(i)*50,  i+1, height/2-50  + freviana1_2.left.get(i+1)*50);
          line(i, height/2 + + freviana2_1.right.get(i)*50, i+1, height/2 + freviana1_2.right.get(i+1)*50);
        }
        
      instrument(width/2-300, height/2+200, 75, instruments.get(0), 0, 0, 255, 2, map(instruments.get(0), 0,127,0.1,2), 0.5, 0.5);
      instrument(width/2-100, height/2+200, 40, instruments.get(1), 0, 255, 0, 3, map(instruments.get(1), 0,127,4,16), 10, 10);
      
      instrument(width/2+100, height/2+200, 40, instruments.get(2) , 255, 0, 255, 4, map(instruments.get(2), 0,127,4,7), 15, 15);
      instrument(width/2+300, height/2+200, 40, instruments.get(3), 255, 255, 255, 5,map(instruments.get(3), 0,127,4,16), 10, 10);

      
      if (freviana2_1.isPlaying()==false) {
        if (played){
          println("cronometro");
          background(bg);
          textAlign(CENTER);
          h1("Agora, chegou a hora de juntar a orquestra e afinar os instrumentos.", 20 ,width/2, 80);
          h1("Quanto mais rápido você balancar, mais alto o volume do seu intrumento será!", 20 ,width/2, 120);
          cronometro();
          instrument(width/2-300, height/2+200, 75, instruments.get(0), 0, 0, 255, 2, map(instruments.get(0), 0,127,0.1,2), 0.5, 0.5);
          instrument(width/2-100, height/2+200, 40, instruments.get(1), 0, 255, 0, 3, map(instruments.get(1), 0,127,4,16), 10, 10);
          
          instrument(width/2+100, height/2+200, 40, instruments.get(2) , 255, 0, 255, 4, map(instruments.get(2), 0,127,4,7), 15, 15);
          instrument(width/2+300, height/2+200, 40, instruments.get(3), 255, 255, 255, 5,map(instruments.get(3), 0,127,4,16), 10, 10);
          

        }else{
          println("play freviana");
          freviana2_1.play();
          played =true;
          begin = millis()/1000+10;
        }
      }   
      
      break;
    }case 3:{
      background(bg);
    
    }
    
    
  }
  

}

void h1(String texto, float size , int x, int y){
  beginShape();
  textSize(size);
  textAlign(CENTER);
  text(texto, x, y);
  fill(100,100,100);
  
  endShape();
}

void playSolos(){
  //saxValue = 0 , tromboneValue = 1, trompeteValue=2 ,percussaoValue=3, batutaValue=4 ;
  if (soloBateria.isPlaying()) {
    println("Estou aqui");
    println(instruments.get(3));
    soloSax.setGain(map(instruments.get(0),0,127,-50,10));
    soloTrombone.setGain(map(instruments.get(1),0,127,-50,10));
    soloTrompete.setGain(map(instruments.get(2),0,127,-50,10));
    soloBateria.setGain(map(instruments.get(3),0,127,-50,10));
    
  }else {
    soloBateria.play();
    soloBateria.setGain(-13);
    soloSax.play();
    soloSax.setGain(-13);
    soloTrompete.play();
    soloTrompete.setGain(-13);
    soloTrombone.play();
    soloTrombone.setGain(-13);  
  }
  
}

void loadSolos(){
  println("loadfiles");
  soloBateria = minim.loadFile("solo_bateria.wav", 1024);
  soloSax = minim.loadFile("solo_sax.wav", 1024);
  soloTrompete = minim.loadFile("solo_trompete.wav", 1024);
  soloTrombone = minim.loadFile("solo_trombone.wav", 1024);
  println(soloBateria);

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
      delay(500);
      state = 3;
      
    }
    textSize(40); 
    text(time, width/2, height/2);
  
  endShape();
}

void mainDraw(int x, int y, int scale){
//desenho principal
  beginShape();
  pushMatrix();
  smooth();
  noFill();
  stroke(255, 100, 250);
  translate(x, y); // posição

  float newscaler0 = scale;
  for (int s = 8; s > 0; s--) {  
    
  
    //float mm = m + s;
    //float nn1 = n1 + s;
    //float nn2 = mouseY + s;
    //float nn3 = mouseX/100 + s;
    float mm = m + s; //qtd de pontas
    float nn1 = random(0,5); // variableNN1;
    float nn2 = n2 + s; // ponta esquerda
    float nn3 = n3 + s; // ponta direita
    
    newscaler0 = newscaler0 * 0.95;
    float sscaler = newscaler0;
    
    //println ("mm-> " + mm, " nn1 -> "+nn1+" nn2 -> "+ nn2+"nn3 ->"+nn3+" newscaler-> "+newscaler0);

    PVector[] points = superformula(mm, nn1, nn2, nn3);
    
    curveVertex(points[points.length-1].x * sscaler, points[points.length-1].y * sscaler);
    
    for (int i = 0;i < points.length; i++) {
      //stroke(255, 0, 0);
      curveVertex(points[i].x * sscaler, points[i].y * sscaler);
      
    }
    //curveVertex(points[0].x * sscaler, points[0].y * sscaler);
    curveVertex(points[0].x * sscaler, points[0].y * sscaler);
    
  }
  endShape();
  popMatrix();

}

//int x, int y, int scale, float midi, int R, int G, int B, float variableMM, float variableNN1, float variableNN2, float variableNN3
void instrument(int x, int y, int scale, float midi, int R, int G, int B, float variableMM, float variableNN1, float variableNN2, float variableNN3){
//desenho 0
  beginShape();
  pushMatrix();
  stroke(R, G, B);
  smooth();
  noFill();
  translate(x , y); // posição

  float newscaler = scale;
  for (int s = 5; s > 0; s--) {  

  
    //float mm = m + s;
    //float nn1 = n1 + s;
    //float nn2 = mouseY + s;
    //float nn3 = mouseX/100 + s;
    float mm = variableMM; //qtd de pontas
    float nn1 = variableNN1*random(0.9,1.1); // variableNN1
    float nn2 = variableNN2; // ponta esquerda
    float nn3 = variableNN3; // ponta direita
    
    newscaler = newscaler * 0.95;
    float sscaler = newscaler;
    
    //println ("mm-> " + mm, " nn1 -> "+nn1+" nn2 -> "+ nn2+"nn3 ->"+nn3+" newscaler-> "+newscaler);

    PVector[] points = superformula(mm, nn1, nn2, nn3);
    curveVertex(points[points.length-1].x * sscaler, points[points.length-1].y * sscaler);
    for (int i = 0;i < points.length; i++) {
      curveVertex(points[i].x * sscaler, points[i].y * sscaler);
    }
    //curveVertex(points[0].x * sscaler, points[0].y * sscaler);
    curveVertex(points[0].x * sscaler, points[0].y * sscaler);
    
  }
  endShape();
  popMatrix();
  
}

void tela0(){
  beginShape();
  background(255,0,0);
  textSize(40);
  textAlign(CENTER);
  text("Experimente o Frevo com", width/2, height/2-100);
  fill(100,100,100);
  endShape();
  beginShape();
  textSize(20);
  text("Balance um intrumento para iniciar a intetração", width/2-150, height/2+150);
  endShape();
  
  image(logo, width/2-180, height/2-60);
  image(softex, width/2+50, height-75, 130, 60);
  image(ibm, width/2+200, height-75, 80, 70);
  image(paco, width/2+300, height-80, 50,70);
  
}

PVector[] superformula(float m,float n1,float n2,float n3) {
  int numPoints = 360;
  float phi = TWO_PI / numPoints;
  PVector[] points = new PVector[numPoints+1];
  for (int i = 0;i <= numPoints;i++) {
    points[i] = superformulaPoint(m,n1,n2,n3,phi * i);
  }
  return points;
}

PVector superformulaPoint(float m,float n1,float n2,float n3,float phi) {
  float r;
  float t1,t2;
  float a=1,b=1;
  float x = 0;
  float y = 0;

  t1 = cos(m * phi / 4) / a;
  t1 = abs(t1);
  t1 = pow(t1,n2);

  t2 = sin(m * phi / 4) / b;
  t2 = abs(t2);
  t2 = pow(t2,n3);

  r = pow(t1+t2,1/n1);
  if (abs(r) == 0) {
    x = 0;
    y = 0;
  }  
  else {
    r = 1 / r;
    x = r * cos(phi);
    y = r * sin(phi);
  }

  return new PVector(x, y);
}