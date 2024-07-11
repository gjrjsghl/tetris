#include <SoftwareSerial.h>

#define RXD 8
#define TXD 7
SoftwareSerial bluetooth(RXD,TXD);

int X = A0;
int Y = A1;
int SW = 2;


void setup() {
  // put your setup code here, to run once:
  Serial.begin(9600);
  bluetooth.begin(9600);


  pinMode(SW, INPUT_PULLUP);
  pinMode(X, INPUT);
  pinMode(Y, INPUT);
}

void loop() {
  // put your main code here, to run repeatedly:

  if(digitalRead(SW) == 0) {
    bluetooth.write("G");
  }
  else if(analogRead(X) > 1000) {
    bluetooth.write("L");
  }
  else if(analogRead(X) < 100){
    bluetooth.write("R");
  }
  else if(analogRead(Y) > 1000) {
    bluetooth.write("T");
  }
  else if(analogRead(Y) < 100) {
    bluetooth.write("D");
  }
  delay(150);

}
