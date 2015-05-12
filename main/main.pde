import gab.opencv.*;
import processing.video.*;
import java.awt.*;

Capture video;
OpenCV opencv;

void setup() {
  size(640, 480);
  video = new Capture(this, 640, 480);
  opencv = new OpenCV(this, 640, 480);
  video.start();
}

float color_dist(int c1, int c2) {
  return dist(red(c1), green(c1), blue(c1), red(c2), green(c2), blue(c2));
}

PImage find_close_pixels(PImage img, color c) {  
  PImage target = img.get(0, 0, img.width, img.height); 
  for (int x = 0; x < img.width; x++) {
    for (int y = 0; y < img.height; y++) {
      color p = target.get(x, y);
      if (color_dist(p, c) > 30) {
        target.set(x, y, color(0));
      }
    }
  }
  return target;
}

color find_blob_color(PImage img, Contour c) {
  int min_x, min_y, max_x, max_y;
  min_x = min_y = 0x7fffffff;
  max_x = max_y = -1;
  
  for (PVector p : c.getPoints()) {
    max_x = max_x < p.x ? (int)p.x : max_x;
    min_x = min_x > p.x ? (int)p.x : min_x;
    max_y = max_y < p.y ? (int)p.y : max_y;
    min_y = min_y > p.y ? (int)p.y : min_y;
  }
  
  println(max_x, min_x, max_y, min_y);
  int r = 0;
  int g = 0;
  int b = 0;
  int num_pix = 1;
  
  final int bound = 25;
  boolean[][] near_array = new boolean[img.width / bound + bound][img.height / bound + bound];
  
  for (int x = 0; x < img.width; x++) {
    for (int y = 0; y < img.height; y++) {
      if (x <= max_x && x >= min_x && y <= max_y && y >= min_y) {
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
  println(r, g, b);
  return color(r, g, b);
}

color avg = color(255);
void draw() {
  background(0);
  PImage img2 = find_close_pixels(video, avg);
  image(img2, 0, 0);
  opencv.loadImage(img2);
  //opencv.loadImage(video);
  opencv.threshold(1);
  //image(opencv.getOutput(), 0, 0);
  ArrayList<Contour> contours = opencv.findContours(false, true);
  noFill();
  stroke(0, 255, 0);
  strokeWeight(3);
  Contour c = null;
  for (int i = 0; i < contours.size() && i < 1; i++) {
    c = contours.get(i).getConvexHull();
    c.draw();
    contours.get(i).draw();
    for (PVector p : c.getPoints()) {
      stroke(255, 0, 0);
      point(p.x, p.y);
    }
  }
  
  if (c != null) {
    avg = find_blob_color(video, c);
  }
}

void captureEvent(Capture c) {
  c.read();
}


/*import java.awt.*;
import java.awt.event.*;        
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

// This only works inside the environment, but
// it's a decent proof of concept for how clicks
// should be implemented. If this was how we were 
// going to implement this, we would use a Java 
// Key Listener event, and it would work even with
// this program minimized.
void keyPressed() {
  if (key == ' ') {
    robot.mousePress(InputEvent.BUTTON1_MASK);
    robot.mouseRelease(InputEvent.BUTTON1_MASK);
  }
}*/
