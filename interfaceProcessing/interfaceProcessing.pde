import themidibus.*; //Import the library
import ddf.minim.*;
import ddf.minim.analysis.*;

 
AudioPlayer song;
FFT fft;

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

//Config. para cubos

// Variables qui définissent les "zones" du spectre
// Par exemple, pour les basses, on prend seulement les premières 4% du spectre total
float specLow = 0.3; // 3%
float specMid = 0.20;  // 12.5%
float specHi = 0.50;   // 20%

// Il reste donc 64% du spectre possible qui ne sera pas utilisé. 
// Ces valeurs sont généralement trop hautes pour l'oreille humaine de toute facon.

// Valeurs de score pour chaque zone
float scoreLow = 0;
float scoreMid = 0;
float scoreHi = 0;

// Valeur précédentes, pour adoucir la reduction
float oldScoreLow = scoreLow;
float oldScoreMid = scoreMid;
float oldScoreHi = scoreHi;

// Valeur d'adoucissement
float scoreDecreaseRate = 25;

// Cubes qui apparaissent dans l'espace
int nbCubes;
Cube[] cubes;

//Lignes qui apparaissent sur les cotés
int nbMurs = 500;
Mur[] murs;
 
//MidiBus sax; 

float bandValue ;
float shake;

void setup() {
  //Load cubos
  time = "10";
  cont = 10;
  interval = 1000;//one second
  bg = color (0);
  begin = 0;
  //Faire afficher en 3D sur tout l'écran
  //fullScreen(P3D);
 
  //Charger la librairie minim
  minim = new Minim(this);
 
  //Charger la chanson
  song = minim.loadFile("frevo.mp3");
  
  //Créer l'objet FFT pour analyser la chanson
  fft = new FFT(song.bufferSize(), song.sampleRate());
  
  //Un cube par bande de fréquence
  //nbCubes = (int)(fft.specSize()*specHi);
  nbCubes = 0;
  cubes = new Cube[nbCubes];
  
  //Autant de murs qu'on veux
  murs = new Mur[nbMurs];

  //Créer tous les objets
  //Créer les objets cubes
  for (int i = 0; i < nbCubes; i++) {
   cubes[i] = new Cube(); 
  }
  
  //Créer les objets murs
  //Murs gauches
  for (int i = 0; i < nbMurs; i+=4) {
   murs[i] = new Mur(-20, height/2, 10, height); 
  }
  
  //Murs droits
  for (int i = 1; i < nbMurs; i+=4) {
   murs[i] = new Mur(width+20, height/2, 10, height); 
  }
  
  //Murs bas
  for (int i = 2; i < nbMurs; i+=4) {
   murs[i] = new Mur(width/2, height+20, width, 10); 
  }
  
  //Murs haut
  for (int i = 3; i < nbMurs; i+=4) {
   murs[i] = new Mur(width/2, 0, width, 10); 
  }
  
  //Fond noir
  background(bg);
  

  
  
  // Load audios,
  minim = new Minim(this);
  loadSolos();
  freviana1_2 = minim.loadFile("freviana_1_2.mp3",2048);
  freviana2_1 = minim.loadFile("freviana_2_1.mp3",2048);
  
  freviana1_2.rewind();
  freviana2_1.rewind();
  played = false;


  //saxValue = 0 , tromboneValue = 1, trompeteValue=2 ,percussaoValue=3, batutaValue=4 ;
  instruments = new IntList(0,0,0,0,0);

  //fullScreen();
  size(800,600,P3D);
  smooth();
  noFill();
  state = 0;
  // sax, trombone,trompete, percussao, batuta; 
  //sax = new MidiBus(this, 1, -1,"0");
  //trombone = new MidiBus(this, 0, 4,"1");
  trompete = new MidiBus(this, 1, 5,"2");
  percussao = new MidiBus(this, 0, 5,"3");
  //batuta = new MidiBus(this, 0, 4,"4");
  
  
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
      break;
    }
    case 3:{
      instruments.set(channel,value);
      sendAbleton(channel, number, value);
      break;
    }
  } 
}

void sendAbleton(int intrumento,int note, int value){
    //saxValue = 0 , tromboneValue = 1, trompeteValue=2 ,percussaoValue=3, batutaValue=4 ;
  switch(intrumento){
    case 0:{
      //sax.sendControllerChange(0, note, value);
      //errado
      trompete.sendControllerChange(2,note,value);
      break;
    }
    case 1:{
      //trombone.sendControllerChange(1, note, value);
      break;
    }
    case 2:{
      //trompete.sendControllerChange(2, note,value);
      break;
    }
    case 3:{
      percussao.sendControllerChange(3, note, value);
      break;
    }
    case 4:{
      //batuta.sendControllerChange(4, note, value);
      break;
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
      
      h1("Olá, sou a Freviana, a inteligência artificial por trás do Batuta.", 40, width/2, 40);
      h1("Percebi que você se interessou pelo TROMPETE.", 40, width/2, 100);
      h1("Com a ajuda do Paço do Frevo compus um frevo único,", 40, width/2, 160);
      h1("mas como sou feita apenas de bits preciso da sua ajuda para tocá-lo.", 40, width/2, 220);
        
      //myBus.list();
      //mainDraw(width/2, height/2, 60);
      for(int i = 0; i < freviana1_2.bufferSize() - 1; i++)
        {
          beginShape();
          fill(225);
          line(i, height/2 -50   + freviana1_2.left.get(i)*50,  i+1, height/2-50  + freviana1_2.left.get(i+1)*50);
          line(i, height/2 + + freviana1_2.right.get(i)*50, i+1, height/2 + freviana1_2.right.get(i+1)*50);
          endShape();
        }
      
//int x, int y, int scale, float midi, int R, int G, int B, float variableMM, float variableNN1, float variableNN2, float variableNN3
      instrument(width/2-300, height/2+200, 75, instruments.get(0), 237, 28, 36, 2, map(instruments.get(0), 0,127,0.1,2), 0.5, 0.5);
      instrument(width/2-100, height/2+200, 75, instruments.get(1), 255, 230, 0, 2, map(instruments.get(1), 0,127,0.1,2), 0.5, 0.5);
      
      instrument(width/2+100, height/2+200, 75, instruments.get(2), 0, 0, 179, 2, map(instruments.get(2), 0,127,0.1,2), 0.5, 0.5);
      instrument(width/2+300, height/2+200, 75, instruments.get(3), 7, 156, 66, 2, map(instruments.get(3), 0,127,0.1,2), 0.5, 0.5);         
      
      println("tocacndo " + freviana1_2.isPlaying());
      println("played " + played);
      if (freviana1_2.isPlaying()==false) {
        if (played){
          state = 2;
          played = false;
        }else{
          freviana1_2.play();
          freviana1_2.setGain(-20);
          played =true;
        }
      }       
      //state = 1;
      break;
    }
    case 2:{
      background(bg);
      textAlign(CENTER);
      h1("Agora, chegou a hora,", 40 ,width/2, 40);
      h1("de juntar a orquestra e afinar os instrumentos.", 40 ,width/2, 100);
      h1("Quanto mais rápido você balancar,", 40 ,width/2, 160);
      h1("mais alto o volume do seu intrumento será!", 40 ,width/2, 220);
      for(int i = 0; i < freviana2_1.bufferSize() - 1; i++)
        {
          beginShape();
          line(i, height/2 -50   + freviana2_1.left.get(i)*50,  i+1, height/2-50  + freviana2_1.left.get(i+1)*50);
          line(i, height/2 + + freviana2_1.right.get(i)*50, i+1, height/2 + freviana2_1.right.get(i+1)*50);
          fill(225);
          endShape();
        }
      
//int x, int y, int scale, float midi, int R, int G, int B, float variableMM, float variableNN1, float variableNN2, float variableNN3
      instrument(width/2-300, height/2+200, 75, instruments.get(0), 237, 28, 36, 2, map(instruments.get(0), 0,127,0.1,2), 0.5, 0.5);
      instrument(width/2-100, height/2+200, 75, instruments.get(1), 255, 230, 0, 2, map(instruments.get(1), 0,127,0.1,2), 0.5, 0.5);
      
      instrument(width/2+100, height/2+200, 75, instruments.get(2), 0, 0, 179, 2, map(instruments.get(2), 0,127,0.1,2), 0.5, 0.5);
      instrument(width/2+300, height/2+200, 75, instruments.get(3), 7, 156, 66, 2, map(instruments.get(3), 0,127,0.1,2), 0.5, 0.5);    
      
      if (freviana2_1.isPlaying()==false) {
        if (played){
          println("cronometro");
          background(bg);
          textAlign(CENTER);
          h1("Agora, chegou a hora,", 40 ,width/2, 40);
          h1("de juntar a orquestra e afinar os instrumentos.", 40 ,width/2, 100);
          h1("Quanto mais rápido você balancar,", 40 ,width/2, 160);
          h1("mais alto o volume do seu intrumento será!", 40 ,width/2, 220);
          cronometro();
          instrument(width/2-300, height/2+200, 75, instruments.get(0), 237, 28, 36, 2, map(instruments.get(0), 0,127,0.1,2), 0.5, 0.5);
          instrument(width/2-100, height/2+200, 75, instruments.get(1), 255, 230, 0, 2, map(instruments.get(1), 0,127,0.1,2), 0.5, 0.5);
          
          instrument(width/2+100, height/2+200, 75, instruments.get(2), 0, 0, 179, 2, map(instruments.get(2), 0,127,0.1,2), 0.5, 0.5);
          instrument(width/2+300, height/2+200, 75, instruments.get(3), 7, 156, 66, 2, map(instruments.get(3), 0,127,0.1,2), 0.5, 0.5);              

        }else{
          println("play freviana");
          freviana2_1.play();
          freviana2_1.setGain(-20);
          played =true;
          begin = millis()/1000+10;
        }
      }   
      
      break;
    }case 3:{
      cubos();
      break;
    }    
  }
}

void h1(String texto, float size , int x, int y){
  beginShape();
  textSize(size);
  textAlign(CENTER);
  text(texto, x, y);
  fill(255);
  
  endShape();
}

void playSolos(){
  //saxValue = 0 , tromboneValue = 1, trompeteValue=2 ,percussaoValue=3, batutaValue=4 ;
  println(soloBateria.isPlaying());
  if (soloBateria.isPlaying()) {
    println("Estou aqui");
    println(instruments.get(3));
    soloSax.setGain(map(instruments.get(0),0,127,-50,10));
    soloTrombone.setGain(map(instruments.get(1),0,127,-50,10));
    soloTrompete.setGain(map(instruments.get(2),0,127,-50,10));
    soloBateria.setGain(map(instruments.get(3),0,127,-50,0));
    
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
  soloBateria = minim.loadFile("solo_bateria.mp3", 1024);
  soloSax = minim.loadFile("solo_sax.mp3", 1024);
  soloTrompete = minim.loadFile("solo_trompete.mp3", 1024);
  soloTrombone = minim.loadFile("solo_trombone.mp3", 1024);
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
      delay(100);
      //setup();
      state = 3;
      
    }
    textSize(60); 
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
    float nn1 = variableNN1; // variableNN1
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
  background(bg);
  textSize(50);
  textAlign(CENTER);
  text("Experimente o Frevo com", width/2, height/2-100);
  fill(255);
  endShape();
  beginShape();
  textSize(30);
  text("Balance um intrumento para iniciar a intetração", width/2, height/2+150);
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

//Cubos

//funcao para desenhar os cubos e linhas - antigo draw
void cubos(){
  //Faire avancer la chanson. On draw() pour chaque "frame" de la chanson...
    //Commencer la chanson
  song.play();
  //song.mute();

  fft.forward(song.mix);
  
  //Calcul des "scores" (puissance) pour trois catégories de son
  //D'abord, sauvgarder les anciennes valeurs
  oldScoreLow = scoreLow;
  oldScoreMid = scoreMid;
  oldScoreHi = scoreHi;
  
  //Réinitialiser les valeurs
  scoreLow = 0;
  scoreMid = 0;
  scoreHi = 0;
 
  //Calculer les nouveaux "scores"
  for(int i = 0; i < fft.specSize()*specLow; i++)
  {
    scoreLow += fft.getBand(i);
  }
  
  for(int i = (int)(fft.specSize()*specLow); i < fft.specSize()*specMid; i++)
  {
    scoreMid += fft.getBand(i);
  }
  
  for(int i = (int)(fft.specSize()*specMid); i < fft.specSize()*specHi; i++)
  {
    scoreHi += fft.getBand(i);
  }
  
  //Faire ralentir la descente.
  if (oldScoreLow > scoreLow) {
    scoreLow = oldScoreLow - scoreDecreaseRate;
  }
  
  if (oldScoreMid > scoreMid) {
    scoreMid = oldScoreMid - scoreDecreaseRate;
  }
  
  if (oldScoreHi > scoreHi) {
    scoreHi = oldScoreHi - scoreDecreaseRate;
  }
   
  //Volume pour toutes les fréquences à ce moment, avec les sons plus haut plus importants.
  //Cela permet à l'animation d'aller plus vite pour les sons plus aigus, qu'on remarque plus
  float scoreGlobal = 0.66*scoreLow + 0.8*scoreMid + 1*scoreHi;
  
  //Couleur subtile de background
  background(scoreLow/100, scoreMid/100, scoreHi/100);
   
  //Cube pour chaque bande de fréquence
  for(int i = 0; i < nbCubes; i++)
  {
    //Valeur de la bande de fréquence
    float bandValue = fft.getBand(i);
    
    //La couleur est représentée ainsi: rouge pour les basses, vert pour les sons moyens et bleu pour les hautes. 
    //L'opacité est déterminée par le volume de la bande et le volume global.
    cubes[i].display(scoreLow, scoreMid, scoreHi, bandValue, scoreGlobal);
  }
  
  //Murs lignes, ici il faut garder la valeur de la bande précédent et la suivante pour les connecter ensemble
  float previousBandValue = fft.getBand(0);
  
  //Distance entre chaque point de ligne, négatif car sur la dimension z
  //float dist = -25;
  float dist = -25;
  
  //Multiplier la hauteur par cette constante
  float heightMult = 2;

    //    //Murs rectangles
  for(int i = 0; i < nbMurs; i++)
  {
    //On assigne à chaque mur une bande, et on lui envoie sa force.
    float intensity = 50+fft.getBand(i%((int)(fft.specSize()*specHi)));
    murs[i].display(scoreLow, scoreMid, scoreHi, intensity, scoreGlobal);
  } 
  
  delay(100);
  //Pour chaque bande
  for(int i = 1; i < fft.specSize(); i++)
  {
    //Valeur de la bande de fréquence, on multiplie les bandes plus loins pour qu'elles soient plus visibles.
    float bandValue1 = fft.getBand(i)*(1 + (i/50));
    println("intruments 3 "+ instruments.get(3));
    float bandValue = bandValue1*map(instruments.get(3),0,127,0.0,1.8); // pegando o valor do midi
       
    println("band value " + bandValue);
    //Selection de la couleur en fonction des forces des différents types de sons
    stroke(100+scoreLow, 100+scoreMid, 100+scoreHi, 255-i);
    strokeWeight(1 + (scoreGlobal/100));
    
    //ligne inferieure gauche
    line(0, height-(previousBandValue*heightMult), dist*(i-1), 0, height-(bandValue*heightMult), dist*i);  // vertical
    line((previousBandValue*heightMult), height, dist*(i-1), (bandValue*heightMult), height, dist*i); // horizontal
    line(0, height-(previousBandValue*heightMult), dist*(i-1), (bandValue*heightMult), height, dist*i); // diagonal
    
    //ligne superieure gauche  line(x1, y1, z1, x2, y2, z2)
    line(width/2-200, height-(previousBandValue*heightMult), dist*(i-1), width/2-200, height-(bandValue*heightMult), dist*i);
    line((previousBandValue*heightMult)+width/2-200, height, dist*(i-1), (bandValue*heightMult)+width/2-200, height, dist*i);
    line(width/2-200, height-(previousBandValue*heightMult), dist*(i-1), (bandValue*heightMult)+width/2-200, height, dist*i);
    
    //ligne inferieure droite
    line(width, height-(previousBandValue*heightMult), dist*(i-1), width, height-(bandValue*heightMult), dist*i);
    line(width-(previousBandValue*heightMult), height, dist*(i-1), width-(bandValue*heightMult), height, dist*i);
    line(width, height-(previousBandValue*heightMult), dist*(i-1), width-(bandValue*heightMult), height, dist*i);
    
    //ligne superieure droite
    line(width/2+200, height-(previousBandValue*heightMult), dist*(i-1), width/2+200, height-(bandValue*heightMult), dist*i);
    line(width/2+200-(previousBandValue*heightMult), height, dist*(i-1), width/2+200-(bandValue*heightMult), height, dist*i);
    line(width/2+200, height-(previousBandValue*heightMult), dist*(i-1), width/2+200-(bandValue*heightMult),height, dist*i);
    
    //Sauvegarder la valeur pour le prochain tour de boucle
    previousBandValue = bandValue;

  }
  
 


}

//Classe pour les cubes qui flottent dans l'espace
class Cube {
  //Position Z de "spawn" et position Z maximale
  float startingZ = -10000;
  float maxZ = 1000;
  
  //Valeurs de positions
  float x, y, z;
  float rotX, rotY, rotZ;
  float sumRotX, sumRotY, sumRotZ;
  
  //Constructeur
  Cube() {
    //Faire apparaitre le cube à un endroit aléatoire
    x = random(0, width);
    y = random(0, height);
    z = random(startingZ, maxZ);
    
    //Donner au cube une rotation aléatoire
    rotX = random(0, 1);
    rotY = random(0, 1);
    rotZ = random(0, 1);
  }
  
  void display(float scoreLow, float scoreMid, float scoreHi, float intensity, float scoreGlobal) {
    //Sélection de la couleur, opacité déterminée par l'intensité (volume de la bande)
    color displayColor = color(scoreLow*0.67, scoreMid*0.67, scoreHi*0.67, intensity*5);
    fill(displayColor, 255);
    
    //Couleur lignes, elles disparaissent avec l'intensité individuelle du cube
    color strokeColor = color(255, 150-(20*intensity));
    stroke(strokeColor);
    strokeWeight(1 + (scoreGlobal/300));
    
    //Création d'une matrice de transformation pour effectuer des rotations, agrandissements
    pushMatrix();
    
    //Déplacement
    translate(x, y, z);
    
    //Calcul de la rotation en fonction de l'intensité pour le cube
    sumRotX += intensity*(rotX/1000);
    sumRotY += intensity*(rotY/1000);
    sumRotZ += intensity*(rotZ/1000);
    
    //Application de la rotation
    rotateX(sumRotX);
    rotateY(sumRotY);
    rotateZ(sumRotZ);
    
    //Création de la boite, taille variable en fonction de l'intensité pour le cube
    //box(100+(intensity/2));
    //line(width/2,height/2,width/2,height/2);
    image(logo, random(1,width), random(0, height/2));
    
    //Application de la matrice
    popMatrix();
    
    //Déplacement Z
    z+= (1+(intensity/5)+(pow((scoreGlobal/150), 2)));
    
    //Replacer la boite à l'arrière lorsqu'elle n'est plus visible
    if (z >= maxZ) {
      x = random(0, width);
      y = random(0, height);
      z = startingZ;
    }
  }
}


//Classe pour afficher les lignes sur les cotés
class Mur {
  //Position minimale et maximale Z
  float startingZ = -10000;
  float maxZ = -100;
  
  //Valeurs de position
  float x, y, z;
  float sizeX, sizeY;
  
  //Constructeur
  Mur(float x, float y, float sizeX, float sizeY) {
    //Faire apparaitre la ligne à l'endroit spécifié
    this.x = x;
    this.y = y;
    //Profondeur aléatoire
    this.z = random(startingZ, maxZ);  
    
    //On détermine la taille car les murs au planchers ont une taille différente que ceux sur les côtés
    this.sizeX = sizeX;
    this.sizeY = sizeY;
  }
  
  //Fonction d'affichage
  void display(float scoreLow, float scoreMid, float scoreHi, float intensity, float scoreGlobal) {
    //Couleur déterminée par les sons bas, moyens et élevé
    //Opacité déterminé par le volume global
    color displayColor = color(scoreLow*0.67, scoreMid*0.67, scoreHi*0.67, scoreGlobal);
    
    //Faire disparaitre les lignes au loin pour donner une illusion de brouillard
    fill(displayColor, ((scoreGlobal-5)/1000)*(255+(z/25)));
    noStroke();
    
    //Première bande, celle qui bouge en fonction de la force
    //Matrice de transformation
    pushMatrix();
    
    //Déplacement
    translate(x, y, z);
    
    //Agrandissement
    if (intensity > 100) intensity = 100;
    scale(sizeX*(intensity/100), sizeY*(intensity/100), 20);
    
    //Création de la "boite"
    box(1);
    popMatrix();
    
    //Deuxième bande, celle qui est toujours de la même taille
    displayColor = color(scoreLow*0.5, scoreMid*0.5, scoreHi*0.5, scoreGlobal);
    fill(displayColor, (scoreGlobal/5000)*(255+(z/25)));
    //Matrice de transformation
    pushMatrix();
    
    //Déplacement
    translate(x, y, z);
    
    //Agrandissement
    scale(sizeX, sizeY, 10);
    
    //Création de la "boite"
    box(1);
    popMatrix();
    
    //Déplacement Z
    z+= (pow((scoreGlobal/150), 2));
    if (z >= maxZ) {
      z = startingZ;  
    }
  }
}