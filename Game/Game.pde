float depth = 2700;
float rotX = 0.0;
float rotZ = 0.0;
float totalScore = 0.0;
float lastHitValue = 0.0;
float highScore = 0.0;
float sizeRect = 10.0;
int coef = 70;
int frameX = 1500;
int frameY = 900;
int dataXY = 160;
int boxX = 1200;
int boxY = 20;
int boxZ = 1200;
int chartX = 1080;
int chartY = 120;
int time = millis();
Mover mover;
ArrayList<Cylinder> cylinders;
ArrayList<Float> scores;
PGraphics dataSurface;
PGraphics topView;
PGraphics score;
PGraphics barChart;
boolean shift = false;
HScrollbar hs;

void settings() {
  size(frameX, frameY, P3D);
}
void setup() {
  mover = new Mover();
  cylinders = new ArrayList<Cylinder>();
  scores = new ArrayList<Float>();
  dataSurface = createGraphics(frameX, 200, P2D);
  topView = createGraphics(160, 160, P2D);
  score = createGraphics(140, 160, P2D);
  barChart = createGraphics(chartX, chartY, P2D);
  hs = new HScrollbar(400, 860, 400, 20);
}

void draw() {
  noStroke();
  background(255);
  drawData();
  drawTop();
  drawScore();
  drawChart();
  image(dataSurface, 0, frameY-200);
  image(topView, 20, frameY-180);
  image(score, 220, frameY-180);
  image(barChart, 400, frameY-180);
  if (millis() > time + 1000 && !shift){
    scores.add(totalScore);
    time = millis();
    if (totalScore > highScore) highScore = totalScore;
  }
  hs.update();
  hs.display();
  sizeRect = 20*hs.getPos();
  
  if (shift){
    textSize(18);
    fill(0);
    text("Edit Mode", 10, 25); 
  } else {
    textSize(18);
    fill(0);
    text("rotX: " + (int)Math.toDegrees(rotX) + "°", 10, 25); 
    text("rotZ: " + (int)Math.toDegrees(rotZ) + "°", 120, 25); 
    text("speed " + coef + "%", 230, 25); 
  }

  pushMatrix();
  camera(0, -400, depth, 0, 0, 0, 0, 1, 0);
  directionalLight(255, 255, 255, -0.3, 0.8, -0.5);

  if (shift) {
    rotateX(-PI/2);
  } else {
    rotateX(rotX);
    rotateZ(rotZ);
    mover.update();
    mover.checkEdges();
    mover.checkCylinderCollision();
  }
  for (int i=0; i<cylinders.size(); i++) {
    cylinders.get(i).render();
  }

  fill(120);
  box(boxX, boxY, boxZ);
  mover.display();
  popMatrix();
}

void drawData(){
  dataSurface.beginDraw();
  dataSurface.background(255,222,173);
  dataSurface.endDraw();
}

void drawTop(){
  float scale = dataXY/(float)boxX;
  topView.noStroke();
  topView.beginDraw();
  topView.background(0,0,123);
  topView.fill(255, 0, 0);
  topView.ellipse(dataXY/2+scale*mover.location.x, dataXY/2+scale*mover.location.z, 2*scale*mover.sizeSphere, 2*scale*mover.sizeSphere);
  topView.fill(255,222,173);
  for (int i=0; i<cylinders.size(); i++){
    topView.ellipse(scale*(cylinders.get(i).pos.x+boxX/2), scale*(cylinders.get(i).pos.z+boxZ/2), 2*scale*cylinders.get(i).cylinderBaseSize, 2*scale*cylinders.get(i).cylinderBaseSize);
  }
  topView.endDraw();
}

void drawScore(){
  score.beginDraw();
  score.background(255,255,255);
  score.noStroke();
  score.fill(255,222,173);
  score.rect(5,5,130,150);
  score.fill(0);
  score.textSize(16);
  score.text("Total Score", 10, 25);
  score.text("" + totalScore, 10, 45);
  score.text("Velocity", 10, 75);
  score.text("" + (int)(mover.velocity.mag()*1000)/1000.0, 10, 95);
  score.text("Last Score", 10, 125);
  score.text("" + lastHitValue, 10, 145);
  score.endDraw();
}

void drawChart(){
  barChart.beginDraw();
  barChart.background(255,242,213);
  barChart.fill(0,0,123);
  barChart.noStroke();
  float scale = 0.0;
  if (highScore > 0.0){
    scale = chartY/highScore;
  }
  for(int i=0; i<scores.size(); i++){
    barChart.rect(i*sizeRect,chartY-scale*scores.get(i),sizeRect,scale*scores.get(i));
  }
  barChart.endDraw();
}

void mouseWheel(MouseEvent event) {
  if (!shift) {
    float e = event.getCount();
    if (e < 0) {
      if (coef < 100) {
        coef += 1;
      }
    } else {
      if (coef > 0) {
        coef -= 1;
      }
    }
  }
}

void mousePressed(MouseEvent e) {
  if (shift && e.getButton() == LEFT) {
    float coef = depth/392.15;
    if (mouseX > width/2-boxX/coef && mouseX < width/2+boxX/coef && mouseY > height/2-boxZ/coef && mouseY < height/2+boxZ/coef) {
      int posX = (int)((mouseX-width/2)*0.00117*depth);
      int posZ = (int)((mouseY-height/2)*0.00117*depth);
      boolean alone = true;
      for (int i=0; i<cylinders.size(); i++){
        int dist = (int)(sqrt(sq(cylinders.get(i).pos.x-posX) + sq(cylinders.get(i).pos.z-posZ)));
        if (dist < 2*cylinders.get(i).cylinderBaseSize){
          alone = false;
          break;
        }
      }
      if (alone){
        cylinders.add(new Cylinder(posX, posZ));
      }
    }
  }
}

void mouseDragged() {
  if (!shift && mouseY < frameY-200) {
    float scale = 3000.0;
    if (pmouseY > mouseY) {
      rotX += coef/scale;
      if (rotX > PI/3) {
        rotX = PI/3;
      }
    } else if (pmouseY < mouseY) {
      rotX -= coef/scale;
      if (rotX < -PI/3) {
        rotX = -PI/3;
      }
    }
    if (pmouseX > mouseX) {
      rotZ -= coef/scale;
      if (rotZ < -PI/3) {
        rotZ = -PI/3;
      }
    } else if (pmouseX < mouseX) {
      rotZ += coef/scale;
      if (rotZ > PI/3) {
        rotZ = PI/3;
      }
    }
  }
}

void keyPressed() {
  if (key == CODED) {
    if (keyCode == SHIFT) {
      shift = true;
    }
  }
}

void keyReleased() {
  if (key == CODED) {
    if (keyCode == SHIFT) {
      shift = false;
    }
  }
}