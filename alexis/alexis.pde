//import processing.serial.*;
//import cc.arduino.*;
import mqtt.*;
import oscP5.*;
import netP5.*;

OscP5 osc;
MQTTClient client;
//Arduino arduino;

class Member {
  int memberID;
  String colour;
  boolean present;
  float x;
  float y;
}

String username = "Alexis";
String server = "mqtt://datt3700:datt3700experiments@datt3700.cloud.shiftr.io";
//int arduinoPort = 13;

PImage img1;
PImage img2;
PImage img3;
PImage img4;
PImage img5;
PImage img6;

String imgName1 = "Tree_No_Leaves.png";
String imgName2 = "Tree_Leaves_1.png";
String imgName3 = "Tree_Leaves_2.png";
String imgName4 = "Tree_Leaves_3.png";
String imgName5 = "Tree_Leaves_4.png";
String imgName6 = "Tree_Leaves_5.png";

float alexisX = 0.0;
float alexisY = 0.0;
float newX = 0.0;
float newY = 0.0;

float talaX;
float talaY;
float jamesX;
float jamesY;

int timer = 11;

boolean aMemberPresent = false;
boolean allMembersPresent = false;
boolean alexisPresent = false;
boolean jamesPresent = false;
boolean talaPresent = false;

//Member[] members;

void messageReceived(String topic, byte[] payload) {
  //println("new message: " + topic + " - " + new String(payload));
  
  /* if (topic.equals("/LAB1CHEETAH/ALEXIS")) {
    String alexisStr = new String(payload);
    alexisPresent = boolean(alexisStr);
  } else if (topic.equals("/LAB1CHEETAH/ALEXISX")) {
    String alexisXStr = new String(payload);
    alexisX = float(alexisXStr);
  } else if (topic.equals("/LAB1CHEETAH/ALEXISY")) {
    String alexisYStr = new String(payload);
    alexisY = float(alexisYStr);
  } else */ 
  
  if (topic.equals("/LAB1CHEETAH/JAMES")) {
    String jamesStr = new String(payload);
    jamesPresent = boolean(jamesStr);
  } else if (topic.equals("/LAB1CHEETAH/JAMESX")) {
    String jamesXStr = new String(payload);
    jamesX = float(jamesXStr);
  } else if (topic.equals("/LAB1CHEETAH/JAMESY")) {
    String jamesYStr = new String(payload);
    jamesY = float(jamesYStr);
  } else if (topic.equals("/LAB1CHEETAH/TALA")) {
    String talaStr = new String(payload);
    talaPresent = boolean(talaStr);
  } else if (topic.equals("/LAB1CHEETAH/TALAX")) {
    String talaXStr = new String(payload);
    talaX = float(talaXStr);
  } else if (topic.equals("/LAB1CHEETAH/TALAY")) {
    String talaYStr = new String(payload);
    talaY = float(talaYStr);
  } else if (topic.equals("/LAB1CHEETAH/TIMER")) {
    String timerStr = new String(payload);
    timer = int(timerStr);
  } 
  
}

void setup() {
  size(1280, 720);
  frameRate(25);
  
  /*
  println(Arduino.list());
  arduino = new Arduino(this, Arduino.list()[arduinoPort], 57600);
    
  arduino.pinMode(resetPIN, Arduino.INPUT);
  arduino.pinMode(alexisPIN, Arduino.OUTPUT);
  arduino.pinMode(jamesPIN, Arduino.OUTPUT);
  arduino.pinMode(talaPIN, Arduino.OUTPUT);
  */
  
  client = new MQTTClient(this);
  client.connect(server, username);
  
  client.subscribe("/LAB1CHEETAH/TALA");
  client.subscribe("/LAB1CHEETAH/TALAX");
  client.subscribe("/LAB1CHEETAH/TALAY");
  client.subscribe("/LAB1CHEETAH/JAMES");
  client.subscribe("/LAB1CHEETAH/JAMESX");
  client.subscribe("/LAB1CHEETAH/JAMESY");
  //client.subscribe("/LAB1CHEETAH/ALEXIS");
  //client.subscribe("/LAB1CHEETAH/ALEXISX");
  //client.subscribe("/LAB1CHEETAH/ALEXISY");
  client.subscribe("/LAB1CHEETAH/TIMER");
  
  img1 = loadImage(imgName1);
  img2 = loadImage(imgName2);
  img3 = loadImage(imgName3);
  img4 = loadImage(imgName4);
  img5 = loadImage(imgName5);
  img6 = loadImage(imgName6);
  
  osc = new OscP5(this, 8000);
  
  //members = new Member[10];
}

void draw() { 
  
  if(newX == alexisX && newY == alexisY) {
    alexisPresent = false;
    client.publish("/LAB1CHEETAH/ALEXIS", str(alexisPresent));
  } else {
    alexisX = newX;
    alexisY = newY;
    alexisPresent = true;
    client.publish("/LAB1CHEETAH/ALEXIS", str(alexisPresent));
    client.publish("/LAB1CHEETAH/ALEXISX", str(alexisX));
    client.publish("/LAB1CHEETAH/ALEXISY", str(alexisY));
  }
  
  if (talaPresent && alexisPresent && jamesPresent) {
    aMemberPresent = true;
    allMembersPresent = true;
  } else if (talaPresent || alexisPresent || jamesPresent) {
    aMemberPresent = true;
    allMembersPresent = false;
  } else {
    aMemberPresent = false;
    allMembersPresent = false;
  }
  
  if (timer > 15 && !allMembersPresent) {
    //timer -= 5;
    //client.publish("/LAB1CHEETAH/TIMER", str(timer));
    imageDisplay();
  }
  
  else if (timer > 10 && timer < 250) {
    imageDisplay();
    
    if (aMemberPresent) {
      memberDisaplay();
    }
    /*
    if (allMembersPresent) {
      timer += 10;
      client.publish("/LAB1CHEETAH/TIMER", str(timer));
    } */
  }
  
  else if (timer > 250 && timer < 500) {
    imageDisplay();
    
    if (aMemberPresent) {
      memberDisaplay();
    }
    /*
    if (allMembersPresent) {
      timer += 10;
      client.publish("/LAB1CHEETAH/TIMER", str(timer));
    } */
  }
  
  else if (timer > 500 && timer < 750) {
    imageDisplay();
    /*
    if (allMembersPresent) {
      timer += 10;
      client.publish("/LAB1CHEETAH/TIMER", str(timer));
    } */   
  }
  
  else if (timer > 750 && timer < 1000) {
    imageDisplay();
    
    if (aMemberPresent) {
      memberDisaplay();
    }
    /*
    if (allMembersPresent) {
      timer += 10;
      client.publish("/LAB1CHEETAH/TIMER", str(timer));
    } */
  }
  
  else if (timer > 1000 && timer < 1250) {
    imageDisplay();
    
    if (aMemberPresent) {
      memberDisaplay();
    }
    /*
    if (allMembersPresent) {
      timer += 10;
      client.publish("/LAB1CHEETAH/TIMER", str(timer));
    } */
  }
  
  else if (timer > 1250) {
    imageDisplay();
    
    if (aMemberPresent) {
      memberDisaplay();
    }
    /*
    if (allMembersPresent) {
      timer += 10;
      client.publish("/LAB1CHEETAH/TIMER", str(timer));
    } */
  }
}

void memberDisaplay() {
  
  if (talaPresent) {
    fill(200, 100, 100);
    ellipse((talaX + 1) / 2 * 50, (talaY + 1.25) / 2 * 50, 50, 50);
  }
  
  if (jamesPresent) {
    fill(0, 0, 0);
    ellipse((jamesX + 4) / 2 * 50, (jamesY + 1.25) / 2 * 50, 50, 50);
  }
  
  if (alexisPresent) {
    fill(100, 150, 200);
    ellipse((alexisX + 7) / 2 * 50, (alexisY + 1.25) / 2 * 50, 50, 50);
  }

}

void imageDisplay() {

  if (timer > 10 && timer < 250)
    image(img1, 0, 0);
  
  else if (timer > 250 && timer < 500)
    image(img2, 0, 0);
  
  else if (timer > 500 && timer < 750)
    image(img3, 0, 0);
  
  else if (timer > 750 && timer < 1000)
    image(img4, 0, 0);

  else if (timer > 1000 && timer < 1250)
    image(img5, 0, 0);
  
  else if (timer > 1250)
    image(img6, 0, 0);
}

void oscEvent(OscMessage theOscMessage) {

  if(theOscMessage.checkAddrPattern("/3/xy") == true) {
      println("### received an osc message: ");
      println("### addpattern\t" + theOscMessage.addrPattern());
      println("### typetag\t" + theOscMessage.typetag());
      
      newX = theOscMessage.get(0).floatValue();
      newY = theOscMessage.get(1).floatValue();
      
      println("X: " + newX + ", Y: " + newY);
  }
}
