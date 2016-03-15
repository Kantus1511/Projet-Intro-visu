class Mover {
  PVector location;
  PVector velocity;
  PVector gravity;
  int size;
  float g = 0.4;

  Mover() {
    location = new PVector(0, 0, 0);
    velocity = new PVector(0, 0, 0);
    gravity = new PVector(0, 0, 0);
    size = 40;
  }

  void update() {
    //Gravity Effect
    gravity.x = sin(rotZ) * g;
    gravity.z = sin(-rotX) * g;

    velocity.add(gravity);

    //Frictions
    float normalForce = 1;
    float mu = 0.075;
    float frictionMagnitude = normalForce * mu;
    PVector friction = velocity.get();
    friction.mult(-1);
    friction.normalize();
    friction.mult(frictionMagnitude);
    velocity.add(friction);

    
    //Move
    location.add(velocity);
  }

  void display() {
    fill(127);
    pushMatrix();
    translate(location.x, -(size+boxY/2) + location.y, location.z);
    sphere(size);
    popMatrix();
  }

  void checkEdges() {
    if (location.x >= boxX/2) {
      if (velocity.x < 0.1 && velocity.x > -0.1){
        location.x = boxX/2;
      }
      velocity.x = -velocity.x;
    } else if (location.x <= -boxX/2) {
      if (velocity.x < 0.1 && velocity.x > -0.1){
        location.x = -boxX/2;
      }
      velocity.x = -velocity.x;
    }
    if (location.z >= boxZ/2) {
      if (velocity.z < 0.1 && velocity.z > -0.1){
        location.z = boxZ/2;
      }
      velocity.z = -velocity.z;
    } else if (location.z <= -boxZ/2) {
      if (velocity.z < 0.1 && velocity.z > -0.1){
        location.z = -boxZ/2;
      }
      velocity.z = -velocity.z;
    }
  }
}