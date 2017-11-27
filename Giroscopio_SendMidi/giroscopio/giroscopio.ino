// Programa : Teste Giroscopio L3G4200D
// Adaptacoes : Arduino e Cia

#include <Wire.h>
#include "MIDIUSB.h"

#define CTRL_REG1 0x20
#define CTRL_REG2 0x21
#define CTRL_REG3 0x22
#define CTRL_REG4 0x23
#define CTRL_REG5 0x24

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
void setup()
{
  Wire.begin();
  Serial.begin(38400);

  Serial.println("Inicializando o L3G4200D");
  // Configura o L3G4200 para 200, 500 ou 2000 graus/seg
  setupL3G4200D(2000);

  // Aguarda a resposta do sensor
  delay(1500);
  leaky[1] = 0;

}





void loop()
{
  // Atualiza os valores de X, Y e Z
  getGyroValues();
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
  
  channel = 2 ;
  
 //saxValue = 0 , tromboneValue = 1, trompeteValue=2 ,percussaoValue=3, batutaValue=4 ;
  //volume midi value
  volume = map(shake, 0, 200, 20, 127);
  volume = (int) constrain(volume, 0,127);
  Serial.print(channel);
  Serial.print(" ");
  Serial.print(volume);
  Serial.print(" ");
  Serial.print("aloha");
  Serial.println();
  controlChange(channel,0,volume);
  MidiUSB.flush();

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

