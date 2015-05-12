public class MouseController {
  private Robot robot;
  private int targetX, targetY, mouseDeltaX, mouseDeltaY;

  // a higher value for PRECISION will make the mouse movement more precise and less jumpy,
  // but will also take longer for the mouse to approach its target
  private final int PRECISION = 7;
  
  public MouseController() {
    try {
      robot = new Robot();
    } 
    catch (AWTException e) {
      println("Robot class not supported.");
      exit();
    }
  }
  
  public void track(Point p) {
    Point current = MouseInfo.getPointerInfo().getLocation();
    
    p.x = displayWidth - p.x; // since screen is mirrored compared to webcam
    
    mouseDeltaX = (p.x - current.x) / PRECISION;
    mouseDeltaY = (p.y - current.y) / PRECISION;
    
    targetX = current.x + mouseDeltaX;
    targetY = current.y + mouseDeltaY;
    robot.mouseMove(targetX, targetY);
  }
}

