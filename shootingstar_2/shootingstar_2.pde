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

void setup() {
  // size(window.innerWidth, window.innerHeight);
  size(1000, 800);
  // background(255);
  background(0,0,40);
  frameRate(96);
  for (int i = 0; i < numLines; i++) {
     lines[i][0] = int(random(width));//origin x
     lines[i][1] = int(random(height));//origin y
     lines[i][2] = int(random(lineMin,lineMax));//offset x
     lines[i][3] = int(random(speedMin,speedMax));
  }
}

void start(){
  loop();
}

int[] newLine(){
  int[] line = new int[4];
  //determine canvas entry point
  if (random(1) > 0.5){
    line[0] = int(random(width));//origin x
    line[1] = 0;//origin y
  } else {
    line[0] = 0;//origin x
    line[1] = int(random(width));//origin y
  }
  line[2] = int(random(lineMin,lineMax));//offset x
  line[3] = int(random(speedMin,speedMax));
  // back one step
  line[0] -= line[2];
  line[1] -= line[2]*2;

  return line;
}

void draw() {
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

  colors[0] = int(random(0, 255));
  colors[1] = int(random(0, 255));
  colors[2] = int(random(0, 255));

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
