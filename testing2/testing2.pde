

/*
import oscP5.*;
import netP5.*;

float x, y, targetX, targetY;

OscP5 oscP5;
NetAddress myRemoteLocation;

void setup() {
  size(400,400);
  frameRate(25);
  
  
  oscP5 = new OscP5(this,8000);
  
  noStroke();
  background(218, 123, 240);
}

void draw() {
  // targetX and targetY are updated in void oscEvent.
  // First, apply some smoothing (look up "easing" for more info)
  x = x + (targetX - x) * .2;
  y = y + (targetY - y) * .2;

  // fade the trails by overlaying the background colour with transparency
  fill(218, 123, 240, 30);
  rect(0, 0, width, height);

  // Draw an ellipse
  fill(255, 255, 0);
  ellipse (x, y, 20, 20);
}

void oscEvent(OscMessage theOscMessage) {
  if(theOscMessage.checkAddrPattern("/accxyz")==true) {
    if(theOscMessage.checkTypetag("fff")) {
      // Use two of the three values for x & y
      targetX = (theOscMessage.get(0).floatValue() + 1) / 2 * width;
      targetY = (theOscMessage.get(1).floatValue() + 1) / 2 * height;
      println(x);
      return;
    }  
  } 
}



*/


import oscP5.*;
import netP5.*;

OscP5 osc;

float x = 0.0;
float y = 0.0;
float newX = 0.0;
float newY = 0.0;

void setup() {
  size(100, 100);
  frameRate(25);
  
  osc = new OscP5(this, 8000);
}

void draw() {
  
  background(0);
  
  if(newX == x && newY == y)
    background(0);
  else {
    background(200, 100, 100);
    x = newX;
    y = newY;
  }
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
