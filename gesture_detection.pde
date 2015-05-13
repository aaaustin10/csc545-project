   opencv.loadImage(cam);
    opencv.threshold(140);
    opencv.blur(1);

    faces = opencv.detect();
    println(faces.length);

    image(opencv.getOutput(), 0, 0);

    ArrayList<Contour> contours = opencv.findContours(false, true);

    noFill();
    stroke(0, 255, 0);
    strokeWeight(3);
    int averageX = 0, averageY = 0;
    float dist; 
    float averageDist = 0.0;
    

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
      
      
      // attempt to determine a click by making a fist
      // size of the "hand" should be smaller for click
      // first find the average distance from the mouse point and each vertex
      // seems to work if you have a steady target
      for (PVector p : points) {
        dist = sqrt(sq(1.0*averageX - p.x) + sq(1.0*averageY-p.y));
        averageDist += dist;        
      }    
      averageDist /= points.size();
      // keep a running average of the size of the target
      runningAverage = 0.9*runningAverage + 0.1*averageDist;
      println(averageDist, runningAverage);
      // if the target suddenly gets smaller and not clicked, assume a click
      if ((averageDist < 0.75*runningAverage) & !click) click = true;
      // if the target suddenly gets larger and clicked, assume unclick
      if ((averageDist > 1.25*runningAverage) & click) click = false;
      // change the color of the mouse dot in the camera display to blue when clicked
      if (click) stroke(0,0,255);
      averageDist = 0.0;
      
      point(averageX, averageY); // draw on screen
    }
    averageX = (int)map(averageX, 0, 640, 0, displayWidth);
    averageY = (int)map(averageY, 0, 480, 0, displayHeight);
    return new Point(averageX, averageY);
  }
}
