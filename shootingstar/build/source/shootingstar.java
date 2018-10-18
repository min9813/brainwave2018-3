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

public class shootingstar extends PApplet {

/*
This program draws a starry sky with stars that twinkle. It also includes
randomly occuring shooting stars.
Author: Charlie McDowell
*/

// the twinlking star locations
int[] starX = new int[1000];
int[] starY = new int[1000];
int[] starColor = new int[1000];
int starSize = 3; // the size of the twinkling stars

// the tail of the shooting star
int[] shootX = new int[30];
int[] shootY = new int[30];
int METEOR_SIZE = 10; // initial size when it first appears
float meteorSize = METEOR_SIZE; // size as it fades

// distance a shooting star moves each frame - varies with each new shooting star
float ssDeltaX, ssDeltaY;
// -1 indicates no shooting star, this is used to fade out the star
int ssTimer = -1;
// starting point of a new shooting star, picked randomly
int startX, startY;


public void setup() {
  
  // create the star locations
  for (int i = 0; i < starX.length; i++) {
    starX[i] =(int)random(width);
    starY[i] = (int)random(height);
    starColor[i] = color((int)random(100,255));
  }
}

public void draw() {
  background(0,0,50); // dark blue night sky

  // draw the stars
  // the stars seem to show best with black outlines that aren't really perceived by the eye
  stroke(0);
  strokeWeight(1);
  for (int i = 0; i < starX.length; i++) {
    fill(random(50,255)); // makes them twinkle
    if (random(10) < 1) {
      starColor[i] = (int)random(100,255);
    }
    fill(starColor[i]);

    ellipse(starX[i], starY[i], starSize, starSize);
  }

  // draw the shooting star (if any)
  for (int i = 0; i < shootX.length-1; i++) {
    int shooterSize = max(0,PApplet.parseInt(meteorSize*i/shootX.length));
    // to get the tail to disappear need to switch to noStroke when it gets to 0
    if (shooterSize > 0) {
      strokeWeight(shooterSize);
      stroke(255);
    }
    else
      noStroke();
    line(shootX[i], shootY[i], shootX[i+1], shootY[i+1]);
    // ellipse(shootX[i], shootY[i], meteorSize*i/shootX.length,meteorSize*i/shootX.length);
  }
  meteorSize*=0.9f; // shrink the shooting star as it fades

  // move the shooting star along it's path
  for (int i = 0; i < shootX.length-1; i++) {
    shootX[i] = shootX[i+1];
    shootY[i] = shootY[i+1];
  }

  // add the new points into the shooting star as long as it hasn't burnt out
  if (ssTimer >= 0 && ssTimer < shootX.length) {
    shootX[shootX.length-1] = PApplet.parseInt(startX + ssDeltaX*(ssTimer));
    shootY[shootY.length-1] = PApplet.parseInt(startY + ssDeltaY*(ssTimer));
    ssTimer++;
    if (ssTimer >= shootX.length) {
      ssTimer = -1; // end the shooting star
    }
  }

  // create a new shooting star with some random probability
  if (random(5) < 1 && ssTimer == -1) {
    newShootingStar();
  }
}

/*
  Starts a new shooting star by randomly picking start and end point.
*/
public void newShootingStar() {
  int endX, endY;
  startX = (int)random(width);
  startY = (int)random(height);
  endX = (int)random(width);
  endY = (int)random(height);
  ssDeltaX = (endX - startX)/(float)(shootX.length);
  ssDeltaY = (endY - startY)/(float)(shootY.length);
  ssTimer = 0; // starts the timer which ends when it reaches shootX.length
  meteorSize = METEOR_SIZE;
  // by filling the array with the start point all lines will essentially form a point initialy
  for (int i = 0; i < shootX.length; i++) {
    shootX[i] = startX;
    shootY[i] = startY;
  }
}
  public void settings() {  size(1000,800); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "shootingstar" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
