int ELP_NUM = 100; //配列の数
int STAR_NUM = 100;
int start_t;
int t;
float star_ratio = 0.5;
int prev_t;
int SWITCH_TIME = 1;
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



void setup() {
  size(800, 600); //800x600pixelの画面を生成
  frameRate(60); //フレームレート
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
}

void drawelp(int num, float[] diameters, int alpha){
    // 円を描く、第一引数が円の数、第二引数が円の直径の配列
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

void draw() {
  background(15); //背景を描画
  //配列の数だけ繰り返し
  //loadPixels();
  //offscr.pixels = pixels;
  //offscr.updatePixels();

  // 以下２行で残像を追加
  // fillの第二引数が小さい程残像が長くなる
  //fill(0, out_alpha);
  //rect(0, 0, width, height);


  t = hour()*3600+minute()*60+second() - start_t;


  // 処理の条件分け
  if (t>0*SWITCH_TIME&t<=5*SWITCH_TIME){
    //   円の半径と数の増加
    draw_alpha = count_alpha(t, 1);
    drawelp(int(ELP_NUM), new_elp_diameter, draw_alpha);
  }else if(t>5*SWITCH_TIME&t<=9*SWITCH_TIME){
    // 星の出現、star_ratioで全部の円のうち何割星にするか決める。
      star_ratio=0.8;
      draw_alpha = count_alpha(t, 5);
      drawstar(int(STAR_NUM*star_ratio),int(ELP_NUM*(1-star_ratio)), draw_alpha);
      drawelp(int(ELP_NUM*(1-star_ratio)), new_elp_diameter, draw_alpha); 

  }else if (t>9*SWITCH_TIME){
      start_t = hour()*3600+minute()*60+second();
  }else{
    //   デフォルト
      draw_alpha = FIX_ALPHA;
      drawelp(1, elp_diameter, draw_alpha);
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
