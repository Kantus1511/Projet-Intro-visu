float depth = 2000;
float rotX = 0.0;
float rotZ = 0.0;
int coef = 50;
Mover mover;

int boxX = 1200;
int boxY = 20;
int boxZ = 1200;

void settings() {
  size(1500, 900, P3D);
}
void setup() {
  mover = new Mover();
}

void draw() {
  noStroke();
  background(255);

  textSize(50);
  fill(0);
  text("rotX: " + (int)Math.toDegrees(rotX) + "°", -1880, -1080); 
  text("rotZ: " + (int)Math.toDegrees(rotZ) + "°", -1580, -1080); 
  text("speed " + coef + "%", -1280, -1080); 

  camera(0, 0, depth, 0, 0, 0, 0, 1, 0);
  directionalLight(50, 100, 125, -1, 1, -1);
  ambientLight(102, 102, 102);

  rotateX(rotX);
  rotateZ(rotZ);
  fill(220);
  box(boxX, boxY, boxZ);

  mover.update();
  mover.checkEdges();
  mover.display();
}

void mouseWheel(MouseEvent event) {
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

void mouseDragged() {
  if (pmouseY > mouseY) {
    rotX += coef/3000.0;
    if (rotX > PI/3) {
      rotX = PI/3;
    }
  } else if (pmouseY < mouseY) {
    rotX -= coef/3000.0;
    if (rotX < -PI/3) {
      rotX = -PI/3;
    }
  }
  if (pmouseX > mouseX) {
    rotZ -= coef/3000.0;
    if (rotZ < -PI/3) {
      rotZ = -PI/3;
    }
  } else if (pmouseX < mouseX) {
    rotZ += coef/3000.0;
    if (rotZ > PI/3) {
      rotZ = PI/3;
    }
  }
}