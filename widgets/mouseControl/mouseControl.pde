// This code worked fine on my computer, but seems to have issues
// running on the lab computers.

import java.awt.*;
import processing.video.*;
int originX, originY, lightestX, lightestY;
Robot robot;
Capture cam;
color lightestPixel;

void setup() {
  size(displayWidth, displayHeight);
  colorMode(RGB, 255);
  cam = new Capture(this, 640, 480, 30);
  cam.start();
  originX = displayWidth / 2;
  originY = displayHeight / 2;

  try
  {
    robot = new Robot();
  }
  catch (AWTException e)
  {
    println("Robot class not supported.");
    exit();
  }

  robot.mouseMove(originX, originY);
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
  
  robot.mouseMove(lightestX, lightestY);
  pushMatrix();
  scale(-1, 1);
  image(cam, -width, 0);
  popMatrix();
}

void mouseMoved() {
  //robot.mouseMove(mouseX, mouseY + 45);
}

