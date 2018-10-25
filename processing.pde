ArrayList<Fireworks> fireworks=new ArrayList<Fireworks>();
import oscP5.*;
import netP5.*;

final int N_CHANNELS = 4;
final int BUFFER_SIZE = 220;
final float MAX_MICROVOLTS = 1682.815;
final float DISPLAY_SCALE = 200.0;
final String[] LABELS = new String[] {
  "TP9", "FP1", "FP2", "TP10"
};

final color BG_COLOR = color(0, 0, 0);
final color AXIS_COLOR = color(255, 0, 0);
final color GRAPH_COLOR = color(0, 0, 255);
final color LABEL_COLOR = color(255, 255, 0);
final int LABEL_SIZE = 21;

final int PORT = 5000;
OscP5 oscP5 = new OscP5(this, PORT);

float[][] buffer = new float[N_CHANNELS][BUFFER_SIZE];
int pointer = 0;
float[] offsetX = new float[N_CHANNELS];
float[] offsetY = new float[N_CHANNELS];


void setup(){
  // size(1000, 600);
  fullScreen(P3D);
  frameRate(50);
  hint(DISABLE_DEPTH_TEST);
  blendMode(ADD);
  imageMode(CENTER);
  frameRate(30);
  smooth();
  for(int ch = 0; ch < N_CHANNELS; ch++){
    offsetX[ch] = (width / N_CHANNELS) * ch + 15;
    offsetY[ch] = height / 2;
  }
}

void draw(){
  float x1, y1, x2, y2;
  background(BG_COLOR);

  if(buffer[0][pointer]>0){
    println("yes");
   fireworks.add(new Fireworks(80));
   for(int i=0;i<fireworks.size();i++){
     Fireworks art=fireworks.get(i);
     if(art.centerPosition.y-art.radius>height){
       fireworks.remove(i);
     }
     art.display();
     art.update();
   }
  }

  for(int ch = 0; ch < N_CHANNELS; ch++){
    for(int t = 0; t < BUFFER_SIZE; t++){
      stroke(GRAPH_COLOR);
      x1 = offsetX[ch] + t;
      y1 = offsetY[ch] + buffer[ch][(t + pointer) % BUFFER_SIZE] * DISPLAY_SCALE;
      x2 = offsetX[ch] + t + 1;
      y2 = offsetY[ch] + buffer[ch][(t + 1 + pointer) % BUFFER_SIZE] * DISPLAY_SCALE;
      line(x1, y1, x2, y2);
    }
    stroke(AXIS_COLOR);
    x1 = offsetX[ch];
    y1 = offsetY[ch];
    x2 = offsetX[ch] + BUFFER_SIZE;
    y2 = offsetY[ch];
    line(x1, y1, x2, y2);
  }
  fill(LABEL_COLOR);
  textSize(LABEL_SIZE);
  for(int ch = 0; ch < N_CHANNELS; ch++){
    text(LABELS[ch], offsetX[ch], offsetY[ch]);
  }
}

float data_pre = 0;

void oscEvent(OscMessage msg){
  float data;
  if(msg.checkAddrPattern("/muse/elements/alpha_relative")){
    for(int ch = 0; ch < N_CHANNELS; ch++){
      data = msg.get(ch).floatValue();
      // data = (data - (MAX_MICROVOLTS / 2)) / (MAX_MICROVOLTS / 2); // -1.0 1.0
      buffer[ch][pointer] = data_pre-data;
      println(buffer[ch][pointer]);
      data_pre = data;
    }
    pointer = (pointer + 1) % BUFFER_SIZE;
  }
}


void keyPressed(){
  fireworks.add(new Fireworks(80));
}


//発光表現の元となるクラス
PImage createLight(float rPower,float gPower,float bPower){
  int side=64;
  float center=side/2.0;

  PImage img=createImage(side,side,RGB);

  for(int y=0;y<side;y++){
    for(int x=0;x<side;x++){
      float distance=(sq(center-x)+sq(center-y))/10.0;
      int r=int((255*rPower)/distance);
      int g=int((255*gPower)/distance);
      int b=int((255*bPower)/distance);
      img.pixels[x+y*side]=color(r,g,b);
    }
  }
  return img;
}

//花火クラス
class Fireworks{
  //花火の火の数
  int num=512;
  //花火の中心の初期位置
  PVector centerPosition=new PVector(random(width/8,width*7/8),random(height/2,height*4/5),random(-100,100));
  //花火の中心の初期速度
  PVector velocity=new PVector(0,-22,0);
  //重力
  PVector accel=new PVector(0,0.4,0);
  PImage img;

  float radius;

  PVector[] firePosition=new PVector[num];


  Fireworks(float r){
    float cosTheta;
    float sinTheta;
    float phi;
    float colorchange=random(0,5);

    radius=r;
    for (int i=0;i<num;i++){
      cosTheta = random(0,1) * 2 - 1;
      sinTheta = sqrt(1- cosTheta*cosTheta);
      phi = random(0,1) * 2 * PI;
      firePosition[i]=new PVector(radius * sinTheta * cos(phi),radius * sinTheta * sin(phi),radius * cosTheta);
      firePosition[i]=PVector.mult(firePosition[i],1.12);
    }
    //色をランダムで初期化(綺麗な色が出やすいように調整)
    if(colorchange>=3.8){
      img=createLight(0.9,random(0.2,0.5),random(0.2,0.5));
    }else if(colorchange>3.2){
      img=createLight(random(0.2,0.5),0.9,random(0.2,0.5));
    }else if(colorchange>2){
      img=createLight(random(0.2,0.5),random(0.2,0.5),0.9);
    } else {
      img=createLight(random(0.5,0.8),random(0.5,0.8),random(0.5,0.8));
    }
  }

  void display(){
    for (int i=0;i<num;i++){
      pushMatrix();
      translate(centerPosition.x,centerPosition.y,centerPosition.z);
      translate(firePosition[i].x,firePosition[i].y,firePosition[i].z);
      image(img,0,0);
      popMatrix();

      firePosition[i]=PVector.mult(firePosition[i],1.015);
    }
  }

  void update(){
    radius=dist(0,0,0,firePosition[0].x,firePosition[0].y,firePosition[0].z);
    centerPosition.add(velocity);
    velocity.add(accel);
  }
}
