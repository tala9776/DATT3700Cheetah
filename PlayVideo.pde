import processing.video.*;

String PATH = "C:/Users/alxse/Desktop/DATT_3700/PlayVideo/RickRolled.mp4";


Movie vid; 

void setup() {
  size(640,360);
  frameRate(25);
  vid = new Movie(this,PATH);
  vid.play();
  vid.volume(0.3);
}

void movieEvent(Movie v){
  v.read();
}

void draw() {
  image(vid, 0, 0, width, height);
}

/*void keyPressed() {

  
}*/
