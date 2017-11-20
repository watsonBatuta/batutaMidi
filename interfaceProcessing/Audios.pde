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

void loadFrevianaFiles(){
    freviana1_0 = minim.loadFile("1_0.mp3",2048);
    freviana1_1 = minim.loadFile("1_1.mp3",2048);
    freviana1_2 = minim.loadFile("1_2.mp3",2048);
    freviana1_3 = minim.loadFile("1_3.mp3",2048);
    freviana2_1 = minim.loadFile("freviana_2_1.mp3", 2048);
    frevianaPlayable = minim.loadFile("1_3.mp3",2048);
}