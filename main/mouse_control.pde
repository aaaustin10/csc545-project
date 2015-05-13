class MouseController {
  private Robot robot;

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
    p.x = displayWidth - p.x; // since screen is mirrored compared to webcam
    robot.mouseMove(current.x + ((int)(p.x - current.x) / PRECISION), current.y + ((int)(p.y - current.y) / PRECISION));
  }
}

