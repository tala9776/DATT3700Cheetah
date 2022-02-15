import mqtt.*;
import oscP5.*;
import netP5.*;

class Member {
  int memberID;
  String colour;
  boolean present;
  float x;
  float y;
}

OscP5 osc;
MQTTClient client;

String username = "Tala";
String server = "mqtt://datt3700cheetah:KfxJW3nkWpbcqD2m@datt3700cheetah.cloud.shiftr.io";
//String server = "mqtt://datt3700:datt3700experiments@datt3700.cloud.shiftr.io";

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
int numOfMembers = 10;
int myMemberID;
int membersCount = 0;

Member[] members;

boolean aMemberPresent = false;
boolean allMembersPresent = false;
boolean first = true;
boolean newMember = false;

void messageReceived(String topic, byte[] payload) {
  //println("new message: " + topic + " - " + new String(payload));
  
  if (topic.equals("/LAB1CHEETAH/TIMER")) {
    String timerStr = new String(payload);
    timer = int(timerStr);
  } else if (topic.equals("/LAB1CHEETAH/MEMBERCOUNT")) {
    String countStr = new String(payload);
    membersCount = int(countStr);
  } else if (topic.equals("/LAB1CHEETAH/NEWMEMBER")) {
    String newStr = new String(payload);
    newMember = boolean(newStr);
  }
  
  String presenceStr;
  String xStr;
  String yStr;
  
  if (membersCount > 0) {
    for (int i = 0; i < membersCount; i++) {
      if (topic.equals("/LAB1CHEETAH/" + i + "/PRESENCE")) {
        presenceStr = new String(payload);
        members[i].present = boolean(presenceStr);
      } else if (topic.equals("/LAB1CHEETAH/" + i + "/X")) {
        xStr = new String(payload);
        members[i].x = float(xStr);
      } else if (topic.equals("/LAB1CHEETAH/" + i + "/Y")) {
        yStr = new String(payload);
        members[i].y = float(yStr);
      }
    }
  }
}

void setup() {
  size(1280, 720);
  frameRate(25);
  
  client = new MQTTClient(this);
  client.connect(server, username);
  
  for (int i = 0; i < numOfMembers; i++) {
    client.subscribe("/LAB1CHEETAH/" + i);
    client.subscribe("/LAB1CHEETAH/" + i + "/PRESENCE");
    client.subscribe("/LAB1CHEETAH/" + i + "/X");
    client.subscribe("/LAB1CHEETAH/" + i + "/Y");
  }
  client.subscribe("/LAB1CHEETAH/NEWMEMBER");
  client.subscribe("/LAB1CHEETAH/MEMBERCOUNT");
  client.subscribe("/LAB1CHEETAH/TIMER");
  
  img1 = loadImage(imgName1);
  img2 = loadImage(imgName2);
  img3 = loadImage(imgName3);
  img4 = loadImage(imgName4);
  img5 = loadImage(imgName5);
  img6 = loadImage(imgName6);
  
  osc = new OscP5(this, 8000);
  
  members = new Member[numOfMembers];
}

void draw() { 
  
  if (first) {
    newMember = true;
    client.publish("/LAB1CHEETAH/NEWMEMBER", str(newMember));
    myMemberID = membersCount;
    addNewMember();
    first = false;
  }
 
  if (newMember)
    newMemberAdded();
     
  checkMyPresence();
  checkForAMember();
  checkForAllMembers();
  activityTracker();
}

void addNewMember() {

    members[membersCount] = new Member();
    members[membersCount].memberID = membersCount;
    members[membersCount].present = false;
    members[membersCount].x = 0.0;
    members[membersCount].y = 0.0;
    
    client.publish("/LAB1CHEETAH/" + membersCount, str(membersCount));
    client.publish("/LAB1CHEETAH/" + membersCount + "/PRESENCE", str(members[membersCount].present));
    client.publish("/LAB1CHEETAH/" + membersCount + "/X", str(members[membersCount].x));
    client.publish("/LAB1CHEETAH/" + membersCount + "/Y", str(members[membersCount].y));
    
    membersCount++;
    client.publish("/LAB1CHEETAH/MEMBERCOUNT", str(membersCount));
    
    newMember = false;
    //client.publish("/LAB1CHEETAH/NEWMEMBER", str(newMember));
}

void newMemberAdded() {
  
  if (membersCount - 1 != myMemberID) {
    members[membersCount] = new Member();
    members[membersCount].memberID = membersCount;
    members[membersCount].present = false;
    members[membersCount].x = 0.0;
    members[membersCount].y = 0.0;  
    membersCount++;
  }
  
  newMember = false;
  //client.publish("/LAB1CHEETAH/NEWMEMBER", str(newMember));
}

void checkMyPresence() {

  if(newX == members[myMemberID].x && newY == members[myMemberID].y) {
    members[myMemberID].present = false;
    client.publish("/LAB1CHEETAH/" + myMemberID + "/PRESENCE", str(members[myMemberID].present));
  } else {
    members[myMemberID].x = newX;
    members[myMemberID].y = newY;
    members[myMemberID].present = true;
    
    client.publish("/LAB1CHEETAH/" + myMemberID + "/PRESENCE", str(members[myMemberID].present));
    client.publish("/LAB1CHEETAH/" + myMemberID + "/X", str(members[myMemberID].x));
    client.publish("/LAB1CHEETAH/" + myMemberID + "/Y", str(members[myMemberID].y));
  }
}

void checkForAMember() {
  
  for (int i = 0; i < membersCount; i++) {
    if (members[i].present) {
      aMemberPresent = true;
      break;
    }
      aMemberPresent = false;
  }
}

void checkForAllMembers() {
  
  for (int i = 0; i < membersCount; i++) {
    if (!members[i].present) {
      allMembersPresent = false;
      break;
    }
      allMembersPresent = true;
  }
}

void activityTracker() {

  if (timer > 10 && !allMembersPresent) {
    //timer -= 5;
    //client.publish("/LAB1CHEETAH/TIMER", str(timer));
    imageDisplay();
  }
  
  else if (timer > 5 && timer < 250) {
    imageDisplay();
    
    if (aMemberPresent) {
      membersDisplay();
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
      membersDisplay();
    }
    /*
    if (allMembersPresent) {
      timer += 10;
      client.publish("/LAB1CHEETAH/TIMER", str(timer));
    } */
  }
  
  else if (timer > 500 && timer < 750) {
    imageDisplay();
    
    if (aMemberPresent) {
      membersDisplay();
    }
    /*
    if (allMembersPresent) {
      timer += 10;
      client.publish("/LAB1CHEETAH/TIMER", str(timer));
    } */
  }
  
  else if (timer > 750 && timer < 1000) {
    imageDisplay();
    
    if (aMemberPresent) {
      membersDisplay();
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
      membersDisplay();
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
      membersDisplay();
    }
    /*
    if (allMembersPresent) {
      timer += 10;
      client.publish("/LAB1CHEETAH/TIMER", str(timer));
    } */
  }
}

void membersDisplay() {
  
  for (int i = 0; i < membersCount; i++) {
    
    if (members[i].memberID == 0)
      fill(200, 100, 100);    
    else if ((members[i].memberID + 1) % 2 == 0)
      fill(0, 0, 0);    
    else if ((members[i].memberID + 1) % 3 == 0)
      fill(100, 150, 200);      
    else
      fill(200, 100, 100);
      
    ellipse((members[i].x + 1 + (i * 3)) / 2 * 50, (members[i].y + 1.25) / 2 * 50, 50, 50);
  }
}

void imageDisplay() {

  if (timer > 5 && timer < 250)
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
