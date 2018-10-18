import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class shootingstar_2 extends PApplet {

int numLines = 100;
int numValues = 4;
int lineMin = 5;
int lineMax = 20;
int speedMin = 1;
int speedMax = 4;
int strokeColor = 200;
int strokeCurrent = 255;
// Declare 2D array
int[][] lines = new int[numLines][numValues];
int[] colors = new int[3];

public void setup() {
  // size(window.innerWidth, window.innerHeight);
  
  // background(255);
  background(0,0,40);
  frameRate(96);
  for (int i = 0; i < numLines; i++) {
     lines[i][0] = PApplet.parseInt(random(width));//origin x
     lines[i][1] = PApplet.parseInt(random(height));//origin y
     lines[i][2] = PApplet.parseInt(random(lineMin,lineMax));//offset x
     lines[i][3] = PApplet.parseInt(random(speedMin,speedMax));
  }
}

public void start(){
  loop();
}

public int[] newLine(){
  int[] line = new int[4];
  //determine canvas entry point
  if (random(1) > 0.5f){
    line[0] = PApplet.parseInt(random(width));//origin x
    line[1] = 0;//origin y
  } else {
    line[0] = 0;//origin x
    line[1] = PApplet.parseInt(random(width));//origin y
  }
  line[2] = PApplet.parseInt(random(lineMin,lineMax));//offset x
  line[3] = PApplet.parseInt(random(speedMin,speedMax));
  // back one step
  line[0] -= line[2];
  line[1] -= line[2]*2;

  return line;
}

public void draw() {
  // background(255);
  background(0,0,40);


  // draw the stars
  // the stars seem to show best with black outlines that aren't really perceived by the eye
  // stroke(0);
  // strokeWeight(1);
  // for (int i = 0; i < starX.length; i++) {
  //   fill(random(50,255)); // makes them twinkle
  //   if (random(10) < 1) {
  //     starColor[i] = (int)random(100,255);
  //   }
  //   fill(starColor[i]);
  //
  //   ellipse(starX[i], starY[i], starSize, starSize);
  // }

  colors[0] = PApplet.parseInt(random(0, 255));
  colors[1] = PApplet.parseInt(random(0, 255));
  colors[2] = PApplet.parseInt(random(0, 255));

  if (strokeCurrent > strokeColor) {
    // stroke(strokeCurrent--);
    stroke(colors[0], colors[1], colors[2]);
  }
  // Draw points
  for (int i = 0; i < numLines; i++) {
    // Move x point by speed
    lines[i][0] += lines[i][3];
    // Move y point by speed * 2
    lines[i][1] += lines[i][3]*2;
    if (lines[i][0] > width || lines[i][1] > height) {
      lines[i] = newLine();
    }
    line(lines[i][0],lines[i][1],lines[i][0]+lines[i][2],lines[i][1]+(lines[i][2]*2));
  }
}
  public void settings() {  size(1000, 800); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "shootingstar_2" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
