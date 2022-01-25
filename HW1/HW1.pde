import mqtt.*;

MQTTClient client;
String username = "TALA";
static final String server = "mqtt://datt3700cheetah:KfxJW3nkWpbcqD2m@datt3700cheetah.cloud.shiftr.io";

int talaCount = 1;
int talaCounter;

int alexisCount = 0;
int alexisCounter;
int rectColour;

int jamesCount = 0;
int jamesCounter;
int jamesX;
int jamesY;

void settings() {
  size(400, 400);
}

void messageReceived(String topic, byte[] payload) {
  //println("new message: " + topic + " - " + new String(payload));
  
  if (topic.equals("TALAsTOPIC")) {
      talaCounter = int(new String(payload));
      println("Counter/Tala - " + (talaCounter));
  }
  
  else if (topic.equals("JAMESsTOPIC")) {
    jamesCounter = int(new String(payload));
    println("Counter/James - " + (jamesCounter));
  }

  else if (topic.equals("JAMESsXTOPIC")) {
    jamesX = int(new String(payload));
    println("Counter/James X - " + (jamesX));
  }
  
  else if (topic.equals("JAMESsYTOPIC")) {
    jamesY = int(new String(payload));
    println("Counter/James Y - " + (jamesY));
  }

  else if (topic.equals("ALEXISsTOPIC")) {
    alexisCounter = int(new String(payload));
    println("Counter/Alexis - " + (alexisCounter));
  }
}

void setup() {
  
  client = new MQTTClient(this);
  client.connect(server, username);
  client.subscribe("TALAsTOPIC");
  client.subscribe("JAMESsTOPIC");
  client.subscribe("JAMESsXTOPIC");
  client.subscribe("JAMESsYTOPIC");
  client.subscribe("ALEXISsTOPIC");
}

void draw() {
  
  background(0);
  
  if (talaCounter % 2 == 0) 
    background(0);
  else
    background(200, 100, 100);
    
  if (alexisCounter != 0) {
     
    if (alexisCounter % 2 == 0) 
      rectColour = 255;
    else
      rectColour = 155;
    
    fill(rectColour);
  
    if (jamesCounter == 0)
      rect(175, 175, 50, 50);
    else
      rect(jamesX - 25, jamesY - 25, 50, 50);
   }
}

void keyPressed() {
  
  client.publish("/TALAsTOPIC", str(talaCount));
  talaCount++;
}

void mouseClicked() {

  alexisCount++;
  client.publish("/ALEXISsTOPIC", str(alexisCount));
}

void mouseDragged() {

  client.publish("/JAMESsXTOPIC", str(mouseX));
  client.publish("/JAMESsYTOPIC", str(mouseY));
  client.publish("/JAMESsTOPIC", str(jamesCount));
  jamesCount++;
}

void clientConnected() {
  println("client connected");
}

void connectionLost() {
  println("connection lost");
}

//it's Tala
