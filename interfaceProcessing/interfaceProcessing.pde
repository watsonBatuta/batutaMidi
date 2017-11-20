import themidibus.*; //Import the library
import ddf.minim.*;
import ddf.minim.analysis.*;

 
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


AudioPlayer freviana1_0,freviana1_1,freviana1_2,freviana1_3, freviana2_1, frevianaPlayable;
Minim minim;//audio context
boolean played;
String instrumento;

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
  playSong();
 
   
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

  //fullScreen();
  size(800,600,P3D);
  smooth();
  noFill();
  state = 3;
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

  
}

void draw() { 
  
  
  switch(state){
    case 0:{
      
      tela0();
      
      break;
    }
    case 1:{
      background(0);
      
      if (frevianaPlayable.isPlaying()==false) {
        if (played){
          state = 2;
          played = false;
          println("entrei aqui");
        }else{
          println("Tocando freviana " + instrumentoAtual);
            switch(instrumentoAtual){
              case 0:{
                frevianaPlayable = freviana1_0;
                frevianaPlayable.play();
                instrumento = "Saxofone";
                println(" play 0 ");
                break;
              }
              case 1:{
                frevianaPlayable = freviana1_1;
                frevianaPlayable.play();
                instrumento = "trombone";
                println(" play 1 ");
                break;
              }
              case 2:{
                frevianaPlayable = freviana1_2;
                frevianaPlayable.play();
                instrumento = "trompete";
                println(" play 2 ");
                break;
              }
              case 3:{
                frevianaPlayable = freviana1_3;
                frevianaPlayable.play();
                instrumento = "bateria"; 
                println(" play 3 ");
                break;
              }
            }
          //frevianaPlayable.play();
          frevianaPlayable.setGain(-20);
          played =true;
        }
      }       
      h1("Olá, sou a Freviana, a inteligência artificial por trás do Batuta.", 40, width/2, 40);
      h1("Percebi que você se interessou pelo "+instrumento+".", 40, width/2, 100);
      h1("Com a ajuda do Paço do Frevo compus um frevo único,", 40, width/2, 160);
      h1("mas como sou feita apenas de bits preciso da sua ajuda para tocá-lo.", 40, width/2, 220);
        
      //myBus.list();
      //mainDraw(width/2, height/2, 60);
      
        
        try{for(int i = 0; i < frevianaPlayable.bufferSize() - 1; i++)
        {
          beginShape();
          fill(225);
          line(i, height/2 -50   + frevianaPlayable.left.get(i)*50,  i+1, height/2-50  + frevianaPlayable.left.get(i+1)*50);
          line(i, height/2 + + frevianaPlayable.right.get(i)*50, i+1, height/2 + frevianaPlayable.right.get(i+1)*50);
          endShape();
        }}catch(Exception e){println(e);};
      
//int x, int y, int scale, float midi, int R, int G, int B, float variableMM, float variableNN1, float variableNN2, float variableNN3
      instrument(width/2-300, height/2+200, 75, instruments.get(0), 237, 28, 36, 2, map(instruments.get(0), 0,127,0.1,2), 0.5, 0.5);
      instrument(width/2-100, height/2+200, 75, instruments.get(1), 255, 230, 0, 2, map(instruments.get(1), 0,127,0.1,2), 0.5, 0.5);
      
      instrument(width/2+100, height/2+200, 75, instruments.get(2), 0, 0, 179, 2, map(instruments.get(2), 0,127,0.1,2), 0.5, 0.5);
      instrument(width/2+300, height/2+200, 75, instruments.get(3), 7, 156, 66, 2, map(instruments.get(3), 0,127,0.1,2), 0.5, 0.5);         
    
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