import themidibus.*; //Import the library
import ddf.minim.*;
import ddf.minim.analysis.*;

import gifAnimation.*;

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
//audios para fase de apresentação (Afinação)
AudioPlayer soloBateria, soloSax, soloTrompete, soloTrombone;
//audios para as linhas
AudioPlayer song_bateria, song_sax, song_trompete, song_trombone;



Minim minim;//audio context
boolean played;
String instrumento;


color bg = color (0);
int begin = 0;

int state;

PImage logo, softex, ibm, paco;
Gif ai;
//Config. para cubos

// Variables qui définissent les "zones" du spectre
// Par exemple, pour les basses, on prend seulement les premières 4% du spectre total
float specLow = 0.3; // 3%
float specMid = 0.20;  // 12.5%
float specHi = 0.50;   // 20%sa

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

int instrumentoAtual;



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
  
  // Carregando os sons dos instrumentos
  loadAudios();
  
   //carregando fft para linhas de audios
  loadFft();
  
  //tocando todos os instrumentos para realizar iteração com as linhas 
  
 
   
  ////Créer l'objet FFT pour analyser la chanson
  //fft = new FFT(song.bufferSize(), song.sampleRate());
  
  //Un cube par bande de fréquence
  //nbCubes = (int)(fft.specSize()*specHi);
  nbCubes = 20;
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

  loadFrevianaFiles();
  
  played = false;

  //saxValue = 0 , tromboneValue = 1, trompeteValue=2 ,percussaoValue=3, batutaValue=4 ;
  instruments = new IntList(0,0,0,0,0);

  fullScreen(P3D);
  //size(800,600,P3D);
  smooth();
  noFill();
  state = 0;
  // sax, trombone,trompete, percussao, batuta; 
  sax = new MidiBus(this, 0, -1,"0");
  trombone = new MidiBus(this, 3, -1,"1");
  trompete = new MidiBus(this, 2, -1,"2");
  percussao = new MidiBus(this, 1, -1,"3");
  ableton = new MidiBus(this, -1, 4, "5");
  
  //batuta = new MidiBus(this, 0, 4,"4");

  sax.list();
  
  logo = loadImage("logoBatuta.png");
  softex = loadImage("logoSoftex.png");
  ibm = loadImage("logoIBM.png");
  paco = loadImage("logoPaco.png");
  ai = new Gif(this, "ai_gif.gif");
  ai.loop();
  loadGif();
  //frameRate(10);
  
}

void draw() { 
  
  
  switch(state){
    case 0:{
      
      tela0();
      
      break;
    }
    case 1:{
      tela1();
      break;
    }
    case 2:{
      tela2();   
      break;
    }case 3:{
      tela3();
      break;
    }
    case 4:{
      cubos();
      image(ai, width/2-40 , height/2-25, 75,50);
      if(song.isPlaying()){
      }else{
        state = 5;
        //setup();
      }
      break;
    }
    case 5:{
      tela4();
    }
  }
}