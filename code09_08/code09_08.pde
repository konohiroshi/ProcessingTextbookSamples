float x, y;
float speed_y;//縦方向の速度
void setup () {
  size(500, 500);
  x = width/2;
  y=0;
  speed_y=5;
}

void draw () {
  reset();
  fill(255);
  x=x+random(-1, 1);
  y=y+random(1, 3);
  ellipse(x, y, 5, 5);
}

void reset() {
  fill(127);
  noStroke();
  rect(0, 0, width, height);
}
