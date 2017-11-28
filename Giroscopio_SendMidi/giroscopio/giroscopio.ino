// Programa : Teste Giroscopio L3G4200D
// Adaptacoes : Arduino e Cia

#include <Wire.h>
#include "MIDIUSB.h"

#define CTRL_REG1 0x20
#define CTRL_REG2 0x21
#define CTRL_REG3 0x22
#define CTRL_REG4 0x23
#define CTRL_REG5 0x24

#define Register_ID 0
#define Register_2D 0x2D
#define Register_X0 0x32
#define Register_X1 0x33
#define Register_Y0 0x34
#define Register_Y1 0x35
#define Register_Z0 0x36
#define Register_Z1 0x37

// Endereco I2C do sensor : 83 em decimal ou 0x53
int ADXAddress = 0x53;  // the default 7-bit slave address
int reading = 0;
int val=0;
int X0,X1,X_out;
int Y0,Y1,Y_out;
int Z1,Z0,Z_out;
double Xg,Yg,Zg;

//Endereco I2C do L3G4200D
int L3G4200D_Address = 105;

int x;
int y;
int z;
float leaky[2];
float leakage = 0.1;
int pot, channel;
float shake = 0;
int volume;
int volumeAcelerometro;
void setup()
{
  Wire.begin();
  Serial.begin(115200);

  Serial.println("Inicializando o L3G4200D");
  Wire.beginTransmission(ADXAddress);
  Wire.write(Register_2D);
  Wire.write(8);                //measuring enable
  Wire.endTransmission();     // stop transmitting
  // Configura o L3G4200 para 200, 500 ou 2000 graus/seg
  setupL3G4200D(2000);

  // Aguarda a resposta do sensor
  leaky[1] = 0;

}



void Acelerometro(){
//--------------X
  Wire.beginTransmission(ADXAddress); // transmit to device
  Wire.write(Register_X0);
  Wire.write(Register_X1);
  Wire.endTransmission();
  Wire.requestFrom(ADXAddress,2); 
  if(Wire.available()<=2)   
  {
    X0 = Wire.read();
    X1 = Wire.read(); 
    X1=X1<<8;
    X_out=X0+X1;   
  }

  //------------------Y
  Wire.beginTransmission(ADXAddress); // transmit to device
  Wire.write(Register_Y0);
  Wire.write(Register_Y1);
  Wire.endTransmission();
  Wire.requestFrom(ADXAddress,2); 
  if(Wire.available()<=2)   
  {
    Y0 = Wire.read();
    Y1 = Wire.read(); 
    Y1=Y1<<8;
    Y_out=Y0+Y1;
  }
  //------------------Z
  Wire.beginTransmission(ADXAddress); // transmit to device
  Wire.write(Register_Z0);
  Wire.write(Register_Z1);
  Wire.endTransmission();
  Wire.requestFrom(ADXAddress,2); 
  if(Wire.available()<=2)   
  {
    Z0 = Wire.read();
    Z1 = Wire.read(); 
    Z1=Z1<<8;
    Z_out=Z0+Z1;
  }

  Xg=X_out/256.0;
  Yg=Y_out/256.0;
  Zg=Z_out/256.0;
//  Serial.print("X= ");
//  Serial.print(Xg);
//  Serial.print("       ");
//  Serial.print("Y= ");
//  Serial.print(Yg);
//  Serial.print("       ");
//  Serial.print("Z= ");
//  Serial.print(Zg);
//  Serial.println("  ");
  
 
}

void loop()
{
  // Atualiza os valores de X, Y e Z
  getGyroValues();
  //Acelerometro();
  //leakage = 1 - (analogRead(A0)/1023.0);
  leakage = 0.99;
  shake = leakyIntegrator(abs(x)/1000.0,leakage);
  // Mostra os valores no serial monitor
//  Serial.print(x/1000.0);
//  Serial.print(" ");
//  Serial.print(shake);
//  Serial.print(" ");
//  Serial.print(leakage);
//  Serial.print(" ");
//  Serial.println();
//  Serial.print(channel);
//  Serial.println(" channel ");
  
  channel = 2;
  
 //saxValue = 0 , tromboneValue = 1, trompeteValue=2 ,percussaoValue=3, batutaValue=4 ;
  //volume midi value
  volume = map(shake, 0, 200, 20, 127);
  volume = (int) constrain(volume, 0,127);
 // volumeAcelerometro = map(Xg, -1.0, 1, 10, 127);
  //volumeAcelerometro = (int) constrain(volumeAcelerometro, 0,127);
  Serial.print(channel);
  Serial.print(" ");
  Serial.print(volume);
  Serial.print(" ");
  Serial.print("a");
  Serial.println();
//  Serial.print(5);
//  Serial.print(" ");
//  Serial.print(Xg);
//  Serial.print(" ");
//  Serial.print("b");
//  Serial.println();
//  controlChange(channel,0,volume);
//  MidiUSB.flush();

  // Aguarda 100ms e reinicia o processo
  //delay(10);
}

void controlChange(byte channel, byte control, byte value) {
  midiEventPacket_t event = {0x0B, 0xB0 | channel, control, value};
  MidiUSB.sendMIDI(event);
}

void noteOn(byte channel, byte pitch, byte velocity) {
  midiEventPacket_t noteOn = {0x09, 0x90 | channel, pitch, velocity};
  MidiUSB.sendMIDI(noteOn);
}

void noteOff(byte channel, byte pitch, byte velocity) {
  midiEventPacket_t noteOff = {0x08, 0x80 | channel, pitch, velocity};
  MidiUSB.sendMIDI(noteOff);
}



void getGyroValues()
{
  // Rotina para leitura dos valores de X, Y e Z
  byte xMSB = readRegister(L3G4200D_Address, 0x29);
  byte xLSB = readRegister(L3G4200D_Address, 0x28);
  x = ((xMSB << 8) | xLSB);

  byte yMSB = readRegister(L3G4200D_Address, 0x2B);
  byte yLSB = readRegister(L3G4200D_Address, 0x2A);
  y = ((yMSB << 8) | yLSB);

  byte zMSB = readRegister(L3G4200D_Address, 0x2D);
  byte zLSB = readRegister(L3G4200D_Address, 0x2C);
  z = ((zMSB << 8) | zLSB);
}

int setupL3G4200D(int scale)
{
  //From  Jim Lindblom of Sparkfun's code

  // Enable x, y, z and turn off power down:
  writeRegister(L3G4200D_Address, CTRL_REG1, 0b00001111);

  // If you'd like to adjust/use the HPF, you can edit the line below to configure CTRL_REG2:
  writeRegister(L3G4200D_Address, CTRL_REG2, 0b00000000);

  // Configure CTRL_REG3 to generate data ready interrupt on INT2
  // No interrupts used on INT1, if you'd like to configure INT1
  // or INT2 otherwise, consult the datasheet:
  writeRegister(L3G4200D_Address, CTRL_REG3, 0b00001000);

  // CTRL_REG4 controls the full-scale range, among other things:
  if (scale == 250) {
    writeRegister(L3G4200D_Address, CTRL_REG4, 0b00000000);
  } else if (scale == 500) {
    writeRegister(L3G4200D_Address, CTRL_REG4, 0b00010000);
  } else {
    writeRegister(L3G4200D_Address, CTRL_REG4, 0b00110000);
  }

  // CTRL_REG5 controls high-pass filtering of outputs, use it
  // if you'd like:
  writeRegister(L3G4200D_Address, CTRL_REG5, 0b00000000);
}

void writeRegister(int deviceAddress, byte address, byte val)
{
  Wire.beginTransmission(deviceAddress); // start transmission to device
  Wire.write(address);       // send register address
  Wire.write(val);         // send value to write
  Wire.endTransmission();     // end transmission
}

int readRegister(int deviceAddress, byte address)
{
  int v;
  Wire.beginTransmission(deviceAddress);
  Wire.write(address); // register to read
  Wire.endTransmission();

  Wire.requestFrom(deviceAddress, 1); // read a byte

  while (!Wire.available())
  {
    // waiting
  }
  v = Wire.read();
  return v;
}

float leakyBuffer = 0;

float leakyIntegrator(float value_, float leakRate_){
  leakyBuffer = leakyBuffer + value_;
  leakyBuffer = leakyBuffer * leakRate_;
  return leakyBuffer;
}

