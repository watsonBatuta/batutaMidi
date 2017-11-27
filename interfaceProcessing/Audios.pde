AudioPlayer freviana1_0,freviana1_1,freviana1_2,freviana1_3, freviana1_4, freviana2_1, freviana2_5, freviana2, freviana3, frevianaPlayable, audioCronometro, freviana_agradecimentos;

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
    freviana1_4 = minim.loadFile("1_4.mp3",2048);
    freviana2_5 = minim.loadFile("2_5.mp3", 2048);
    freviana2_1 = minim.loadFile("2_1.mp3", 2048);
    freviana2 = minim.loadFile("2_1.mp3", 2048);
    freviana3 = minim.loadFile("3.mp3", 2048);
    frevianaPlayable = minim.loadFile("1_3.mp3",2048);
    audioCronometro = minim.loadFile("cronometro.mp3",2048);
    freviana_agradecimentos = minim.loadFile("freviana_agradecimentos.mp3", 2048);
}

void rewindAudio(){

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


}

// Carregando os sons dos instrumentos
void loadAudios(){
  
  //Audio do frevo
  song = minim.loadFile("TemCoisaNoFrevo.mp3");
  
  println("load Songs");  
  song_bateria = minim.loadFile("frevo_bateria.mp3", 1024);
  song_sax = minim.loadFile("frevo_sax.mp3", 1024);
  song_trompete = minim.loadFile("frevo_trompete.mp3", 1024); 
  song_trombone = minim.loadFile("frevo_trombone.mp3", 1024);
}

// tocar sons
void playSong(){
  
  //frevo
  song.play();
  ableton.sendNoteOn(2,7,127);
  ableton.sendNoteOff(2,7,127);
  //song.mute();
  
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

void loadFft(){
  
  //fft para analisar frevo completo
  fft = new FFT(song.bufferSize(), song.sampleRate());
  
  //Criar o objeto FFT para analisar a audios separados
  fft_sax = new FFT(song_sax.bufferSize(), song_sax.sampleRate());
  fft_trompete = new FFT(song_trompete.bufferSize(), song_trompete.sampleRate());
  fft_trombone = new FFT(song_trombone.bufferSize(), song_trombone.sampleRate());
  fft_bateria =  new FFT(song_bateria.bufferSize(), song_bateria.sampleRate());
}

//pegar 'frames' da musica
void loadForward(){
   //'frames' da musica
   fft.forward(song.mix);
   
   //'frames' dos instrumentos
   fft_sax.forward(song_sax.mix);
   fft_trompete.forward(song_trompete.mix);
   fft_trombone.forward(song_trombone.mix);
   fft_bateria.forward(song_bateria.mix);
}