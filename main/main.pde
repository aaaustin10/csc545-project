import gab.opencv.*;
import processing.video.*;
import java.awt.*;
import java.awt.geom.Point2D;
import org.opencv.imgproc.Imgproc;

Capture cam;
OpenCV opencv;
GestureDetector ges_det;
MouseController mouseController;

void setup() {
  size(640, 480);
  cam = new Capture(this, 640, 480);
  opencv = new OpenCV(this, 640, 480);
  cam.start();
  ges_det = new GestureDetector(); 
  mouseController = new MouseController();
}

void draw() {
  mouseController.track(ges_det.detect());
}

void captureEvent(Capture c) {
  c.read();
}
