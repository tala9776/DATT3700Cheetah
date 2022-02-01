import processing.video.*;

String PATH = "C:/Users/alxse/Desktop/DATT_3700/PlayVideo/RickRolled.mp4";
String PATH2 = "C:/Users/alxse/Desktop/DATT_3700/PlayVideo/Countdown.mp4";
//change your path here

Movie vid; 
Movie vid2;

void setup() {
  size(640,360);
  frameRate(25);
  vid = new Movie(this,PATH);
  vid2 = new Movie(this,PATH2);
  
}

void movieEvent(Movie v){
  v.read();
}

void draw() {
  image(vid, 0, 0, width, height);
  image(vid2, 0, 0, width, height);
}

void keyPressed() {
  
  if (key == 'q' || key == 'Q') {
  vid.play();
  vid.volume(0.3);}
  
  else if (key == 'a' || key == 'A') {
  vid.pause();
  vid2.play();
  vid2.volume(0.2);
  }
  
}
