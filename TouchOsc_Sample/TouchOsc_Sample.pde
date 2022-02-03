import netP5.*;
import oscP5.*;

OscP5 oscP5;

void setup() {
  size(400,400);
  frameRate(25);
  oscP5 = new OscP5(this, 8000);
  
  //initalize & instantiate two plugs
  //f1 is the method
  //f1 is gonna listen to /1
  //message will be coming from fader1
  oscP5.plug(this, "f1", "/1/fader1");
  oscP5.plug(this, "f2", "/1/fader2");
}

public void f1(float f1Value){
  println(" float f1 received: " + f1Value);
}

public void f2(float f2Value){
  println(" float f2 received: " + f2Value);
}

void draw(){
  background(0);
}

void oscEvent(OscMessage theOscMessage) {
  if (theOscMessage.isPlugged() == false) {
    println("### received an osc message.");
    println("### addrpattern\t" + theOscMessage.addrPattern());
    println("### typetag\t" + theOscMessage.typetag());
  }
}
