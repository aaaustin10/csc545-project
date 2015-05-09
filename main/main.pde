import java.awt.*;
import processing.video.*;
int greenestX, greenestY, targetX, targetY, currentX, currentY, mouseDeltaX, mouseDeltaY;
Robot robot;
Capture cam;
color currentPixel, targetPixel;


final boolean DEBUG = false;

// a higher value for PRECISION will make the mouse movement more precise and less jumpy,
// but will also take longer for the mouse to approach its target
final int PRECISION = 7;

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

    boolean found = false;

    for (int y = 0; y < cam.height; ++y) {
      for (int x = 0; x < cam.width; ++x) {
        currentPixel = cam.get(x, y);

        // bitshifting will be much faster than red(), green(), and blue()
        //if (red(currentPixel) < 150 && green(currentPixel) > 180 && blue(currentPixel) < 150) {
        if ((currentPixel >> 16 & 0xFF) < 150 && (currentPixel >> 8 & 0xFF) > 180 && (currentPixel & 0xFF) < 150) {
          targetPixel = cam.get(x, y);
          greenestX = x;
          greenestY = y;
          found = true;
          break;
        }
      }
      if (found) { 
        break;
      }
    }

    if (found) {
      greenestX = cam.width - greenestX; // because webcam is mirrored

      greenestX = (int)map(greenestX, 0, 640, 0, displayWidth);
      greenestY = (int)map(greenestY, 0, 480, 0, displayHeight);

      Point current = MouseInfo.getPointerInfo().getLocation();
      currentX = current.x;
      currentY = current.y;

      mouseDeltaX = (greenestX - currentX) / PRECISION;
      mouseDeltaY = (greenestY - currentY) / PRECISION;

      targetX += mouseDeltaX;
      targetY += mouseDeltaY;

      robot.mouseMove(targetX, targetY);

      if (DEBUG) {
        pushMatrix();
        scale(-1, 1);
        image(cam, -width, 0);
        popMatrix();
      }
    }
  }
}

