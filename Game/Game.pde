float depth = 2000;
float rotX = 0.0;
float rotZ = 0.0;
int coef = 50;
Mover mover;
ArrayList<Cylinder> cylinders;

boolean shift = false;

int boxX = 1200;
int boxY = 20;
int boxZ = 1200;

void settings() {
  size(1500, 900, P3D);
}
void setup() {
  mover = new Mover();
  cylinders = new ArrayList<Cylinder>();
}

void draw() {
  noStroke();
  background(255);

  camera(0, 0, depth, 0, 0, 0, 0, 1, 0);
  directionalLight(50, 100, 125, -1, 1, -1);
  ambientLight(102, 102, 102);


  if (shift) {
    textSize(50);
    fill(0);
    text("Edit Mode", -1880, -1080); 
    rotateX(-PI/2);
  } else {
    textSize(50);
    fill(0);
    text("rotX: " + (int)Math.toDegrees(rotX) + "°", -1880, -1080); 
    text("rotZ: " + (int)Math.toDegrees(rotZ) + "°", -1580, -1080); 
    text("speed " + coef + "%", -1280, -1080); 

    rotateX(rotX);
    rotateZ(rotZ);
    mover.update();
    mover.checkEdges();
    mover.checkCylinderCollision();
  }
  for (int i=0; i<cylinders.size(); i++) {
    cylinders.get(i).render();
  }

  fill(220);
  box(boxX, boxY, boxZ);
  mover.display();
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
  if (!shift) {
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