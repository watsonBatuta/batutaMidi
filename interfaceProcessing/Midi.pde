
void controllerChange(int channel, int number, int value) {
  // Receive a controllerChange
  //println(" channel ");
  //print();
  println("Channel:"+channel);
  println("Number:"+number);
  println("Value:"+value);
  switch(state){
    case 0:{
      if(value>40){
        state = 1;
        instruments.set(channel,value);
        println(channel);
        instrumentoAtual = channel;
        delay(1000);
        
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

void sendAbleton(int instrumento,int note, int value){
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