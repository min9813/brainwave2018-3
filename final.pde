ArrayList<Fireworks> fireworks=new ArrayList<Fireworks>();
int ELP_NUM = 100; //配列の数
int STAR_NUM = 100;
int start_t;
int t;
float star_ratio = 0.5;
int prev_t;
float SWITCH_TIME = 1;
int out_alpha=30;
int draw_alpha;
int FIX_ALPHA=200;
int START_ALPHA=0;
int CHANGE_ALPHA = 3;
PImage offscr;
Star[] s = new Star[100];
//位置のベクトルの配列
PVector[] location = new PVector[ELP_NUM];
//速度のベクトルの配列
PVector[] velocity = new PVector[ELP_NUM];
//塗りの色の配列
color[] elp_col = new color[ELP_NUM];
//円の大きさ(直径)の配列
float[] elp_diameter = new float[ELP_NUM];
float[] new_elp_diameter = new float[ELP_NUM];
float[] star_diameter = new float[STAR_NUM];
color[] star_col = new color[STAR_NUM];
float x_figure = 0.1, y_figure = 0.1;


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
int val = 0;


void setup() {
  //size(800, 600); //800x600pixelの画面を生成
  fullScreen(P3D);
  frameRate(30); //フレームレート
  hint(DISABLE_DEPTH_TEST);
  blendMode(ADD);
  imageMode(CENTER);
  noStroke();
  for (int i = 0; i < ELP_NUM; i++) { //配列の数だけ繰り返し
    //位置のベクトルの初期設定
    location[i] = new PVector(random(width), random(height));
    //速度のベクトルの初期設定
    velocity[i] = new PVector(random(-4, 4), random(-4, 4));
    //色の初期設定
    elp_col[i] = color(random(255), random(255), random(255), 192);
    //大きさの初期設定
    elp_diameter[i] = random(20, 40);
    int min_new_diameter = 30;
    int max_new_diameter = 60;
    //randomSeed(0);
    new_elp_diameter[i] = random(min_new_diameter, max_new_diameter);
    star_diameter[i] = random(20,40);
    star_col[i] = color(random(100, 255), random(100, 255), random(100, 255));
  }
  velocity[0] = new PVector(random(-2,2),random(-2,2));
  start_t = hour()*3600+minute()*60+second();
  offscr = createImage(width, height, RGB);
  randomSeed(0);

    for(int ch = 0; ch < N_CHANNELS; ch++){
    offsetX[ch] = (width / N_CHANNELS) * ch + 15;
    offsetY[ch] = height / 2;
  }

}

void drawelp(int num, float[] diameters, int alpha){
    // 円を描く、第一引数が円の数、第二引数が円の直径の配列
      noStroke();
    for (int i = 0; i < num; i++) {
        fill(elp_col[i], alpha); //色を指定
        //指定した位置に円を描画
        ellipse(location[i].x, location[i].y, diameters[i], diameters[i]);
        //位置のベクトルに速度のベクトルを加算、次の位置になる
        location[i].add(velocity[i]);
        //もし画面の左端、または右端に到達したら
        if ((location[i].x > width) || (location[i].x < 0)) {
        velocity[i].x *= -1; //X方向のスピードを反転
        }
        //もし画面の下端、または上端に到達したら
        if ((location[i].y > height) || (location[i].y < 0)) {
        velocity[i].y *= -1; //Y方向のスピードを反転
        }
    }
}

void drawstar(int num, int remain_num, int alpha){
    // 星を描く
    // 第一引数が描く星の数、第二引数が残す円の数
      noStroke();
    for (int i=0;i<num;i++){
        s[i+remain_num] = new Star(location[i+remain_num].x,location[i+remain_num].y, star_diameter[i+remain_num], star_col[i+remain_num], alpha);
        location[i+remain_num].add(velocity[i+remain_num]);
        s[i+remain_num].drawStar();
        if ((location[i+remain_num].x > width) || (location[i+remain_num].x < 0)) {
        velocity[i+remain_num].x *= -1;
        }
        if ((location[i+remain_num].y > height) || (location[i+remain_num].y < 0)) {
        velocity[i+remain_num].y *= -1;
        }
    }
}

void draw_firework(boolean is_going){
      //println("yes");
      println(is_going);
        noStroke();
   if(is_going){
      fireworks.add(new Fireworks(80));
   }
   for(int i=0;i<fireworks.size();i++){
     Fireworks art=fireworks.get(i);
     if(art.centerPosition.y-art.radius>height){
       fireworks.remove(i);
     }
     art.display();
     art.update();
   }

}

void figure(float z){
  float a = 0.5;
  float b = 0.1;
  float c = -1.75;
  float d;

  d = 0.25+(1.4-0.25)*sin(z)*sin(z);
  //a = random(1);
  //b = random(1);
  //c = random(1);
  //d = random(1);

  stroke(z,random(255),random(255));

  float _x, _y;
  float A;
  for (int i = 0; i < 500; i++) {

    A = a * (x_figure * x_figure + y_figure * y_figure) + b * x_figure * (x_figure * x_figure - 3 * y_figure * y_figure) + c;
    _x = A * x_figure + d * (x_figure * x_figure - y_figure * y_figure);
    _y = A * y_figure - 2 * d * x_figure * y_figure;

    point(_x * 200 + width/2, - _y * 200 + height/2);
    //point(a*200 + width/2,b*200 + height/2);

    x_figure = _x;
    y_figure = _y;
  }

}

int count_alpha(int time, int threshold){
    // 透明度の計算
   //println("time:"+time);

    if(time<=(threshold+1)*SWITCH_TIME){
      if (START_ALPHA<FIX_ALPHA){
        START_ALPHA = START_ALPHA + CHANGE_ALPHA;
      }
      //println("START ALPHA:"+START_ALPHA);
      draw_alpha = START_ALPHA;
    }else if((threshold+1)*SWITCH_TIME<time&time<=(threshold+2)*SWITCH_TIME){
      draw_alpha = FIX_ALPHA;
      START_ALPHA = 0;
      //println("draw_alpha:"+draw_alpha);
    }else{
      draw_alpha = draw_alpha - CHANGE_ALPHA;
    }

  return draw_alpha;
}

void reset_background(){
  background(0);
}


int t_0 = 4;
int t_1;
void draw() {
  //background(0); //背景を描画
  //配列の数だけ繰り返し
  //loadPixels();
  //offscr.pixels = pixels;
  //offscr.updatePixels();

  // 以下２行で残像を追加
  // fillの第二引数が小さい程残像が長くなる
  //fill(0, out_alpha);
  //rect(0, 0, width, height);

  t = hour()*3600+minute()*60+second() - start_t;
  print(t,"\n");
  t_0 = t_1;
  t_1 = t % 5;
  //print(t_0, t_1);
  if(t_0==4&t_1==0){
    println("+++++++++++++++++++","reloded!!");
    val = round(buffer[0][pointer]);
  }
  println("val", val);

  // 処理の条件分け
  if (val>=0*SWITCH_TIME&val<1*SWITCH_TIME){
    //   円の半径と数の増加
    println("aaaaa");
    reset_background();
    draw_alpha = count_alpha(val, 1);
    drawelp(int(ELP_NUM), new_elp_diameter, draw_alpha);
  }else if(val>=1*SWITCH_TIME&val<2*SWITCH_TIME){
    // 星の出現、star_ratioで全部の円のうち何割星にするか決める。
    println("bbbbb");
    reset_background();
      star_ratio=0.8;
      draw_alpha = count_alpha(val, 5);
      drawstar(int(STAR_NUM*star_ratio),int(ELP_NUM*(1-star_ratio)), draw_alpha);
      drawelp(int(ELP_NUM*(1-star_ratio)), new_elp_diameter, draw_alpha);

  }else if (val>=2*SWITCH_TIME&val<3*SWITCH_TIME){
    println("cccccc");
    figure(200);
  }else if(val>=3*SWITCH_TIME&val<4*SWITCH_TIME){
    println("dddddd");
    reset_background();
    draw_firework(val<4*SWITCH_TIME);
  }  else{
    //   デフォルト
    println("fffffff");
    reset_background();
      draw_alpha = FIX_ALPHA;
      drawelp(1, elp_diameter, draw_alpha);
  }

  if(t>4*SWITCH_TIME){
    println("eeeeee");
        start_t = hour()*3600+minute()*60+second();
  }

}

class Star {
    float x, y, r;
    color c;
    int alpha;
    boolean right = true;
    Star(float _x, float _y, float _r, color _c, int _alpha) {
        x = _x;
        y = _y;
        r = _r;
        c = _c;
        alpha = _alpha;
    }
    void drawStar() {
        float vNf = random(5, 6); //頂点の数は5-20まででランダム
        int vN = int(vNf)*2; //頂点の数
        int R; //中心から頂点までの距離
        int Ri = int(r/2); // 中心から谷間での距離

        int Ros = int(r);
        noStroke();
        fill(c, alpha);
        pushMatrix();
        translate(x, y);
        beginShape();
        for (int i=0; i<vN; i++) {
            if (i%2 == 0) {
                R = Ros;
            } else {
                R = Ri;
            }
            vertex(R*cos(radians(360*i/vN)), R*sin(radians(360*i/vN)));
        }
        endShape(CLOSE);
        popMatrix();
    }
    void move() {
        if (x > width) {
            right = false;
        }else if(x<0){
            right = true;
        }
        if (right){
         x++;
        }else{
         x--;
        }
    }
}

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


void oscEvent(OscMessage msg){
  float data;
  if(msg.checkAddrPattern("/muse/elements/alpha_relative")){
    for(int ch = 0; ch < N_CHANNELS; ch++){
      data = msg.get(ch).floatValue();
      //data = (data - (MAX_MICROVOLTS / 2)) / (MAX_MICROVOLTS / 2); // -1.0 1.0
      buffer[ch][pointer] = data*10;
      //println(buffer[ch][pointer]);
    }
    pointer = (pointer + 1) % BUFFER_SIZE;
  }
}
