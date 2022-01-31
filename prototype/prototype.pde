import processing.serial.*;
import cc.arduino.*;
import mqtt.*;

Arduino arduino;
MQTTClient client;

String username = "Tala";
String server = "mqtt://datt3700cheetah:KfxJW3nkWpbcqD2m@datt3700cheetah.cloud.shiftr.io";
int arduinoPort = 13;

int alexisPIN = 8;
int jamesPIN = 9;
int talaPIN = 10;
int resetPIN = 2;

boolean alexis = false;
boolean james = false;
boolean tala = false;
boolean reset = false;

void settings() {
  size(400, 400);
}

void messageReceived(String topic, byte[] payload) {
  //println("new message: " + topic + " - " + new String(payload));
  
  if (topic.equals("/LAB1CHEETAH/ALEXIS")) {
    String alexisStr = new String(payload);
    alexis = boolean(alexisStr);
  } else if (topic.equals("/LAB1CHEETAH/JAMES")) {
    String jamesStr = new String(payload);
    james = boolean(jamesStr);
  } else if (topic.equals("/LAB1CHEETAH/TALA")) {
    String talaStr = new String(payload);
    tala = boolean(talaStr);
  } else if (topic.equals("/LAB1CHEETAH/RESET")) {
    String resetStr = new String(payload);
    reset = boolean(resetStr);
  }
}

void setup() {
  
  println(Arduino.list());
  arduino = new Arduino(this, Arduino.list()[arduinoPort], 57600);
  
  arduino.pinMode(resetPIN, Arduino.INPUT);
  arduino.pinMode(alexisPIN, Arduino.OUTPUT);
  arduino.pinMode(jamesPIN, Arduino.OUTPUT);
  arduino.pinMode(talaPIN, Arduino.OUTPUT);
    
  client = new MQTTClient(this);
  client.connect(server, username);
  
  client.subscribe("/LAB1CHEETAH/TALA");
  client.subscribe("/LAB1CHEETAH/JAMES");
  client.subscribe("/LAB1CHEETAH/ALEXIS");
  client.subscribe("/LAB1CHEETAH/RESET");
}

void draw() {
  
  background(0);
  
  if (reset) {
    alexis = false;
    james = false;
    tala = false;
    client.publish("/LAB1CHEETAH/ALEXIS", str(alexis));
    client.publish("/LAB1CHEETAH/JAMES", str(james));
    client.publish("/LAB1CHEETAH/TALA", str(tala));
    arduino.digitalWrite(alexisPIN, Arduino.LOW);
    arduino.digitalWrite(jamesPIN, Arduino.LOW);
    arduino.digitalWrite(talaPIN, Arduino.LOW);
    background(0);
    reset = false;
    client.publish("/LAB1CHEETAH/RESET", str(reset));
  } 
  
   if (alexis)
     arduino.digitalWrite(alexisPIN, Arduino.HIGH);
   else
     arduino.digitalWrite(alexisPIN, Arduino.LOW);
      
   //println(alexis);
    
   if (james)
     arduino.digitalWrite(jamesPIN, Arduino.HIGH);
   else
     arduino.digitalWrite(jamesPIN, Arduino.LOW);
    
   if (tala)
     arduino.digitalWrite(talaPIN, Arduino.HIGH);
   else
     arduino.digitalWrite(talaPIN, Arduino.LOW);

   if (alexis && james && tala) {
     background(200, 100, 100);
   } 
  
   if (arduino.digitalRead(resetPIN) == 1) {
     reset = true;
     client.publish("/LAB1CHEETAH/RESET", str(reset));
   }
}

void keyPressed() {
  
  if (key == 'a' || key == 'A') {
    alexis = true;
    client.publish("/LAB1CHEETAH/ALEXIS", str(alexis));
  } else if (key == 'j' || key == 'J') {
    james = true;
    client.publish("/LAB1CHEETAH/JAMES", str(james));
  } else if (key == 't' || key == 'T') {
    tala = true;
    client.publish("/LAB1CHEETAH/TALA", str(tala));
  } 
}

void clientConnected() {
  println("client connected");
}

void connectionLost() {
  println("connection lost");
}
