import gab.opencv.*;
import processing.video.*;
import java.awt.*;
import java.awt.geom.Point2D;
import org.opencv.imgproc.Imgproc;

Capture cam;
OpenCV opencv;
GestureDetector ges_det;
MouseController mouseController;
boolean gotAverage = false;

void setup() {
  size(640, 480);
  cam = new Capture(this, 640, 480);
  opencv = new OpenCV(this, 640, 480);
  cam.start();
  ges_det = new GestureDetector(); 
  mouseController = new MouseController();
}

void draw() {
  if (!gotAverage && cam.available()) {
    println("Please keep your hand in the middle of the screen...");
    color average = getAverageColor();
    ges_det.averageColor = average;
    println("Good to go! Color is: ", red(average), green(average), blue(average));
  }
  mouseController.track(ges_det.detect());
}

void captureEvent(Capture c) {
  c.read();
}

color getAverageColor() {
  int r = 0, g = 0, b = 0;
  int counter = 0;
  for (int y = cam.height / 3; y < 2 * cam.height / 3 ; ++y) {
    for (int x = cam.width / 3; x < 2 * cam.width / 3; ++x) {
      r += cam.get(x, y) >> 16 & 0xFF;
      g += cam.get(x, y) >> 8 & 0xFF;
      b += cam.get(x, y) & 0xFF;
      ++counter;
    }
  }
  
  gotAverage = true;
  return color(r / counter, g / counter, b / counter);
}
