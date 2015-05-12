// To download the OpenCV library, click Sketch (on the toolbar), then click Import Library.
// From there, search for "OpenCV" and install it. The download might take a couple of minutes.

import gab.opencv.*;
import processing.video.*;
import java.awt.*;

Capture cam;
HandDetector handDetector;
OpenCV opencv;
MouseController mouseController;

final boolean DEBUG = true;

void setup() {
  if (DEBUG) {
    size(640, 480);
  }

  cam = new Capture(this, 640, 480, 30);
  opencv = new OpenCV(this, 640, 480);
  cam.start();
  handDetector = new HandDetector(cam, opencv);
  mouseController = new MouseController();
}

void draw() {
  if (cam.available()) {
    cam.read();
    mouseController.track(handDetector.detect());

    stroke(0, 0, 255);
    for (int i = 0; i < handDetector.faces.length; i++) {
      rect(handDetector.faces[i].x, handDetector.faces[i].y, handDetector.faces[i].width, handDetector.faces[i].height);
    }


    /*if (DEBUG) {
     pushMatrix();
     scale(-1, 1);
     image(cam, -width, 0);
     popMatrix();
     }*/
  }
}

// This only works inside the environment, but
// it's a decent proof of concept for how clicks
// should be implemented. If this was how we were 
// going to implement this, we would use a Java 
// Key Listener event, and it would work even with
// this program minimized.
/*
void keyPressed() {
 if (key == ' ') {
 robot.mousePress(InputEvent.BUTTON1_MASK);
 robot.mouseRelease(InputEvent.BUTTON1_MASK);
 }
 }*/
