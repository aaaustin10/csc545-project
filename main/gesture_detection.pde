public class HandDetector {
  private OpenCV opencv;
  private Capture cam;

  //public Rectangle[] faces;

  public HandDetector(Capture cam, OpenCV opencv) {
    this.cam = cam;
    this.opencv = opencv;
    //this.opencv.loadCascade(OpenCV.CASCADE_FRONTALFACE);
  }

  public Point detect() {
    opencv.loadImage(cam);
    opencv.threshold(140);
    opencv.blur(1);

    //faces = opencv.detect();
    //println(faces.length);

    image(opencv.getOutput(), 0, 0);

    ArrayList<Contour> contours = opencv.findContours(false, true);

    noFill();
    stroke(0, 255, 0);
    strokeWeight(3);
    int averageX = 0, averageY = 0;

    for (int i = 0; i < contours.size () && i < 1; ++i) { // only takes first one if exists
      Contour c = contours.get(i).getConvexHull();
      c.draw();
      contours.get(i).draw();

      ArrayList<PVector> points = c.getPoints();

      beginShape();
      for (PVector p : points) {
        stroke(255, 0, 0);
        vertex(p.x, p.y);

        averageX += p.x;
        averageY += p.y;
      }
      endShape();

      averageX /= points.size();
      averageY /= points.size();

      point(averageX, averageY); // draw on screen
    }
    averageX = (int)map(averageX, 0, 640, 0, displayWidth);
    averageY = (int)map(averageY, 0, 480, 0, displayHeight);
    return new Point(averageX, averageY);
  }
}

