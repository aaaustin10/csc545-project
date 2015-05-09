import java.awt.*;
import processing.video.*;
int lightestX, lightestY;
Robot robot;
Capture cam;
color lightestPixel;

final boolean DEBUG = true;

void setup() {

  if (DEBUG) {
    size(displayWidth, displayHeight);
  }

  cam = new Capture(this, 640, 480, 30);
  cam.start();

  try {
    robot = new Robot();
  } 
  catch (AWTException e) {
    println("Robot class not supported.");
    exit();
  }
}

void draw() {
  if (cam.available()) {
    cam.read();
  }

  lightestPixel = color(0);

  for (int y = 0; y < cam.height; ++y) {
    for (int x = 0; x < cam.width; ++x) {
      if (cam.get(x, y) > lightestPixel) {
        lightestPixel = cam.get(x, y);
        lightestX = x;
        lightestY = y;
      }
    }
  }

  robot.mouseMove((int)map(cam.width - lightestX, 0, 640, 0, displayWidth), (int)map(lightestY, 0, 480, 0, displayHeight));

  if (DEBUG) {
    pushMatrix();
    scale(-1, 1);
    image(cam, -width, 0);
    popMatrix();
  }
}

