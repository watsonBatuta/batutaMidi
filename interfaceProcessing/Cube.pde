
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

//Cubos

//funcao para desenhar os cubos e linhas - antigo draw
void cubos(){
  //Faire avancer la chanson. On draw() pour chaque "frame" de la chanson...
    //Commencer la chanson
  //song.play();
  ////song.mute();

  //fft.forward(song.mix);
  
  //chamar forward para os fft´s (interação com as linhas)
  loadForward();
  
  
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
    
    
   float previousBandValuePercussao = fft_bateria.getBand(0);
   float previousBandValueSax = fft_sax.getBand(0);
   float previousBandValueTrombone = fft_trombone.getBand(0);
   float previousBandValueTrompete = fft_trompete.getBand(0);
    
    
  //Distance entre chaque point de ligne, négatif car sur la dimension z
  //float dist = -25;
  float dist = -25;
  
  //Multiplier la hauteur par cette constantel
  float heightMult = 2;

    //    //Murs rectangles
  for(int i = 0; i < nbMurs; i++)
  {
    //On assigne à chaque mur une bande, et on lui envoie sa force.
    float intensity = 50+fft.getBand(i%((int)(fft.specSize()*specHi)));
    murs[i].display(scoreLow, scoreMid, scoreHi, intensity, scoreGlobal);
  } 
  
  //delay(100);
  
  
  for(int i = 1; i < fft.specSize(); i++)
  {
    println("for linha fft sem sax");
    
    println("intruments 3 "+ instruments.get(3));
        
    //Selection de la couleur en fonction des forces des différents types de sons
    stroke(100+scoreLow, 100+scoreMid, 100+scoreHi, 255-i);
    strokeWeight(1 + (scoreGlobal/100));
    
    //linha sax
    //ligne inferieure gauche
    float bandValueSax = fft_sax.getBand(i) * (1 + (i/50));      
    
    
    //float bandValueSax = 100 ;
    println("band value sax e I " + fft_sax.getBand(i)+ " E " +  i );
    line(0, height-(previousBandValueSax*heightMult), dist*(i-1), 0, height-(bandValueSax*heightMult), dist*i);  // vertical
    line((previousBandValueSax*heightMult), height, dist*(i-1), (bandValueSax*heightMult), height, dist*i); // horizontal
    line(0, height-(previousBandValueSax*heightMult), dist*(i-1), (bandValueSax*heightMult), height, dist*i); // diagonal
    
    
    //linha percussao
    float bandValuePercussao = fft_bateria.getBand(i);
    //ligne superieure droite
    line(width/2+200, height-(previousBandValuePercussao*heightMult), dist*(i-1), width/2+200, height-(bandValuePercussao*heightMult), dist*i);
    line(width/2+200-(previousBandValuePercussao*heightMult), height, dist*(i-1), width/2+200-(bandValuePercussao*heightMult), height, dist*i);
    line(width/2+200, height-(previousBandValuePercussao*heightMult), dist*(i-1), width/2+200-(bandValuePercussao*heightMult),height, dist*i);
    
    //linha trombone
    println("For para linha fft trombone");
    float bandValueTrombone = fft_trombone.getBand(i);
    ////ligne superieure gauche  line(x1, y1, z1, x2, y2, z2)
    line(width/2-200, height-(previousBandValueTrombone*heightMult), dist*(i-1), width/2-200, height-(bandValueTrombone*heightMult), dist*i);
    line((previousBandValueTrombone*heightMult)+width/2-200, height, dist*(i-1), (bandValueTrombone*heightMult)+width/2-200, height, dist*i);
    line(width/2-200, height-(previousBandValueTrombone*heightMult), dist*(i-1), (bandValueTrombone*heightMult)+width/2-200, height, dist*i);
    
    //linha trompete
    println("For para linha fft trompete");
    ///float bandValueTrompete = bandValue1*map(instruments.get(1),0,127,0.0,1.8); // pegando o valor do midi
    float bandValueTrompete = fft_trompete.getBand(i);
    //ligne inferieure droite
    line(width, height-(previousBandValueTrompete*heightMult), dist*(i-1), width, height-(bandValueTrompete*heightMult), dist*i);
    line(width-(previousBandValueTrompete*heightMult), height, dist*(i-1), width-(bandValueTrompete*heightMult), height, dist*i);
    line(width, height-(previousBandValueTrompete*heightMult), dist*(i-1), width-(bandValueTrompete*heightMult), height, dist*i);
       
   
  }
}