class GestureDetector {
  float color_dist(int c1, int c2) {
    return dist(red(c1), green(c1), blue(c1), red(c2), green(c2), blue(c2));
  }
  
  final int COLOR_DIST_TOO_FAR = 30;
  PImage find_close_pixels(PImage img, color c) {  
    PImage target = img.get(0, 0, img.width, img.height); 
    for (int x = 0; x < img.width; x++) {
      for (int y = 0; y < img.height; y++) {
        color p = target.get(x, y);
        if (color_dist(p, c) > COLOR_DIST_TOO_FAR) {
          target.set(x, y, color(0));
        }
      }
    }
    return target;
  }
  
  color find_blob_color(PImage img, Contour c) {
    Rectangle rect = c.getBoundingBox();
  
    int r = 0;
    int g = 0;
    int b = 0;
    int num_pix = 1;
  
    final int bound = 5;
    boolean[][] near_array = new boolean[img.width / bound + bound][img.height / bound + bound];
  
    for (int x = 0; x < img.width; x++) {
      for (int y = 0; y < img.height; y++) {
        if (rect.contains(x, y)) {
          if (near_array[x / bound][y / bound] || c.containsPoint(x, y)) {
            near_array[x / bound][y / bound] = true;
            color p = img.get(x, y);
            r += red(p);
            g += green(p);
            b += blue(p);
            num_pix++;
          }
        }
      }
    }
    r /= num_pix;
    g /= num_pix;
    b /= num_pix;
    return color(r, g, b);
  }
  
  boolean almost(float base, float other, float percentage) {
    if (base * (1 + percentage) > other && base * (1 - percentage) < other)
      return true;
    return false;
  } 
  
  PVector middle_of_blob = new PVector(200, 200);
  color avg = color(128);
  final int CENTER_TOO_FAR_AWAY = 50;
  final int TOO_SMALL_AREA = 1000;
  
  PVector detect() {
    background(0);
    PImage near_img = find_close_pixels(video, avg);
    image(near_img, 0, 0);
    opencv.loadImage(near_img);
    opencv.threshold(0); // if it appears at all
    ArrayList<Contour> contours = opencv.findContours(false, true);
    noFill();
    stroke(0, 255, 0);
    strokeWeight(3);
    Contour chosen_contour = null;
    for (int i = 0; i < contours.size(); i++) {
      Contour c = contours.get(i).getConvexHull();
      Rectangle rect = c.getBoundingBox();
      PVector center = new PVector((int)rect.getCenterX(), (int)rect.getCenterY());
      if (dist(middle_of_blob.x, middle_of_blob.y, center.x, center.y) < CENTER_TOO_FAR_AWAY) {
        middle_of_blob = center;
        c.draw();
        chosen_contour = c;
        break;
      }
      if (c.area() < TOO_SMALL_AREA) {
        break;
      }
      for (PVector p : c.getPoints ()) {
        stroke(255, 0, 0);
        point(p.x, p.y);
      }
    }
  
    if (chosen_contour != null) {
      avg = find_blob_color(video, chosen_contour);
      return middle_of_blob;
    } else {
      return null;
    }
  }
}
