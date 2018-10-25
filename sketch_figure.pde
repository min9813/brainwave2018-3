float x = 0.1, y = 0.1;
 
//static final float a = -1.0, b = 0.05, c = 2.275,  d = -0.5;
//static final float a =  1.0, b = 0.0,  c = - 2.25, d = 0.2;
//static final float a =  1.0, b = 0.0,  c = - 1.9,  d = 0.4;
//static final float a = -1.0, b = 0.1,  c = 1.52,   d = -0.8;
//static final float a = -1.0, b = 0.1,  c = 1.6,    d = -0.8;
static final float c = -1.75;
//static final float a = -2.0, b = 0., c = 2.6, d = -0.5;
 
//float a,b,c,d = 0;

float a,b,d;
void setup() {
  size(1800, 1200);
  blendMode(ADD);
  background(0);
  stroke(124, 155, 255, 50);
  frameRate(60);
  //a = random(1);
  b = 0.1;
  d = random(0.25,1.4);
  a = 0.5;
  print(d);
}
 
int i = 0;
void draw() {
  //a = random(1);
  //b = random(1);
  //c = random(1);
  //d = random(1);
  i++;
  
  if (i%10 == 0){
    d = random(0.25,1.4);
  }

  
 
  float _x, _y;
  float A;
  for (int i = 0; i < 10000; i++) {
 
    A = a * (x * x + y * y) + b * x * (x * x - 3 * y * y) + c;
    _x = A * x + d * (x * x - y * y);
    _y = A * y - 2 * d * x * y;
 
    point(_x * 200 + width/2, - _y * 200 + height/2);
    //point(a*200 + width/2,b*200 + height/2);
    
    x = _x;
    y = _y;
  }

}
