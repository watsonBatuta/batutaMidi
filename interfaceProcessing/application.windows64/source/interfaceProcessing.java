import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import themidibus.*; 
import ddf.minim.*; 
import ddf.minim.analysis.*; 
import gifAnimation.*; 
import gifAnimation.*; 
import processing.serial.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class interfaceProcessing extends PApplet {

 //Import the library





AudioPlayer song;
FFT fft;

//fft para instrumentos
FFT fft_sax, fft_trompete, fft_trombone, fft_bateria;

//saxValue = 0 , tromboneValue = 1, trompeteValue=2 ,percussaoValue=3, batutaValue=4 ;
MidiBus sax, trompete, trombone, percussao, batuta, ableton; // The MidiBus

float scaler = 75;
int m = 2;
float n1 = 18;
float n2 = 1;
float n3 = 1;
IntList instruments;
//audios para fase de apresenta\u00e7\u00e3o (Afina\u00e7\u00e3o)
AudioPlayer soloBateria, soloSax, soloTrompete, soloTrombone;
//audios para as linhas
AudioPlayer song_bateria, song_sax, song_trompete, song_trombone;



Minim minim;//audio context
boolean played;
String instrumento;


int bg = color (0);
int begin = 0;

int state;

PImage logo, softex, ibm, paco, louco;
Gif ai;
//Config. para cubos

// Variables qui d\u00e9finissent les "zones" du spectre
// Par exemple, pour les basses, on prend seulement les premi\u00e8res 4% du spectre total
float specLow = 0.3f; // 0.3%
float specMid = 0.20f;  // 0.2%
float specHi = 0.50f;   // 0.5

// Il reste donc 64% du spectre possible qui ne sera pas utilis\u00e9. 
// Ces valeurs sont g\u00e9n\u00e9ralement trop hautes pour l'oreille humaine de toute facon.

// Valeurs de score pour chaque zone
float scoreLow = 0;
float scoreMid = 0;
float scoreHi = 0;

// Valeur pr\u00e9c\u00e9dentes, pour adoucir la reduction
float oldScoreLow = scoreLow;
float oldScoreMid = scoreMid;
float oldScoreHi = scoreHi;

// Valeur d'adoucissement
float scoreDecreaseRate = 25;

// Cubes qui apparaissent dans l'espace
int nbCubes;
Cube[] cubes;

//Lignes qui apparaissent sur les cot\u00e9s
int nbMurs = 500;
Mur[] murs;
 
//MidiBus sax; 

float bandValue ;
float shake;

int instrumentoAtual;



public void setup() {
  //Load cubos
  time = "10";
  cont = 10;
  interval = 1000;//one second
  bg = color (0);
  begin = 0;
  
  textfadesin = true;
  fadeout = 255;
  fadein = -100;
  fimAnimacao = false;
  i = 0;
  first = true;
  contInstrumento = 0;
  
  createFont();
  

  
  //Faire afficher en 3D sur tout l'\u00e9cran
  //
 
  //Charger la librairie minim
  minim = new Minim(this);  
  
  // Carregando os sons dos instrumentos
  loadAudios();
  
   //carregando fft para linhas de audios
  loadFft();
  
  //tocando todos os instrumentos para realizar itera\u00e7\u00e3o com as linhas 
  
 
   
  ////Cr\u00e9er l'objet FFT pour analyser la chanson
  //fft = new FFT(song.bufferSize(), song.sampleRate());
  
  //Un cube par bande de fr\u00e9quence
  //nbCubes = (int)(fft.specSize()*specHi);
  nbCubes = 20;
  cubes = new Cube[nbCubes];
  
  //Autant de murs qu'on veux
  murs = new Mur[nbMurs];

  //Cr\u00e9er tous les objets
  //Cr\u00e9er les objets cubes
  for (int i = 0; i < nbCubes; i++) {
   cubes[i] = new Cube(); 
  }
  
  //Cr\u00e9er les objets murs
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
  //minim = new Minim(this);
  loadSolos();

  loadFrevianaFiles();
  
  played = false;

  //saxValue = 0 , tromboneValue = 1, trompeteValue=2 ,percussaoValue=3, batutaValue=4 ;
  instruments = new IntList(0,0,0,0,0);

  fullScreen(P3D);
  //size(1366,768,P3D);

  
  noFill();
  state = 0;
  // sax, trombone,trompete, percussao, batuta; 
  //sax = new MidiBus(this, 0, -1,"0");
  //trombone = new MidiBus(this, 3, -1,"1");
  //trompete = new MidiBus(this, 2, -1,"2");
  //percussao = new MidiBus(this, 1, -1,"3");
  ableton = new MidiBus(this, -1, "Ableton", "5");
  createSerial();
  
  ableton.sendNoteOn(2,8,127);
  ableton.sendNoteOff(2,8,127);
  ableton.sendNoteOn(2,8,127);
  ableton.sendNoteOff(2,8,127);
  
  //batuta = new MidiBus(this, 0, 4,"4");

  sax.list();
  
  logo = loadImage("logoBatuta.png");
  softex = loadImage("logoSoftex.png");
  ibm = loadImage("logoIBM.png");
  paco = loadImage("logoPaco.png");
  louco = loadImage("louco.png");
  ai = new Gif(this, "ai_gif.gif");
  ai.loop();
  loadGif();
  //frameRate(10);
  
}

public void again(){
  
  delay(10000);
  time = "10";
  cont = 10;
  interval = 1000;//one second
  bg = color (0);
  begin = 0;

  textfadesin = true;
  fadeout = 255;
  fadein = -100;
  fimAnimacao = false;
  i = 0;
  first = true;
  contInstrumento = 0;

  played = false;

  state = 0;

  ableton.sendNoteOn(2,8,127);
  ableton.sendNoteOff(2,8,127);
  ableton.sendNoteOn(2,8,127);
  ableton.sendNoteOff(2,8,127);
  
  rewindAudio();

}

public void draw() {
 
  readSerial();
  
  switch(state){
    case 0:{
      //bem vindo batuta
      tela0();      
      break;
    }
    case 1:{
      //apresenta\u00e7\u00e3o da freviana
      
      tela1();
      break;
    }
    case 2:{
      //explica\u00e7\u00e3o da din\u00e2mica
      tela2();   
      break;
    }case 3:{
      //afinando os instrumentos
      tela3();
      break;
    }
    case 4:{
      //din\u00e2mica
      cubos();
      //image(ai, width/2-40 , height/2-25, 75,50);
      if(song.isPlaying()){
      }else{
        state = 5;
        played = false;
        //setup();
      }
      break;
    }
    case 5:{
      //tela do obrigado por participar
      tela4();
      break;
    }
    case 6:{
      //tela dos agradecimentos e cr\u00e9ditos
      tela5();
      //again();
      break;
    }
  }
}

AudioPlayer freviana1_0,freviana1_1,freviana1_2,freviana1_3, freviana1_4, freviana2_1, freviana2_5, freviana2, freviana3, frevianaPlayable, audioCronometro, freviana_agradecimentos, frevo_agradecimento;


public void playSolos(){
  //saxValue = 0 , tromboneValue = 1, trompeteValue=2 ,percussaoValue=3, batutaValue=4 ;
  println(soloBateria.isPlaying());
  if (soloBateria.isPlaying()) {
    println("Estou aqui");
    println(instruments.get(3));
    soloSax.setGain(map(instruments.get(0),0,127,-50,0));
    soloTrombone.setGain(map(instruments.get(1),0,127,-50,0));
    soloTrompete.setGain(map(instruments.get(2),0,127,-50,0));
    soloBateria.setGain(map(instruments.get(3),0,127,-50,-5));
    
  }else {
    soloBateria.play();
    println("begin cronometer");
    begin = millis()/1000;
    soloBateria.setGain(-13);
    soloSax.play();
    soloSax.setGain(-13);
    soloTrompete.play();
    soloTrompete.setGain(-13);
    soloTrombone.play();
    soloTrombone.setGain(-13);  
  }
  
}

public void loadSolos(){
  println("loadfiles");
  soloBateria = minim.loadFile("solo_bateria.mp3", 1024);
  soloSax = minim.loadFile("solo_sax.mp3", 1024);
  soloTrompete = minim.loadFile("solo_trompete.mp3", 1024);
  soloTrombone = minim.loadFile("solo_trombone.mp3", 1024);
  println(soloBateria);

}

public void loadFrevianaFiles(){
    freviana1_0 = minim.loadFile("1_0.mp3",2048);
    freviana1_1 = minim.loadFile("1_1.mp3",2048);
    freviana1_2 = minim.loadFile("1_2.mp3",2048);
    freviana1_3 = minim.loadFile("1_3.mp3",2048);
    freviana1_4 = minim.loadFile("1_4.mp3",2048);
    freviana2_5 = minim.loadFile("2_5.mp3", 2048);
    freviana2_1 = minim.loadFile("2_1.mp3", 2048);
    freviana2 = minim.loadFile("2_1.mp3", 2048);
    freviana3 = minim.loadFile("3.mp3", 2048);
    frevianaPlayable = minim.loadFile("1_3.mp3",2048);
    audioCronometro = minim.loadFile("cronometro.mp3",2048);
    freviana_agradecimentos = minim.loadFile("freviana_agradecimentos.mp3", 2048);
    frevo_agradecimento = minim.loadFile("temcoisanofrevocut.mp3",2048);

}

public void rewindAudio(){

  freviana1_0.rewind();
  freviana1_1.rewind();
  freviana1_2.rewind();
  freviana1_3.rewind();
  freviana1_4.rewind();
  freviana2_5.rewind();
  freviana2_1.rewind();
  freviana2.rewind();
  freviana3.rewind();
  frevianaPlayable.rewind();
  audioCronometro.rewind();
  freviana_agradecimentos.rewind();
  soloBateria.rewind();
  soloSax.rewind();
  soloTrompete.rewind();
  soloTrombone.rewind();
  song_bateria.rewind();
  song_sax.rewind();
  song_trompete.rewind();
  song_trombone.rewind();
  song.rewind();
  frevo_agradecimento.rewind();


}

// Carregando os sons dos instrumentos
public void loadAudios(){
  
  //Audio do frevo
  song = minim.loadFile("TemCoisaNoFrevo.mp3");
  
  println("load Songs");  
  song_bateria = minim.loadFile("frevo_bateria.mp3", 1024);
  song_sax = minim.loadFile("frevo_sax.mp3", 1024);
  song_trompete = minim.loadFile("frevo_trompete.mp3", 1024); 
  song_trombone = minim.loadFile("frevo_trombone.mp3", 1024);
}

// tocar sons
public void playSong(){
  
  //frevo
  song.play();
  ableton.sendNoteOn(2,7,127);
  ableton.sendNoteOff(2,7,127);
  song.mute();
  
  song_bateria.play();
  song_bateria.mute();
  
  song_sax.play();
  song_sax.mute();
  
  song_trompete.play();
  song_trompete.mute();
    
  song_trombone.play();
  song_trombone.mute();  
}

//analisar frames dos audios

public void loadFft(){
  
  //fft para analisar frevo completo
  fft = new FFT(song.bufferSize(), song.sampleRate());
  
  //Criar o objeto FFT para analisar a audios separados
  fft_sax = new FFT(song_sax.bufferSize(), song_sax.sampleRate());
  fft_trompete = new FFT(song_trompete.bufferSize(), song_trompete.sampleRate());
  fft_trombone = new FFT(song_trombone.bufferSize(), song_trombone.sampleRate());
  fft_bateria =  new FFT(song_bateria.bufferSize(), song_bateria.sampleRate());
}

//pegar 'frames' da musica
public void loadForward(){
   //'frames' da musica
   fft.forward(song.mix);
   //song.skip(50);

   
   //'frames' dos instrumentos
   fft_sax.forward(song_sax.mix);
   fft_trompete.forward(song_trompete.mix);
   fft_trombone.forward(song_trombone.mix);
   fft_bateria.forward(song_bateria.mix);
}
int timeFade = 0;
boolean textfadesin = true;
int fadeout = 255;
int fadein = -100;
boolean fimAnimacao = false;
int i = 0;
boolean first = true;
PFont font;

public void h1(String texto, float size , int x, int y){
  beginShape();
  fill(255);

  textSize(size);
  textAlign(CENTER);
  text(texto, x-600, y, 1200, height);

  
  endShape();
}

public void createFont(){
  font = createFont("computer_7.ttf", 32);
  textFont(font);

}




public void fade(String [] textos,int [] timeDelay, float size , int x, int y){
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
      
    fill(255);
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

String time = "11";
int cont = 10;
int initialTime;
int interval = 1000;//one second

public void cronometro(){
  beginShape();
    playSolos();
    
    //background(bg);
    println("time " + time);
    //println("milis "+millis());
    println("total " + str (millis() - (initialTime)));
    if (millis() - (initialTime) > interval && PApplet.parseInt(time) > 0){
      //println("inside if cronometro");
      println("time antes da conta " + begin + " / "+ (cont-PApplet.parseInt(millis()/1000))  + " / " + cont + " / " + time);
      time = nf(PApplet.parseInt(time)-1, 1);
      //time = nf(begin+(cont - int(millis()/1000)), 1);
      println("time depois da conta " +begin  + " / "+ (cont-PApplet.parseInt(millis()/1000)) + " / " +cont + " / " + time);
      initialTime = millis();
      
    }
    if(PApplet.parseInt(time) == 3){
      audioCronometro.play();
    }
    if (PApplet.parseInt(time) == 0){
      println("00000000000");
      background(bg);
      time = "";
      delay(100);
      state = 4;
      played2 = false;
      fimAnimacao = false;
      //setup();
      playSong(); 
      
    }
    textSize(60); 
    text(time, width/2, height/2);
  
  endShape();
}
float saxShake, tromboneShake, trompeteShake, percussaoShake;
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
    //Faire apparaitre le cube \u00e0 un endroit al\u00e9atoire
    x = random(0, width);
    y = random(0, height);
    z = random(startingZ, maxZ);
    
    //Donner au cube une rotation al\u00e9atoire
    rotX = random(0, 1);
    rotY = random(0, 1);
    rotZ = random(0, 1);
  }
  
  public void display(float scoreLow, float scoreMid, float scoreHi, float intensity, float scoreGlobal) {
    //S\u00e9lection de la couleur, opacit\u00e9 d\u00e9termin\u00e9e par l'intensit\u00e9 (volume de la bande)
    int displayColor = color(scoreLow*0.67f, scoreMid*0.67f, scoreHi*0.67f, intensity*5);
    fill(displayColor, 255);
    
    //Couleur lignes, elles disparaissent avec l'intensit\u00e9 individuelle du cube
    int strokeColor = color(255, 150-(20*intensity));
    stroke(strokeColor);
    strokeWeight(1 + (scoreGlobal/300));
    
    //Cr\u00e9ation d'une matrice de transformation pour effectuer des rotations, agrandissements
    pushMatrix();
    
    //D\u00e9placement
    translate(x, y, z);
    
    //Calcul de la rotation en fonction de l'intensit\u00e9 pour le cube
    sumRotX += intensity*(rotX/1000);
    sumRotY += intensity*(rotY/1000);
    sumRotZ += intensity*(rotZ/1000);
    
    //Application de la rotation
    rotateX(sumRotX);
    rotateY(sumRotY);
    rotateZ(sumRotZ);
        
    
    //Application de la matrice
    popMatrix();
    
    //D\u00e9placement Z
    z+= (1+(intensity/5)+(pow((scoreGlobal/150), 2)));
    
    //Replacer la boite \u00e0 l'arri\u00e8re lorsqu'elle n'est plus visible
    if (z >= maxZ) {
      x = random(0, width);
      y = random(0, height);
      z = startingZ;
    }
  }
}

//Cubos

//funcao para desenhar os cubos e linhas - antigo draw
public void cubos(){
  //Faire avancer la chanson. On draw() pour chaque "frame" de la chanson...
    //Commencer la chanson
  //song.play();
  ////song.mute();

  //fft.forward(song.mix);
  
  //chamar forward para os fft\u00b4s (intera\u00e7\u00e3o com as linhas)
  loadForward();
  
  
  //Calcul des "scores" (puissance) pour trois cat\u00e9gories de son
  //D'abord, sauvgarder les anciennes valeurs
  oldScoreLow = scoreLow;
  oldScoreMid = scoreMid;
  oldScoreHi = scoreHi;
  
  //R\u00e9initialiser les valeurs
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
   
  //Volume pour toutes les fr\u00e9quences \u00e0 ce moment, avec les sons plus haut plus importants.
  //Cela permet \u00e0 l'animation d'aller plus vite pour les sons plus aigus, qu'on remarque plus
  //float scoreGlobal = 0.66*scoreLow + 0.8*scoreMid + 1*scoreHi;
  float scoreGlobal = (0.66f*scoreLow + 0.8f*scoreMid + 1*scoreHi)*1.5f;
  
  //Couleur subtile de background
  background(scoreLow/100, scoreMid/100, scoreHi/100);
   
  //Cube pour chaque bande de fr\u00e9quence
  for(int i = 0; i < nbCubes; i++)
  {
    //Valeur de la bande de fr\u00e9quence
    float bandValue = fft.getBand(i);
    
    //La couleur est repr\u00e9sent\u00e9e ainsi: rouge pour les basses, vert pour les sons moyens et bleu pour les hautes. 
    //L'opacit\u00e9 est d\u00e9termin\u00e9e par le volume de la bande et le volume global.
    cubes[i].display(scoreLow, scoreMid, scoreHi, bandValue, scoreGlobal);
  }
        
   float previousBandValuePercussao = fft_bateria.getBand(0);
   float previousBandValueSax = fft_sax.getBand(0);
   float previousBandValueTrombone = fft_trombone.getBand(0);
   float previousBandValueTrompete = fft_trompete.getBand(0);
    
    
  //Distance entre chaque point de ligne, n\u00e9gatif car sur la dimension z
  //float dist = -25;
  float dist = -25;
  
  //Multiplier la hauteur par cette constantel
  float heightMult = 2;

    
  //delay(100);
  saxShake = instruments.get(0);
  //saxShake = 127;
  tromboneShake = instruments.get(1);
  trompeteShake = instruments.get(2);
  percussaoShake = instruments.get(3);
  
  for(int i = 1; i < fft.specSize(); i++)
  {
    //linha sax
    //ligne inferieure gauche
    
    float bandValueTrombone = fft_trombone.getBand(i);      
    //Selection de la couleur en fonction des forces des diff\u00e9rents types de sons
   // stroke(100+scoreLow, 100+scoreMid, 100+scoreHi, 255-i);
    stroke((2*tromboneShake)+scoreLow, (2*tromboneShake)+scoreMid, 255-tromboneShake*2, 40+tromboneShake*2);
    strokeWeight(2.5f+tromboneShake/100);
    
    line(0, height-(previousBandValueTrombone*heightMult), dist*(i-1), 0, height-(bandValueTrombone*heightMult), dist*i);  // vertical
    line((previousBandValueTrombone*heightMult), height, dist*(i-1), (bandValueTrombone*heightMult), height, dist*i); // horizontal
    line(0, height-(previousBandValueTrombone*heightMult), dist*(i-1), (bandValueTrombone*heightMult), height, dist*i); // diagonal


    float bandValueSax = fft_sax.getBand(i) * (1 + (i/50)); 
    stroke((2*saxShake)+scoreLow, (2*saxShake)+scoreMid, 255-saxShake*2, 40+saxShake*2);
    strokeWeight(2.5f+saxShake/100);
    //ligne superieure droite
    line(width/2+200, height-(previousBandValueSax*heightMult), dist*(i-1), width/2+200, height-(bandValueSax*heightMult), dist*i);
    line(width/2+200-(previousBandValueSax*heightMult), height, dist*(i-1), width/2+200-(bandValueSax*heightMult), height, dist*i);
    line(width/2+200, height-(previousBandValueSax*heightMult), dist*(i-1), width/2+200-(bandValueSax*heightMult),height, dist*i);
    
    //linha Sax

    


    float bandValuePercussao = fft_bateria.getBand(i);
    stroke((2*percussaoShake)+scoreLow, (2*percussaoShake)+scoreMid, 255-2*percussaoShake, 40+percussaoShake*2);
    strokeWeight(2.5f+percussaoShake/100);
    ////ligne superieure gauche  line(x1, y1, z1, x2, y2, z2)
    line(width/2-200, height-(previousBandValuePercussao*heightMult), dist*(i-1), width/2-200, height-(bandValuePercussao*heightMult), dist*i);
    line((previousBandValuePercussao*heightMult)+width/2-200, height, dist*(i-1), (bandValuePercussao*heightMult)+width/2-200, height, dist*i);
    line(width/2-200, height-(previousBandValuePercussao*heightMult), dist*(i-1), (bandValuePercussao*heightMult)+width/2-200, height, dist*i);
    
    //linha trompete
    float bandValueTrompete = fft_trompete.getBand(i) * (1 + (i/50)); 
    stroke(trompeteShake*2+scoreLow, (trompeteShake*2)+scoreMid,255-2*trompeteShake, 40+trompeteShake*2);
    strokeWeight(2.5f+trompeteShake/100);
    
    //ligne inferieure droite
    line(width, height-(previousBandValueTrompete*heightMult), dist*(i-1), width, height-(bandValueTrompete*heightMult), dist*i);
    line(width-(previousBandValueTrompete*heightMult), height, dist*(i-1), width-(bandValueTrompete*heightMult), height, dist*i);
    line(width, height-(previousBandValueTrompete*heightMult), dist*(i-1), width-(bandValueTrompete*heightMult), height, dist*i);
          
    //Sauvegarder la valeur pour le prochain tour de boucle
    previousBandValueTrompete = bandValueTrompete;
    previousBandValueTrombone = bandValueTrombone;
    previousBandValuePercussao = bandValuePercussao;
    previousBandValueSax = bandValueSax;


}
  
  //    //Murs rectangles
  for(int i = 0; i < nbMurs; i++)
  {
    //On assigne \u00e0 chaque mur une bande, et on lui envoie sa force.
    float intensity = 50+fft.getBand(i%((int)(fft.specSize()*specHi)));
    murs[i].display(scoreLow, scoreMid, scoreHi, intensity, scoreGlobal);
  } 
  
}


Gif saxGif, trompeteGif,tromboneGif , bateriaGif, batutaGif;
PImage saxImage, trompeteImage, tromboneImage, bateriaImage, batutaImage;

public void drawInstrument(Gif gif, PImage img, int X, int Y, int shake){
  
  if (shake > 30){
    image(gif, X, Y , 180,140);
    
  }else{
    image(img, X, Y, 180,140);
  }

}

public void loadGif(){
  saxGif = new Gif(this,"sax_gif.gif");
  trompeteGif = new Gif(this,"sax_gif.gif");
  tromboneGif  = new Gif(this,"sax_gif.gif");
  bateriaGif = new Gif(this,"sax_gif.gif");
  batutaGif = new Gif(this,"sax_gif.gif");
  saxGif.loop();
  trompeteGif.loop();
  tromboneGif.loop();
  bateriaGif.loop();
  batutaGif.loop();

  saxImage = loadImage("icone-sax.png");
  trompeteImage = loadImage("icone-trompete.png");
  tromboneImage = loadImage("icone-trombone.png");
  bateriaImage = loadImage("icone-bateria.png");
  batutaImage = loadImage("icone-batuta.png");

}

ArrayList<Serial> instrumentosSerial;
Serial myPort;  // The serial port
int value, channel, contInstrumento;

//void controllerChange(int channel, int number, int value) {
//  // Receive a controllerChange
//  //println(" channel ");
//  //print();
//  //println("Channel:"+channel);
//  //println("Number:"+number);
//  //println("Value:"+value);
//  switch(state){
//    case 0:{
//      if(value>40){
//        state = 1;
//        instruments.set(channel,value);
//        println(channel);
//        instrumentoAtual = channel;
//        delay(1000);
        
//      }
//      break;
//    }
//    case 1:{
//      instruments.set(channel,value);
//      println(channel);
//      //sendAbleton(channel,1,value);
//      break;
//    }case 2:{
//      println("channel "+ channel);
//      println("value "+ value);
//      instruments.set(channel,value);
//      break;
//    }
//    case 3:{
//      instruments.set(channel,value);
//      sendAbleton(channel, number, value);
//      break;
//    }
//    case 4:{
//      instruments.set(channel,value);
//      sendAbleton(channel, number, value);
//      break;
//    }
//  } 
//}

public void readSerial(){
  
 
  //for (int i = 0; i < instrumentosSerial.size(); i++){
  //  String inBuffer = instrumentosSerial.get(i).readString();
  //  if (inBuffer != null) {
  //    String[] a = split(inBuffer, " ");
  //    println(a[0]);
  //    println(a[1]);
  //    channel = int(a[0]);
  //    value = int(a[1]);      
  //  }
  //}
  
  try{
    //println("size "+instrumentosSerial.size());
    if (contInstrumento < instrumentosSerial.size()){
      //println("2 "+contInstrumento);
      String inBuffer = instrumentosSerial.get(contInstrumento).readString();
      //println("3");
      if (inBuffer != null) {
        if(inBuffer.equals("led")){instrumentosSerial.remove(contInstrumento);}
        String[] a = split(inBuffer, " ");
        println(a[0]);
        println(a[1]);
        channel = PApplet.parseInt(a[0]);
        value = PApplet.parseInt(a[1]);
        if(a[0] == "4"){
          println("batuta");
          print("2 "+a[2]+"3 "+a[3]+"4"+a[4]);
        }
        contInstrumento += 1;//  respons\u00e1vel por andar entre os intrumentos;
      }else{
        println("Sem buffer  "+instrumentosSerial.get(contInstrumento));
        contInstrumento += 1;
      }
    }else{
      //println("Zerar contador");
      contInstrumento = 0;
    }
  }catch(Exception x){
    println(x);
    //contInstrumento += 1;
  }
   
  switch(state){
    case 0:{
      if(value>40){
        state = 1;
        instruments.set(channel,value);
        println(channel);
        instrumentoAtual = channel;
        
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
      sendAbleton(channel, channel, value);
      break;
    }
    case 4:{
      instruments.set(channel,value);
      sendAbleton(channel, channel, value);
      break;
    }
  } 

}

public void createSerial(){
  instrumentosSerial = new ArrayList<Serial>();
  println(Serial.list());
  for (int i = 0; i < Serial.list().length; i++){
    println(Serial.list()[i]);
    try{
      //if(Serial.list()[i].equals("COM46")||Serial.list()[i].equals("COM44")||Serial.list()[i].equals("COM24")||Serial.list()[i].equals("COM26"))
      myPort = new Serial(this, Serial.list()[i], 115200);
      myPort.clear();
      instrumentosSerial.add(myPort);
      //}else{
      //  //println("pula "+ Serial.list()[i]);

      //}
    }catch(Exception e){
      println(e);
      //exit();
  
    }
    
    
    
  }
}

public void sendAbleton(int instrumento,int note, int value){
    //saxValue = 0 , tromboneValue = 1, trompeteValue=2 ,percussaoValue=3, batutaValue=4 ;
  switch(instrumento){
    case 0:{
      //sax.sendControllerChange(0, note, value);
      //errado
      ableton.sendControllerChange(2,instrumento,value);
      break;
    }
    case 1:{
      ableton.sendControllerChange(2,instrumento,value);
      break;
    }
    case 2:{
      ableton.sendControllerChange(2,instrumento,value);
      break;
    }
    case 3:{
      ableton.sendControllerChange(2,instrumento,value);
      break;
    }
    case 4:{
      ableton.sendControllerChange(2,instrumento,value);
      break;
    }
  }
}
//Classe pour afficher les lignes sur les cot\u00e9s
class Mur {
  //Position minimale et maximale Z
  float startingZ = -10000;
  float maxZ = -100;
  
  //Valeurs de position
  float x, y, z;
  float sizeX, sizeY;
  
  //Constructeur
  Mur(float x, float y, float sizeX, float sizeY) {
    //Faire apparaitre la ligne \u00e0 l'endroit sp\u00e9cifi\u00e9
    this.x = x;
    this.y = y;
    //Profondeur al\u00e9atoire
    this.z = random(startingZ, maxZ);  
    
    //On d\u00e9termine la taille car les murs au planchers ont une taille diff\u00e9rente que ceux sur les c\u00f4t\u00e9s
    this.sizeX = sizeX;
    this.sizeY = sizeY;
  }
  
  //Fonction d'affichage
  public void display(float scoreLow, float scoreMid, float scoreHi, float intensity, float scoreGlobal) {
    //Couleur d\u00e9termin\u00e9e par les sons bas, moyens et \u00e9lev\u00e9
    //Opacit\u00e9 d\u00e9termin\u00e9 par le volume global
    int displayColor = color(scoreLow*0.67f, scoreMid*0.67f, scoreHi*0.67f, scoreGlobal);
    
    //Faire disparaitre les lignes au loin pour donner une illusion de brouillard
    fill(displayColor, ((scoreGlobal-5)/1000)*(255+(z/25)));
    noStroke();
    
    //Premi\u00e8re bande, celle qui bouge en fonction de la force
    //Matrice de transformation
    pushMatrix();
    
    //D\u00e9placement
    translate(x, y, z);
    
    //Agrandissement
    if (intensity > 100) intensity = 100;
    scale(sizeX*(intensity/100), sizeY*(intensity/100), 20);
    
    
    //Cr\u00e9ation de la "boite"
    box(1);
    popMatrix();
    
    //Deuxi\u00e8me bande, celle qui est toujours de la m\u00eame taille
    displayColor = color(scoreLow*0.5f, scoreMid*0.5f, scoreHi*0.5f, scoreGlobal);
    fill(displayColor, (scoreGlobal/5000)*(255+(z/25)));
    //Matrice de transformation
    pushMatrix();
    
    //D\u00e9placement
    translate(x, y, z);
    
    //Agrandissement
    scale(sizeX, sizeY, 10);
    
    //Cr\u00e9ation de la "boite"
    box(1);
    popMatrix();
    
    //D\u00e9placement Z
    // reduz a velocidade dos muros, mas n\u00e3o altera a m\u00fasica.
    z+= (pow((scoreGlobal/150), 2));

    if (z >= maxZ) {
      z = startingZ;  
    }
    
  }
}
public void mainDraw(int x, int y, int scale){
//desenho principal
  beginShape();
  pushMatrix();
  smooth();
  noFill();
  stroke(255, 100, 250);
  translate(x, y); // posi\u00e7\u00e3o

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
    
    newscaler0 = newscaler0 * 0.95f;
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
public void instrument(int x, int y, int scale, float midi, int R, int G, int B, float variableMM, float variableNN1, float variableNN2, float variableNN3){
//desenho 0
  beginShape();
  pushMatrix();
  stroke(R, G, B);
  smooth();
  noFill();
  translate(x , y); // posi\u00e7\u00e3o

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
    
    newscaler = newscaler * 0.95f;
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

public PVector[] superformula(float m,float n1,float n2,float n3) {
  int numPoints = 360;
  float phi = TWO_PI / numPoints;
  PVector[] points = new PVector[numPoints+1];
  for (int i = 0;i <= numPoints;i++) {
    points[i] = superformulaPoint(m,n1,n2,n3,phi * i);
  }
  return points;
}

public PVector superformulaPoint(float m,float n1,float n2,float n3,float phi) {
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
public void tela0(){
  beginShape();
  background(bg);
  textSize(50);
  textAlign(CENTER);
  text("Experimente o 1\u00ba Frevo criado por", width/2, height/2-160);
  text("um artista com uso de Intelig\u00eancia Artificial",  width/2, height/2-110);
  
  image(logo, width/2-180, height/2-10);
  fill(255);
  endShape();
  beginShape();
  textSize(30);
  text("Balance um intrumento para iniciar a intera\u00e7\u00e3o", width/2, height/2+150);
  h1("M\u00fasica: Tem coisa no Frevo",25, width/2-530, height-140);
  h1("Autor: Sergio Gaia e I.A",25, width/2-553, height-110);
  h1("Grava\u00e7\u00e3o: Spok Frevo Orquestra",25, width/2-498, height-80);
  endShape();
  
  
  image(softex, width/2+50, height-75, 130, 60);
  image(ibm, width/2+200, height-75, 80, 70);
  image(paco, width/2+300, height-80, 50,70);
  image(louco, width/2+400, height-80, 100,70);
  
}
public void tela1(){
  background(bg); 
  if (frevianaPlayable.isPlaying()==false) {
    if (played){
      state = 2;
      fimAnimacao = false;
      played = false;
      println("entrei aqui");
    }else{
      println("Tocando freviana " + instrumentoAtual);
        switch(instrumentoAtual){
          case 0:{
            frevianaPlayable = freviana1_0;
            freviana2 = freviana2_1;
            frevianaPlayable.play();
            println(" play 0 ");
            
            instrumento = "pelo saxofone";
            
            break;
          }
          case 1:{
            frevianaPlayable = freviana1_1;
            freviana2 = freviana2_1;
            frevianaPlayable.play();
            frevianaPlayable.setGain(5);
            instrumento = "pelo trombone";
            println(" play 1 ");
            break;
          }
          case 2:{
            frevianaPlayable = freviana1_2;
            freviana2 = freviana2_1;
            frevianaPlayable.play();
            instrumento = "pelo trompete";
            println(" play 2 ");
            break;
          }
          case 3:{
            frevianaPlayable = freviana1_3;
            freviana2 = freviana2_1;
            frevianaPlayable.play();
            instrumento = "pela bateria"; 
            println(" play 3 ");
            break;
          }
          case 4:{
            frevianaPlayable = freviana1_4;
            freviana2 = freviana2_5;
            frevianaPlayable.play();
            instrumento = "batuta"; 
            println(" play 4 ");
            break;
          }
        }
      //frevianaPlayable.play();
      frevianaPlayable.setGain(0);
      played =true;
    }
  }
  if(instrumentoAtual == 4){
    String [] textos = {"Ol\u00e1, sou a Freviana, a intelig\u00eancia artificial por tr\u00e1s do Batuta", " Percebi que voc\u00ea se interessou pela Batuta", "Com a ajuda do Pa\u00e7o do Frevo compus um frevo \u00fanico", "mas como sou feita apenas de bits preciso da sua ajuda para orquestr\u00e1-lo"};
    int [] delay = {5000,3000,3500,4000};
    println("texto batuta");
    if (fimAnimacao){
      h1(textos[textos.length-1],40, width/2, 230);
      //image(ai, width/2 , height/2, 75,50);
    }else{
      fade(textos, delay, 40, width/2, 230);
    }
  }else{
    String [] textos = {"Ol\u00e1, sou a Freviana, a intelig\u00eancia artificial por tr\u00e1s do Batuta", " Percebi que voc\u00ea se interessou " + instrumento + " "," Com a ajuda do Pa\u00e7o do Frevo compus um frevo \u00fanico", " mas como sou feita apenas de bits preciso da sua ajuda para toc\u00e1-lo"};
    int [] delay = {5000,3000,3500,4000};
    
    if (fimAnimacao){
      h1(textos[textos.length-1],40, width/2, 230);
    }else{
      fade(textos, delay, 40, width/2, 230);
      
    }
    //h1("Ol\u00e1, sou a Freviana, a intelig\u00eancia artificial por tr\u00e1s do Batuta. Percebi que voc\u00ea se interessou pelo " + instrumento + ". Com a ajuda do Pa\u00e7o do Frevo compus um frevo \u00fanico, mas como sou feita apenas de bits preciso da sua ajuda para toc\u00e1-lo. ",40, width/2, 30);
    //h1("Ol\u00e1, sou a Freviana, a intelig\u00eancia artificial por tr\u00e1s do Batuta.", 40, width/2, 40);
    //h1("Percebi que voc\u00ea se interessou pelo "+instrumento+".", 40, width/2, 100);
    //h1("Com a ajuda do Pa\u00e7o do Frevo compus um frevo \u00fanico,", 40, width/2, 160);
    //h1("mas como sou feita apenas de bits preciso da sua ajuda para toc\u00e1-lo.", 40, width/2, 220);
  }
  //myBus.list();
  //mainDraw(width/2, height/2, 60);
  
    
    try{for(int i = 0; i < frevianaPlayable.bufferSize() - 1; i++)
    {
      beginShape();
      fill(225);
      stroke(255, 9, 99);
      line(i, height/2 -50   + frevianaPlayable.left.get(i)*50,  i+25, height/2-50  + frevianaPlayable.left.get(i+1)*50);
      //line(i, height/2 + + frevianaPlayable.right.get(i)*50, i+1, height/2 + frevianaPlayable.right.get(i+1)*50);
      endShape();
    }}catch(Exception e){println(e);};
  
//int x, int y, int scale, float midi, int R, int G, int B, float variableMM, float variableNN1, float variableNN2, float variableNN3

  image(ai, width/2-50, 120, 100,100);
  drawInstrument(tromboneGif,tromboneImage, width/2-600, height/2+100, instruments.get(1) );
  h1("Para aumentar o instrumento",15, width/2-510, height/2+260);
  drawInstrument(bateriaGif, bateriaImage, width/2-350, height/2+100, instruments.get(3));
  h1("Para aumentar o instrumento",15, width/2-260, height/2+260);
  drawInstrument(saxGif, saxImage, width/2-100, height/2+100, instruments.get(0));
  h1("Para aumentar a banda",15, width/2-10, height/2+260);
  drawInstrument(trompeteGif, trompeteImage, width/2+150, height/2+100, instruments.get(2));
  h1("Para aumentar o instrumento",15, width/2+240, height/2+260);
  drawInstrument(batutaGif, batutaImage, width/2+400, height/2+100, instruments.get(4));
  h1("Para aumentar o instrumento",15, width/2+490, height/2+260);
  //instrument(width/2-300, height/2+200, 75, instruments.get(0), 237, 28, 36, 2, map(instruments.get(0), 0,127,0.1,2), 0.5, 0.5);
  //instrument(width/2-100, height/2+200, 75, instruments.get(1), 255, 230, 0, 2, map(instruments.get(1), 0,127,0.1,2), 0.5, 0.5);
  //instrument(width/2+100, height/2+200, 75, instruments.get(2), 0, 0, 179, 2, map(instruments.get(2), 0,127,0.1,2), 0.5, 0.5);
  //instrument(width/2+300, height/2+200, 75, instruments.get(3), 7, 156, 66, 2, map(instruments.get(3), 0,127,0.1,2), 0.5, 0.5);         

  //state = 1;
}
boolean played2 = false;

public void tela2(){
  background(bg);
  textAlign(CENTER);
  if(instrumentoAtual == 4){
    
    String [] textos = {" Hoje voc\u00ea \u00e9 o Maestro", "Aponte a batuta pra cima e pra baixo e aumente ou diminua o volume de todos.", "E se quiser animar a banda balance a batuta o mais r\u00e1pido que puder"};
    int [] delay = {2000,5000,5000};
    println("texto batuta");
    if (fimAnimacao){
      h1(textos[textos.length-1],40, width/2, 230);
    }else{
      fade(textos, delay, 40, width/2, 230);
    }
  }else{
    String [] textos = {"Voc\u00ea pode me ajudar com a m\u00fasica", "Balance seu objeto pra cima e pra baixo e aumente ou diminua o volume"};
    int [] delay = {3000,5000};
    println("texto batuta");
    if (fimAnimacao){
      h1(textos[textos.length-1],40, width/2, 230);
    }else{
      fade(textos, delay, 40, width/2, 230);
    }
  }

  for(int i = 0; i < freviana2.bufferSize() - 1; i++){
      beginShape();
      stroke(255, 9, 99);
      line(i, height/2 -50   + freviana2.left.get(i)*50,  i+25, height/2-50  + freviana2.left.get(i+1)*50);
      //line(i, height/2 + + freviana2.right.get(i)*50, i+1, height/2 + freviana2.right.get(i+1)*50);
      fill(225);
      endShape();
    }
  image(ai, width/2-50, 120, 100,100);
  drawInstrument(tromboneGif,tromboneImage, width/2-600, height/2+100, instruments.get(1) );
  h1("Para aumentar o instrumento",15, width/2-510, height/2+260);
  drawInstrument(bateriaGif, bateriaImage, width/2-350, height/2+100, instruments.get(3));
  h1("Para aumentar o instrumento",15, width/2-260, height/2+260);
  drawInstrument(saxGif, saxImage, width/2-100, height/2+100, instruments.get(0));
  h1("Para aumentar a banda",15, width/2-10, height/2+260);
  drawInstrument(trompeteGif, trompeteImage, width/2+150, height/2+100, instruments.get(2));
  h1("Para aumentar o instrumento",15, width/2+240, height/2+260);
  drawInstrument(batutaGif, batutaImage, width/2+400, height/2+100, instruments.get(4));
  h1("Para aumentar o instrumento",15, width/2+490, height/2+260);
  
//int x, int y, int scale, float midi, int R, int G, int B, float variableMM, float variableNN1, float variableNN2, float variableNN3
  //instrument(width/2-300, height/2+200, 75, instruments.get(0), 237, 28, 36, 2, map(instruments.get(0), 0,127,0.1,2), 0.5, 0.5);
  //instrument(width/2-100, height/2+200, 75, instruments.get(1), 255, 230, 0, 2, map(instruments.get(1), 0,127,0.1,2), 0.5, 0.5);
  
  //instrument(width/2+100, height/2+200, 75, instruments.get(2), 0, 0, 179, 2, map(instruments.get(2), 0,127,0.1,2), 0.5, 0.5);
  //instrument(width/2+300, height/2+200, 75, instruments.get(3), 7, 156, 66, 2, map(instruments.get(3), 0,127,0.1,2), 0.5, 0.5);    
  
  if (freviana2.isPlaying()==false) {
    if (played){
      //println("estado da tela mudar de estado");
      state = 3;
      fimAnimacao = false;
      played = false;
      delay(1500);
      
              
    }else{
      println("play freviana");
      freviana2.play();
      freviana2.setGain(0);
      played =true;
    }
  }
}
public void tela3(){
  background(bg);
  textAlign(CENTER);
  println("___________________TELA 3");
  
  //bug esse ponto n\u00e3o ta senddo exibio.
  String [] textos = {"Est\u00e3o todos prontos?","O Bloco est\u00e1 prestes a sair e ningu\u00e9m pode ficar pra tr\u00e1s!", "\u00c9 hora de afinar os instrumentos..."};
  int [] delay = {2000,4000,2500};
  println("texto batuta");
  if (fimAnimacao){
    h1(textos[textos.length-1],40, width/2, 230);
  }else{
    fade(textos, delay, 40, width/2, 230);
  }
  
  for(int i = 0; i < freviana3.bufferSize() - 1; i++){
    beginShape();
      stroke(255, 9, 99);
      line(i, height/2 -50   + freviana3.left.get(i)*50,  i+25, height/2-50  + freviana3.left.get(i+1)*50);
      //line(i, height/2 + + freviana3.right.get(i)*50, i+1, height/2 + freviana3.right.get(i+1)*50);
      fill(225);
    endShape();
  }
  image(ai, width/2-50, 120, 100,100);
  drawInstrument(tromboneGif,tromboneImage, width/2-600, height/2+100, instruments.get(1) );
  h1("Para aumentar o instrumento",15, width/2-510, height/2+260);
  drawInstrument(bateriaGif, bateriaImage, width/2-350, height/2+100, instruments.get(3));
  h1("Para aumentar o instrumento",15, width/2-260, height/2+260);
  drawInstrument(saxGif, saxImage, width/2-100, height/2+100, instruments.get(0));
  h1("Para aumentar a banda",15, width/2-10, height/2+260);
  drawInstrument(trompeteGif, trompeteImage, width/2+150, height/2+100, instruments.get(2));
  h1("Para aumentar o instrumento",15, width/2+240, height/2+260);
  drawInstrument(batutaGif, batutaImage, width/2+400, height/2+100, instruments.get(4));
  h1("Para aumentar o instrumento",15, width/2+490, height/2+260);
  
  if (freviana3.isPlaying()==false) {
    if (played){
      //println("estado 1 da tela mudar de estado");
      //println("cronometro");
      background(bg);
      textAlign(CENTER);
      h1("\u00c9 hora de afinar os instrumentos...", 40 ,width/2, 230);
      cronometro();
      image(ai, width/2-50, 120, 100,100);
      drawInstrument(tromboneGif,tromboneImage, width/2-600, height/2+100, instruments.get(1) );
      h1("Para aumentar o instrumento",15, width/2-510, height/2+260);
      drawInstrument(bateriaGif, bateriaImage, width/2-350, height/2+100, instruments.get(3));
      h1("Para aumentar o instrumento",15, width/2-260, height/2+260);
      drawInstrument(saxGif, saxImage, width/2-100, height/2+100, instruments.get(0));
      h1("Para aumentar a banda",15, width/2-10, height/2+260);
      drawInstrument(trompeteGif, trompeteImage, width/2+150, height/2+100, instruments.get(2));
      h1("Para aumentar o instrumento",15, width/2+240, height/2+260);
      drawInstrument(batutaGif, batutaImage, width/2+400, height/2+100, instruments.get(4));
      h1("Para aumentar o instrumento",15, width/2+490, height/2+260);
              
    }else{
      println("play freviana");
      freviana3.play();
      freviana3.setGain(0);
      played =true;
      delay(1000);
    }
  }
  
}
public void tela4(){
  background(bg);
  String [] textos = {"Obrigado  por ter me ajudado a tocar o frevo","N\u00e3o sei o que seria de mim sem voc\u00eas", "Como provavelmente n\u00e3o terei bra\u00e7os t\u00e3o cedo", "posso te ligar quando o carnaval come\u00e7ar?" }  ;
  int [] delay = {3000,3000,3000,4000};
  
    if (freviana_agradecimentos.isPlaying()==false) {
      if (played){
        //setup();
        state = 6;
        played = false;
                
      }else{
        println("play freviana");
        freviana_agradecimentos.play();
        freviana_agradecimentos.setGain(0);
        played =true;
      }
    }
  
  
  if (fimAnimacao){
    h1(textos[textos.length-1],40, width/2, 230);
  }else{
    fade(textos, delay, 40, width/2, 230);
  }
  
  //h1("Agradecimentos", 40, width/2, height-700);
  image(ai, width/2-50, 120, 100,100);
  image(softex, width/2+50, height-75, 130, 60);
  image(ibm, width/2+200, height-75, 80, 70);
  image(paco, width/2+300, height-80, 50,70);
  image(logo, width-1100, height-70);
  
  
  
  for(int i = 0; i < freviana_agradecimentos.bufferSize() - 1; i++){
    beginShape();
      stroke(255, 9, 99);
      line(i, height/2 -50   + freviana_agradecimentos.left.get(i)*50,  i+25, height/2-50  + freviana_agradecimentos.left.get(i+1)*50);
      //line(i, height/2 + + freviana_agradecimentos.right.get(i)*50, i+1, height/2 + freviana_agradecimentos.right.get(i+1)*50);
      fill(225);
    endShape();
  }
  

}  
public void tela5(){
  
      
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
      
      h1("Desenvolvedores",20, width/2, height/2+200);
      
      h1("Delando J\u00fanior", 18, width-1000, (height/2)+240);
      h1("Gleybson Farias", 18, width/2, (height/2)+240);
      h1("Patrick Gouy", 18, width-300, (height/2)+240);
       

     
  
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
  public void settings() {  fullScreen(P3D);  smooth(); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "--present", "--window-color=#666666", "--stop-color=#cccccc", "interfaceProcessing" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
