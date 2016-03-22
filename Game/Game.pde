//// Variables Globales
float depth = 2000;
float rotX = 0.0;
float rotZ = 0.0;
int coef = 50;
<<<<<<< HEAD
Mover mover;

int boxX = 1200;
int boxY = 20;
int boxZ = 1200;
=======
int boxX = 1200;
int boxY = 20;
int boxZ = 1200;
Mover mover;

>>>>>>> 894deab49df7278e86395746c15fa442d7727d83

void settings() {
  size(1500, 900, P3D);
}
void setup() {
<<<<<<< HEAD
  mover = new Mover();
}

=======
  noStroke();
  mover = new Mover();
}



>>>>>>> 894deab49df7278e86395746c15fa442d7727d83
void draw() {
  noStroke();
  background(255);
  textSize(50);
  fill(0);
  text("rotX: " + (int)Math.toDegrees(rotX) + "°", -1880, -1080); 
  text("rotZ: " + (int)Math.toDegrees(rotZ) + "°", -1580, -1080); 
  text("speed " + coef + "%", -1280, -1080); 

  camera(0, 0, depth, 0, 0, 0, 0, 1, 0);
<<<<<<< HEAD
  directionalLight(50, 100, 125, -1, 1, -1);
=======
  directionalLight(50, 100, 125, -1, 1, -1); 
>>>>>>> 894deab49df7278e86395746c15fa442d7727d83
  ambientLight(102, 102, 102);
  rotateX(rotX);
  rotateZ(rotZ);
  fill(220);
  box(boxX, boxY, boxZ);
<<<<<<< HEAD

  mover.update();
  mover.checkEdges();
  mover.display();
=======
  
  
  //BALL
  mover.update();
  mover.checkEdges();
  mover.display();
  
>>>>>>> 894deab49df7278e86395746c15fa442d7727d83
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
<<<<<<< HEAD
    rotZ -= coef/3000.0;
=======
      rotZ -= coef/3000.0;
>>>>>>> 894deab49df7278e86395746c15fa442d7727d83
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