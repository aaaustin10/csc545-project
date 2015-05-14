class MouseController {
  private Robot robot;
  private int adjustedX, adjustedY;
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
  
  public void track(PVector p) {
    if (p == null) { return; }
    Point current = MouseInfo.getPointerInfo().getLocation();
    adjustedX = (int)map(p.x, 0, 640, 0, displayWidth);
    adjustedY = (int)map(p.y, 0, 480, 0, displayHeight);
    adjustedX = displayWidth - adjustedX; // since screen is mirrored compared to webcam
    robot.mouseMove(current.x + ((int)(adjustedX - current.x) / PRECISION), current.y + ((int)(adjustedY - current.y) / PRECISION));
  }
}

