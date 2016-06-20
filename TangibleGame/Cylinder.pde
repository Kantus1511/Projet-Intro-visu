class Cylinder {

  float cylinderBaseSize;
  float cylinderHeight;
  int cylinderResolution;
  PShape openCylinder = new PShape();
  PShape ceiling = new PShape();
  PShape bottom = new PShape();
  PVector pos;

  Cylinder(int x, int z) {
    pos = new PVector(x,0,z);
    cylinderBaseSize = 80;
    cylinderHeight = 120;
    cylinderResolution = 40;
    float angle;
    float[] xs = new float[cylinderResolution + 1];
    float[] zs = new float[cylinderResolution + 1];
    for (int i = 0; i < xs.length; i++) {
      angle = (TWO_PI / cylinderResolution) * i;
      xs[i] = sin(angle) * cylinderBaseSize;
      zs[i] = cos(angle) * cylinderBaseSize;
    }
    openCylinder = createShape();
    openCylinder.beginShape(QUAD_STRIP);
    //draw the border of the cylinder
    for (int i = 0; i < xs.length; i++) {
      openCylinder.vertex(xs[i], zs[i], 0);
      openCylinder.vertex(xs[i], zs[i], cylinderHeight);
    }
    openCylinder.endShape();
    ceiling = createShape();
    ceiling.beginShape(TRIANGLES);
    for (int i = 0; i < xs.length-1; i++) {
      ceiling.vertex(xs[i], zs[i], cylinderHeight);
      ceiling.vertex(xs[i+1], zs[i+1], cylinderHeight);
      ceiling.vertex(0, 0, cylinderHeight);
    }
    ceiling.endShape();
    bottom = createShape();
    bottom.beginShape(TRIANGLES);
    for (int i = 0; i < xs.length-1; i++) {
      bottom.vertex(xs[i], zs[i], 0);
      bottom.vertex(xs[i+1], zs[i+1], 0);
      bottom.vertex(0, 0, 0);
    }
    bottom.endShape();
  }

  void render() {
    pushMatrix();
    rotateX(PI/2);
    fill(176,196,222);
    translate(pos.x, pos.z, pos.y);
    shape(openCylinder);
    shape(ceiling);
    shape(bottom);
    popMatrix();
  }
}