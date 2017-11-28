import processing.serial.*;
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

void readSerial(){
  
 
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
    if (contInstrumento < instrumentosSerial.size()){
    String inBuffer = instrumentosSerial.get(contInstrumento).readString();
      if (inBuffer != null) {
        String[] a = split(inBuffer, " ");
        println(a[0]);
        println(a[1]);
        channel = int(a[0]);
        value = int(a[1]);
        if(a[0] == "4"){
          println("batuta");
          print("2 "+a[2]+"3 "+a[3]+"4"+a[4]);
        }
        contInstrumento += + 1;//  responsável por andar entre os intrumentos;
      }else{
        println("Sem buffer");
      }
    }else{
      println("Zerar contador");
      contInstrumento = 0;
    }
  }catch(Exception x){
    println(x);
  }
   
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

void createSerial(){
  instrumentosSerial = new ArrayList<Serial>();
  println(Serial.list());
  for (int i = 0; i < Serial.list().length; i++){
    println(Serial.list()[i]);
    try{
      myPort = new Serial(this, Serial.list()[i], 115200);
      myPort.clear();
    }catch(Exception e){
      println(e);
      exit();
  
    }
    
    instrumentosSerial.add(myPort);
    
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