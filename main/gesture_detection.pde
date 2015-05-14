class BlobDescription {
  PVector center;
  float area;
  color p;
  Contour contour;
}

class GestureDetector {
  boolean color_dist(int c1, int c2, int threshold) {
    if (abs((c1 >> 16 & 0xFF) - (c2 >> 16 & 0xFF)) > threshold || abs((c1 >> 8 & 0xFF) - (c2 >> 8 & 0xFF)) > threshold || abs((c1 & 0xFF) - (c2 & 0xFF)) > threshold) {
      return false;
    }
    return true;
  }

  final int COLOR_DIST_TOO_FAR = 10;
  PImage find_close_pixels(PImage img, color c) {  
    PImage target = img.get(0, 0, img.width, img.height); 
    for (int x = 0; x < img.width; ++x) {
      for (int y = 0; y < img.height; ++y) {
        color p = target.get(x, y);
        if (!color_dist(p, c, COLOR_DIST_TOO_FAR)) {
          target.set(x, y, color(0));
        }
      }
    }
    return target;
  }

  color find_blob_color(PImage img, BlobDescription blob) {
    Contour c = blob.contour;
    Rectangle rect = c.getBoundingBox();

    int r = 0;
    int g = 0;
    int b = 0;
    int num_pix = 1;

    int min_x, max_x, min_y, max_y;
    min_x = (int)rect.getX();
    min_y = (int)rect.getY(); 
    max_x = min_x + (int)rect.getWidth();
    max_y = min_y + (int)rect.getHeight();

    final int bound = 5;
    boolean[][] near_array = new boolean[img.width / bound + bound][img.height / bound + bound];  

    for (int x = 0; x < img.width; ++x) {
      for (int y = 0; y < img.height; ++y) {
        if (x >= min_x && x <= max_x && y >= min_y && y <= max_y) {
          if (near_array[x / bound][y / bound] || c.containsPoint(x, y)) {
            near_array[x / bound][y / bound] = true;
            color p = img.get(x, y);
            r += p >> 16 & 0xFF;
            g += p >> 8 & 0xFF;
            b += p & 0xFF;
            ++num_pix;
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
    if (base * (1 + percentage) > other && base * (1 - percentage) < other) {
      return true;
    }
    return false;
  } 

  BlobDescription last_blob = null;
  final int CENTER_TOO_FAR_AWAY = 50;
  final int TOO_SMALL_AREA = 1000;

  PVector detect() {
    if (last_blob == null) {
      // replace this with beginning blob picker
      last_blob = new BlobDescription();
      last_blob.center = new PVector(200, 200);
      last_blob.p = color(72.0, 69.0, 89.0);
    }

    background(0);
    PImage near_img = find_close_pixels(cam, last_blob.p);
    image(near_img, 0, 0);
    opencv.loadImage(near_img);
    opencv.threshold(0); // if it appears at all
    ArrayList<Contour> contours = opencv.findContours(false, true);

    noFill();
    stroke(0, 255, 0);
    strokeWeight(3);
    BlobDescription chosen_blob = null;
    for (int i = 0; i < contours.size(); ++i) {
      Contour c = contours.get(i).getConvexHull();
      Rectangle rect = c.getBoundingBox();
      PVector center = new PVector((int)rect.getCenterX(), (int)rect.getCenterY());
      if (dist(last_blob.center.x, last_blob.center.y, center.x, center.y) < CENTER_TOO_FAR_AWAY) {
        chosen_blob = new BlobDescription();
        chosen_blob.center = center;
        c.draw();
        chosen_blob.contour = c;
        break;
      }
      if (c.area() < TOO_SMALL_AREA) {
        break;
      }
      for (PVector p : c.getPoints()) {
        stroke(255, 0, 0);
        point(p.x, p.y);
      }
    }

    if (chosen_blob != null) {
      chosen_blob.p = find_blob_color(cam, chosen_blob);
      last_blob = chosen_blob;
      PVector center_copy = new PVector(chosen_blob.center.x, chosen_blob.center.y);
      return center_copy;
    } else if (last_blob.contour != null) {
        last_blob.contour.draw();
    }
    return null;
  }
}

