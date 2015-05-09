import java.awt.*;
import processing.video.*;
int lightestX, lightestY, targetX, targetY, currentX, currentY, mouseDeltaX, mouseDeltaY;
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
  
  targetX = displayWidth / 2;
  targetY = displayHeight / 2;
  
  robot.mouseMove(targetX, targetY); // mouse starts in center
}

void draw() {
  

  
  if (cam.available()) {
    cam.read();

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
    
    lightestX = cam.width - lightestX; // because webcam is mirrored
    
    lightestX = (int)map(lightestX, 0, 640, 0, displayWidth);
    lightestY = (int)map(lightestY, 0, 480, 0, displayHeight);
    
    Point current = MouseInfo.getPointerInfo().getLocation();
    currentX = current.x;
    currentY = current.y;
    
    mouseDeltaX = (lightestX - currentX) / 10;
    mouseDeltaY = (lightestY - currentY) / 10;
    
    targetX += mouseDeltaX;
    targetY += mouseDeltaY;
    
    println(targetX, targetY);
    
  
    robot.mouseMove(targetX, targetY);
  
    if (DEBUG) {
      pushMatrix();
      scale(-1, 1);
      image(cam, -width, 0);
      popMatrix();
    }
  }
}

