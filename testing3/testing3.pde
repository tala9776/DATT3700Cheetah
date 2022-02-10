/* This test code is supposed to be able to:
  A) switch between the two videos by pressing keys (videos should be without a loop)
  B) switch between the videos in a way that the transformations look seemless
  C) switch videos based on the data coming from TouchOSC
  
  current issue: video will not work/look smooth by adding a frame rate
*/


import processing.serial.*;
import cc.arduino.*;
import mqtt.*;
import processing.video.*;
import oscP5.*;
import netP5.*;

OscP5 osc;

PImage img;
Movie video1;
Movie video2;

String vidName1 = "Basic_Tree_Copy.mp4";
String vidName2 = "treeReversed.mp4";

float x = 0.0;
float y = 0.0;
float newX = 0.0;
float newY = 0.0;
float currentTime;
float jumpTime;
boolean first = true;
int timer = 0;
boolean playReversed = false;

float vid1Duration;
float vid2Duration;

void setup() {
  size(1280, 720);
  //frameRate(24);
  
  video1 = new Movie(this, vidName1);
  video1.loop();
  
  video2 = new Movie(this, vidName2);
  video2.loop();
}

void movieEvent(Movie vid) {
  vid.read();
}

void draw() {
  
  movieEvent(video1);
  movieEvent(video2);
  
  
    
    if (playReversed) {
    //jumpTime = video2.duration() - video1.time();
    video1.pause();
    image(video2, 0, 0);
    //video2.jump(0);
    video2.play();
    //video2.speed(0.5);
    //video2.jump(jumpTime);
    //video2.play();
    video2.volume(0.3);
    
    if (timer == 0)
      playReversed = false;
    else
      timer -= 10;
    
    }
    else {
      //jumpTime = video1.duration() - video2.time();
      video2.pause();
      image(video1, 0, 0);
      //video1.jump(0);
      video1.play();
      //video1.speed(0.5);
      //video1.jump(jumpTime);
      //video1.play();
      video1.volume(0.3);
    
      if (timer == 2000)
        playReversed = true;
      else
        timer += 10;
    }
  
}

void keyPressed() {

  if (key == 'a' || key == 'A') {
    jumpTime = video2.duration() - video1.time();
    video1.pause();
    image(video2, 0, 0);
    video2.play();
    video2.speed(0.5);
    //video2.jump(jumpTime);
    //video2.play();
    video2.volume(0.3);
  }
  else if (key == 'b' || key == 'B') {
    jumpTime = video1.duration() - video2.time();
    video2.pause();
    image(video1, 0, 0);
    video1.play();
    video1.speed(0.5);
    //video1.jump(jumpTime);
    //video1.play();
    video1.volume(0.3);
  }

}
