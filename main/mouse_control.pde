class MouseController {
  Robot robot;
  int adjustedX, adjustedY;
  // a higher value for PRECISION will make the mouse movement more precise and less jumpy,
  // but will also take longer for the mouse to approach its target
  final int PRECISION = 7;
  
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
    adjustedX = (int)map(p.x, 64, 576, 0, displayWidth); // 10% of left and right edges will be easier to reach
    adjustedY = (int)map(p.y, 48, 432, 0, displayHeight); // 10% of top and bottom edges will be easier to reach
    adjustedX = displayWidth - adjustedX; // since screen is mirrored compared to webcam
    robot.mouseMove(current.x + ((int)(adjustedX - current.x) / PRECISION), current.y + ((int)(adjustedY - current.y) / PRECISION));
  }
}

