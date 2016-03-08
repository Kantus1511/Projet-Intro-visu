float depth = 2000;
void settings() {
  size(1500, 900, P3D);
}
void setup() {
  noStroke();
}

float rotX = 0.0;
float rotZ = 0.0;
int coef = 80;

Shape shape = new Shape(600, 20, 600, 220, "Assignement 3");
void draw() {
  background(255);
  
  textSize(50);
  fill(0);
  text("rotX: " + (int)Math.toDegrees(rotX) + "°", -1880, -1080); 
  text("rotZ: " + (int)Math.toDegrees(rotZ) + "°", -1580, -1080); 
  text("speed " + coef + "%", -1280, -1080); 
  
  camera(0, 0, depth, 0, 0, 0, 0, 1, 0);
  directionalLight(50, 100, 125, 0, -1, 0);
  ambientLight(102, 102, 102);
  
  rotateX(rotX);
  rotateZ(rotZ);
  shape.render();
}

void mouseWheel(MouseEvent event) {
  float e = event.getCount();
  if (e < 0){
    if (coef < 100){
      coef += 1;
    } 
  } else {
    if (coef > 0){
      coef -= 1;
    } 
  }
}

void mouseDragged() {
  if (pmouseY > mouseY) {
    rotX += coef/1000.0;
    if (rotX > PI/3){
      rotX = PI/3;
    }
  } else if (pmouseY < mouseY) {
    rotX -= coef/1000.0;
    if (rotX < -PI/3){
      rotX = -PI/3;
    }
  }
  if (pmouseX > mouseX) {
    rotZ += coef/1000.0;
    if (rotZ > PI/3){
      rotZ = PI/3;
    }
  } else if (pmouseX < mouseX) {
    rotZ -= coef/1000.0;
    if (rotZ < -PI/3){
      rotZ = -PI/3;
    }
  }
}

class Shape {
  int x;
  int y;
  int z;
  int col;
  String text;
  Shape(int x, int y, int z, int col, String text) {
    this.x = x;
    this.y = y;
    this.z = z;
    this.col = col;
    this.text = text;
  }
  void render() {
    fill(col);
    beginShape();
    vertex(-x, -y, -z);vertex(-x, -y, z);vertex(x, -y, z);vertex(x, -y, -z);
    endShape(CLOSE);
    beginShape();
    vertex(-x, y, -z);vertex(-x, y, z);vertex(x, y, z);vertex(x, y, -z);
    endShape(CLOSE);
    beginShape();
    vertex(-x, -y, z);vertex(x, -y, z);vertex(x, y, z);vertex(-x, y, z);
    endShape(CLOSE);
    beginShape();
    vertex(x, -y, z);vertex(x, -y, -z);vertex(x, y, -z);vertex(x, y, z);
    endShape(CLOSE);
    beginShape();
    vertex(x, -y, -z);vertex(x, y, -z);vertex(-x, y, -z);vertex(-x, -y, -z);
    endShape(CLOSE);
    beginShape();
    vertex(-x, -y, -z);vertex(-x, y, -z);vertex(-x, y, z);vertex(-x, -y, z);
    endShape(CLOSE);
    textSize(80);
    fill(255, 0, 0);
    text(text, -x+50, -2*y, z); 
  }
}