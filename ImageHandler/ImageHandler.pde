import processing.video.*;

Capture cam;
HScrollbar thresholdBar1;
HScrollbar thresholdBar2;
PImage img;

void settings() {
  size(640, 480);
}

void setup () {
  String[] cameras = Capture.list();
  if (cameras.length == 0) {
    println("There are no cameras available for capture.");
    exit();
  } else {
    println("Available cameras:");
    for (int i = 0; i < cameras.length; i++) {
      println(cameras[i]);
    }
    cam = new Capture(this, cameras[5]);
    cam.start();
  }
}

void draw() {
  if (cam.available() == true) {
    cam.read();
  }
  img = cam;
  image(img, 0, 0);
  ArrayList<PVector> vectors = hough(sobel(convolute(hueImg(img, 117, 134))), 10);
  getIntersections(vectors);
}

void drawThresh() {
  image(thresholdBinary(img, (int)(thresholdBar1.getPos()*255)), 800, 0);
  thresholdBar1.display();
  thresholdBar1.update();
}

void drawSobelThresh() {
  int val1 = (int)(thresholdBar1.getPos()*255);
  int val2 = (int)(thresholdBar2.getPos()*255);
  image(sobel(convolute(hueImg(img, Math.min(val1, val2), Math.max(val1, val2)))), 800, 0);
  thresholdBar1.display();
  thresholdBar1.update();
  thresholdBar2.display();
  thresholdBar2.update();
}

void drawHue() {
  int val1 = (int)(thresholdBar1.getPos()*255);
  int val2 = (int)(thresholdBar2.getPos()*255);
  image(hueImg(img, Math.min(val1, val2), Math.max(val1, val2)), 800, 0);
  thresholdBar1.display();
  thresholdBar1.update();
  thresholdBar2.display();
  thresholdBar2.update();
}

PImage thresholdBinary(PImage img, int threshold) {
  PImage result = createImage(img.width, img.height, RGB);
  for (int i = 0; i < img.width * img.height; i++) {
    float bright = brightness(img.pixels[i]);
    if (bright > threshold) {
      result.pixels[i] = color(255, 255, 255);
    } else {
      result.pixels[i] = color(0, 0, 0);
    }
  }
  return result;
}

PImage thresholdBinaryInverted(PImage img, int threshold) {
  PImage result = createImage(img.width, img.height, RGB);
  for (int i = 0; i < img.width * img.height; i++) {
    float bright = brightness(img.pixels[i]);
    if (bright > threshold) {
      result.pixels[i] = color(0, 0, 0);
    } else {
      result.pixels[i] = color(255, 255, 255);
    }
  }
  return result;
}

PImage hueImg(PImage img, int min, int max) {
  PImage result = createImage(img.width, img.height, HSB);
  for (int i = 0; i < img.width * img.height; i++) {
    float h = hue(img.pixels[i]);
    if (h > min && h < max) {
      result.pixels[i] = img.pixels[i];
    } else {
      result.pixels[i] = color(0);
    }
  }
  return result;
}

PImage convolute(PImage img) {
  float[][] kernel = { { 10, 10, 10 }, 
    { 10, 10, 10 }, 
    { 10, 10, 10 }};
  int N = kernel.length;
  PImage result = createImage(img.width, img.height, ALPHA);

  for (int i=0; i<img.width * img.height; i++) { 
    float weight = 0.f;  
    int x = i % img.width;
    int y = (int) Math.floor(i / (float) img.width);
    float sum = 0;
    for (int j=x-N/2; j<=x+N/2; j++) {
      for (int m=y-N/2; m<=y+N/2; m++) {
        if (j>=0 && j<img.width && m>=0 && m<img.height) {
          sum += brightness(img.pixels[m*img.width+j])*kernel[j-(x-N/2)][m-(y-N/2)];
          if (kernel[j-(x-N/2)][m-(y-N/2)] != 0) {
            weight += kernel[j-(x-N/2)][m-(y-N/2)];
          }
        }
      }
    }
    result.pixels[i] = color((int)(sum/weight));
  }

  return result;
}

PImage sobel(PImage img) {
  float[][] hKernel = { { 0, 1, 0 }, 
    { 0, 0, 0 }, 
    { 0, -1, 0 } };
  float[][] vKernel = { { 0, 0, 0 }, 
    { 1, 0, -1 }, 
    { 0, 0, 0 } };                 
  PImage result = createImage(img.width, img.height, ALPHA);

  for (int i = 0; i < img.width * img.height; i++) {
    result.pixels[i] = color(0);
  }

  float max=0;
  float[] buffer = new float[img.width * img.height];

  for (int i=0; i<img.width * img.height; i++) { 
    float sumh = 0.f;
    float sumv = 0.f;

    int N = hKernel.length;
    int x = i % img.width;
    int y = (int) Math.floor(i / (float) img.width);
    for (int j=x-N/2; j<=x+N/2; j++) {
      for (int m=y-N/2; m<=y+N/2; m++) {
        if (j>=0 && j<img.width && m>=0 && m<img.height) {
          sumh += brightness(img.pixels[m*img.width+j])*hKernel[j-(x-N/2)][m-(y-N/2)];
        }
      }
    }

    N = vKernel.length;
    for (int j=x-N/2; j<=x+N/2; j++) {
      for (int m=y-N/2; m<=y+N/2; m++) {
        if (j>=0 && j<img.width && m>=0 && m<img.height) {
          sumv += brightness(img.pixels[m*img.width+j])*vKernel[j-(x-N/2)][m-(y-N/2)];
        }
      }
    }

    float sum = sqrt(pow(sumh, 2) + pow(sumv, 2));
    buffer[i] = sum;
    if (sum > max) {
      max = sum;
    }
  }

  for (int y = 2; y < img.height - 2; y++) { 
    for (int x = 2; x < img.width - 2; x++) { 
      if (buffer[y * img.width + x] > (int)(max * 0.3f)) { // 30% of the max
        result.pixels[y * img.width + x] = color(255);
      } else {
        result.pixels[y * img.width + x] = color(0);
      }
    }
  }
  return result;
}

ArrayList<PVector> hough(PImage edgeImg, int nLines) {
  ArrayList<PVector> vectors = new ArrayList();
  float discretizationStepsPhi = 0.06f;
  float discretizationStepsR = 2.5f;
  ArrayList<Integer> bestCandidates = new ArrayList();
  int minVotes = 300;

  int phiDim = (int) (Math.PI / discretizationStepsPhi);
  int rDim = (int) (((edgeImg.width + edgeImg.height) * 2 + 1) / discretizationStepsR);

  int[] accumulator = new int[(phiDim + 2) * (rDim + 2)];

  for (int y = 0; y < edgeImg.height; y++) {
    for (int x = 0; x < edgeImg.width; x++) {
      if (brightness(edgeImg.pixels[y * edgeImg.width + x]) != 0) {
        for (int m = 0; m < phiDim; m++) {
          float phi = m*discretizationStepsPhi;
          float r = x*cos(phi) + y*sin(phi);
          int coordR = Math.round((r / discretizationStepsR))+(rDim - 1)/2;
          accumulator[(m+1)*(rDim + 2) + 1 + coordR] += 1;
        }
      }
    }
  }

  // size of the region we search for a local maximum
  int neighbourhood = 10;
  for (int accR = 0; accR < rDim; accR++) {
    for (int accPhi = 0; accPhi < phiDim; accPhi++) {
      // compute current index in the accumulator
      int idx = (accPhi + 1) * (rDim + 2) + accR + 1;
      if (accumulator[idx] > minVotes) {
        boolean bestCandidate=true;
        // iterate over the neighbourhood
        for (int dPhi=-neighbourhood/2; dPhi < neighbourhood/2+1; dPhi++) {
          // check we are not outside the image
          if ( accPhi+dPhi < 0 || accPhi+dPhi >= phiDim) continue;
          for (int dR=-neighbourhood/2; dR < neighbourhood/2 +1; dR++) {
            if (accR+dR < 0 || accR+dR >= rDim) continue;
            int neighbourIdx = (accPhi + dPhi + 1) * (rDim + 2) + accR + dR + 1;
            if (accumulator[idx] < accumulator[neighbourIdx]) {
              // the current idx is not a local maximum!
              bestCandidate=false;
              break;
            }
          }
          if (!bestCandidate) break;
        }
        if (bestCandidate) {
          // the current idx *is* a local maximum
          bestCandidates.add(idx);
        }
      }
    }
  }
  
  /*for (int i=0; i<accumulator.length; i++){
    if (accumulator[i] >= minVotes){
      bestCandidates.add(i);
    }
  }*/

  java.util.Collections.sort(bestCandidates, new HoughComparator(accumulator));

  PImage houghImg = createImage(rDim + 2, phiDim + 2, ALPHA);
  for (int i = 0; i < accumulator.length; i++) {
    houghImg.pixels[i] = color(min(255, accumulator[i]));
  }

  houghImg.updatePixels();

  for (int idx = 0; idx < Math.min(nLines, bestCandidates.size()); idx++) {
    int accPhi = (int) (bestCandidates.get(idx) / (rDim + 2)) - 1;
    int accR = bestCandidates.get(idx) - (accPhi + 1) * (rDim + 2) - 1;
    float r = (accR - (rDim - 1) * 0.5f) * discretizationStepsR;
    float phi = accPhi * discretizationStepsPhi;
    
    vectors.add(new PVector(r, phi));

    int x0 = 0;
    int y0 = (int) (r / sin(phi));
    int x1 = (int) (r / cos(phi));
    int y1 = 0;
    int x2 = edgeImg.width;
    int y2 = (int) (-cos(phi) / sin(phi) * x2 + r / sin(phi));
    int y3 = edgeImg.width;
    int x3 = (int) (-(y3 - r / sin(phi)) * (sin(phi) / cos(phi)));

    stroke(204, 102, 0);
    if (y0 > 0) {
      if (x1 > 0)
        line(x0, y0, x1, y1);
      else if (y2 > 0)
        line(x0, y0, x2, y2);
      else
        line(x0, y0, x3, y3);
    } else {
      if (x1 > 0) {
        if (y2 > 0)
          line(x1, y1, x2, y2);
        else
          line(x1, y1, x3, y3);
      } else
        line(x2, y2, x3, y3);
    }
  }
  return vectors;
}

ArrayList<PVector> getIntersections(java.util.List<PVector> lines) {
  ArrayList<PVector> intersections = new ArrayList<PVector>();
  for (int i = 0; i < lines.size() - 1; i++) {
    PVector line1 = lines.get(i);
    for (int j = i + 1; j < lines.size(); j++) {
      PVector line2 = lines.get(j);
      // compute the intersection and add it to ’intersections’
      float d = cos(line2.y)*sin(line1.y)-cos(line1.y)*sin(line2.y);
      int x = (int)((line2.x*sin(line1.y)-line1.x*sin(line2.y))/d);
      int y = (int)((-line2.x*cos(line1.y)+line1.x*cos(line2.y))/d);
      intersections.add(new PVector(x, y));
      // draw the intersection
      fill(255, 128, 0);
      ellipse(x, y, 10, 10);
    }
  }
  return intersections;
}