import java.awt.*;     
import processing.video.*;

public class MouseController {
  private Robot robot;
  private color currentPixel, targetPixel;
  private short greenestX, greenestY, targetX, targetY, currentX, currentY, mouseDeltaX, mouseDeltaY;

  // a higher value for PRECISION will make the mouse movement more precise and less jumpy,
  // but will also take longer for the mouse to approach its target
  private final short PRECISION = 7;

  public MouseController(Capture cam) {
    try {
      robot = new Robot();
    } 
    catch (AWTException e) {
      println("Robot class not supported.");
      exit();
    }

    targetX = (short)(displayWidth / 2);
    targetY = (short)(displayHeight / 2);
  }

  public void track() {
    boolean found = false;

    for (short y = 0; y < cam.height; ++y) {
      for (short x = 0; x < cam.width; ++x) {
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
      greenestX = (short)(cam.width - greenestX); // because webcam is mirrored

      greenestX = (short)map(greenestX, 0, 640, 0, displayWidth);
      greenestY = (short)map(greenestY, 0, 480, 0, displayHeight);

      Point current = MouseInfo.getPointerInfo().getLocation();
      currentX = (short)current.x;
      currentY = (short)current.y;

      mouseDeltaX = (short)((greenestX - currentX) / PRECISION);
      mouseDeltaY = (short)((greenestY - currentY) / PRECISION);

      targetX += mouseDeltaX;
      targetY += mouseDeltaY;

      robot.mouseMove(targetX, targetY);
    }
  }
}

