import oscP5.*;
import netP5.*;

OscP5 osc;

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

float x = 0.0;
float y = 0.0;
float newX = 0.0;
float newY = 0.0;

int timer = 11;

boolean aMemberPresent = false;

void setup() {
  size(1280, 720);
  frameRate(25);
  
  img1 = loadImage(imgName1);
  img2 = loadImage(imgName2);
  img3 = loadImage(imgName3);
  img4 = loadImage(imgName4);
  img5 = loadImage(imgName5);
  img6 = loadImage(imgName6);
  
  osc = new OscP5(this, 8000);
}

void draw() { 
  
  if(newX == x && newY == y)
    aMemberPresent = false;
  else {
    x = newX;
    y = newY;
    aMemberPresent = true;
  }
  
  if (timer > 15 && !aMemberPresent) {
    timer -= 5;
    imageDisplay();
  }
  
  else if (timer > 10 && timer < 100) {
    imageDisplay();
    
    if (aMemberPresent) {
      memberDisaplay();
      timer += 10;
    }
  }
  
  else if (timer > 100 && timer < 200) {
    imageDisplay();
    
    if (aMemberPresent) {
      memberDisaplay();
      timer += 10;
    }
  }
  
  else if (timer > 200 && timer < 300) {
    imageDisplay();
    
    if (aMemberPresent) {
      memberDisaplay();
      timer += 10;
    }
  }
  
  else if (timer > 300 && timer < 400) {
    imageDisplay();
    
    if (aMemberPresent) {
      memberDisaplay();
      timer += 10;
    }
  }
  
  else if (timer > 400 && timer < 500) {
    imageDisplay();
    
    if (aMemberPresent) {
      memberDisaplay();
      timer += 10;
    }
  }
  
  else if (timer > 500) {
    imageDisplay();
    
    if (aMemberPresent) {
      memberDisaplay();
      timer = 600;
    }
  }
}

void memberDisaplay() {
    fill(200, 100, 100);
    ellipse((x + 1) / 2 * 50, (y + 1.25) / 2 * 50, 50, 50);
    
    fill(0, 0, 0);
    ellipse((x + 4) / 2 * 50, (y + 1.25) / 2 * 50, 50, 50);

    fill(100, 150, 200);
    ellipse((x + 7) / 2 * 50, (y + 1.25) / 2 * 50, 50, 50);
}

void imageDisplay() {

  if (timer > 10 && timer < 100)
    image(img1, 0, 0);
  
  else if (timer > 100 && timer < 200)
    image(img2, 0, 0);
  
  else if (timer > 200 && timer < 300)
    image(img3, 0, 0);
  
  else if (timer > 300 && timer < 400)
    image(img4, 0, 0);

  else if (timer > 400 && timer < 500)
    image(img5, 0, 0);
  
  else if (timer > 500)
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
