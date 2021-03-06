//Kinect　一定の深度範囲での指先トラッキング
//一定範囲内での深度による色表現がある。

import org.openkinect.processing.*;

Kinect2 kinect2;

float minThreshold = 500;
float maxThreshold = 600;
PImage img;

//トラッキングの円の動きをゆるやかにするために使う変数
float lerpX = 0;
float lerpY = 0;

void setup() {
  //深度(Depth)座標系の解像度(512*424)に合わせて設定。
  //P2Dは高速な描画モード
  size(512, 424, P2D);

  kinect2 = new Kinect2(this);

  kinect2.initDepth();
  kinect2.initDevice();
  img = createImage(kinect2.depthWidth, kinect2.depthHeight, RGB);
}

void draw() {
  //背景をリフレッシュ
  //background(0);

  //現在の表示画面のピクセル情報をimgに呼び出す。
  img.loadPixels();

  PImage depth = kinect2.getDepthImage();

  int[] rawDepth = kinect2.getRawDepth();

  float totalX = 0;
  float totalY = 0;
  float count =0;
  float avgX =0;
  float avgY =0;
  //トラッキングポイントの有効範囲の変数を設定
  float trackThreshold = 100;

  for (int x = 0; x < depth.width; x++ ) {
    for (int y = 0; y < depth.height; y++ ) {
      int loc = x + y * depth.width;
      int currentDepth = rawDepth[loc];

      if (currentDepth > minThreshold && currentDepth < maxThreshold) {
        //最小値と最大値の範囲内のcurrentDepthの値を0〜255にスケーリング。
        float g = map(currentDepth, maxThreshold, minThreshold, 0, 255);
        //スケーリングした値で緑を塗る。遠ければ暗い緑。
        img.pixels[loc] = color(0, g, 0);
        //描画されたピクセルと緑の色の差（距離）を計算する。
        float d = dist(0, g, 0, 0, 255, 0);
        //もし、その差が設定したトラッキングポイントのスレッショルドより小さかったら（緑に近かったら）平均を算出する対象のピクセルとする。
        if (d < trackThreshold) {
          totalX += x ;
          totalY += y;
          count ++;
        }
      } else {
        //有効範囲外のピクセルはdepthの深度の色のままにする。
        img.pixels[loc] = depth.pixels[loc];
      }
    }
  }

  img.updatePixels();
  image(img, 0, 0);

  if (count > 0) { 
    avgX= totalX/count;
    avgY= totalY/count;
  }

  //トラッキングポイントの動きをゆるやかにする。
  lerpX = lerp(lerpX, avgX, 0.1);
  lerpY = lerp(lerpY, avgY, 0.1);

//少し透明度のある赤い円を描く。
  noStroke();
  fill(255, 0, 0, 200);
  ellipse(lerpX, lerpY, 24, 24);

  text("Framerate: " + (int)(frameRate), 10, 10);
}