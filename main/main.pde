Capture cam;
MouseController mouseController;

final boolean DEBUG = false;

void setup() {
  if (DEBUG) {
    size(displayWidth, displayHeight);
  }

  cam = new Capture(this, 640, 480, 30);
  cam.start();
  mouseController = new MouseController(cam);
}

void draw() {
  if (cam.available()) {
    cam.read();
    mouseController.track();

    if (DEBUG) {
      pushMatrix();
      scale(-1, 1);
      image(cam, -width, 0);
      popMatrix();
    }
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
