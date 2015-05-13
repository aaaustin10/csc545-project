// To download the OpenCV library, click Sketch (on the toolbar), then click Import Library.
// From there, search for "OpenCV" and install it. The download might take a couple of minutes.
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
  PVector center = ges_det.detect();
  if (center != null)
    println(center.x, center.y);
  //mouseController.track(center);
}

void captureEvent(Capture c) {
  c.read();
}
