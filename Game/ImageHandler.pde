import processing.video.*;
import java.util.*;

class ImageHandler extends PApplet {

  //Capture cam;
  Movie cam;
  HScrollbar thresholdBar1;
  HScrollbar thresholdBar2;
  QuadGraph quads;
  PImage img;
  PImage houghImg;
  int width = 640;
  int height = 480;
  TwoDThreeD td = new TwoDThreeD(width, height);
  int sat = 50;
  int minHue = 60;
  int maxHue = 130;
  int bright = 50;
  float angleX = 0.f;
  float angleY = 0.f;

  void settings() {
    size(width, height);
  }

  void setup () {
    String[] cameras = Capture.list();
    if (cameras.length == 0) {
      println("There are no cameras available for capture.");
      exit();
    } else {
      //cam = new Capture(this, cameras[0]);
      //cam.start();
      cam = new Movie(this, "testvideo.mp4"); 
      cam.loop();

    }
  }

  void draw() {
    if (cam.available() == true) {
      cam.read();
    }
    img = cam;

    if (img.width != 0) {
      img = lineDetection(img, sat, minHue, maxHue, bright);

      ArrayList<PVector> vectors = hough(img, 6);
      QuadGraph qg = new QuadGraph();
      qg.build(vectors, img.width, height);
      List<int[]> cycles = qg.findCycles();
      List<PVector> intersecs = new ArrayList();

      if (vectors.size() > 3) {
        if (cycles.isEmpty()) {
          intersecs = vectors.subList(0, 4);
        } else {
          for (int i=0; i<cycles.get(0).length; i++) {
            intersecs.add(vectors.get(cycles.get(0)[i]));
          }
        }

        List<PVector> inters = qg.sortCorners(getIntersections(intersecs));

        image(img, 0, 0);

        PVector angles = td.get3DRotations(inters);
        angleX = angles.x;
        angleY = angles.y;
      }
    }
  }
  
  PVector getAngles(){
    return new PVector(angleX, angleY); 
  }

  PImage lineDetection(PImage img, int sat, int minHue, int maxHue, int bright) {
    PImage ret = img;
    ret = thresholdSaturation(ret, sat);
    ret = hueImg(ret, minHue, maxHue);
    ret = thresholdBrightness(ret, bright);
    ret = convolute(ret);
    ret = sobel(ret);
    return ret;
  }

  PImage thresholdBrightness(PImage img, int threshold) {
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

  public PImage thresholdSaturation(PImage img, float threshold) {
    PImage result = createImage(img.width, img.height, ALPHA);
    for (int i = 0; i < img.width * img.height; i++) {
      if (saturation(img.pixels[i]) > threshold) {
        result.pixels[i] = img.pixels[i];
      } else {
        result.pixels[i] = color(0);
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
    float[][] kernel = { { 9, 12, 9 }, 
      { 12, 15, 12 }, 
      { 9, 12, 9 } };
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
    int minVotes = 100;

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

    java.util.Collections.sort(bestCandidates, new HoughComparator(accumulator));

    houghImg = createImage(rDim + 2, phiDim + 2, ALPHA);
    for (int i = 0; i < accumulator.length; i++) {
      houghImg.pixels[i] = color(min(255, accumulator[i]));
    }

    houghImg.resize(width, height);
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

  ArrayList<PVector> getIntersections(List<PVector> lines) {
    ArrayList<PVector> intersections = new ArrayList<PVector>();
    for (int i = 0; i < lines.size() - 1; i++) {
      PVector line1 = lines.get(i);
      for (int j = i + 1; j < lines.size(); j++) {
        PVector line2 = lines.get(j);
        // compute the intersection and add it to ’intersections’
        float d = cos(line2.y)*sin(line1.y)-cos(line1.y)*sin(line2.y);
        int x = (int)((line2.x*sin(line1.y)-line1.x*sin(line2.y))/d);
        int y = (int)((-line2.x*cos(line1.y)+line1.x*cos(line2.y))/d);
        if (j-i != 2) {
          intersections.add(new PVector(x, y));
          // draw the intersection
          fill(255, 128, 0);
          ellipse(x, y, 10, 10);
        }
      }
    }
    return intersections;
  }
}