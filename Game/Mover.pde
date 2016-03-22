class Mover {
  PVector location;
  PVector velocity;
  PVector gravity;
<<<<<<< HEAD
  PVector friction;
  
  int sizeSphere = 40;
  
  float normalForce = 1;
  float mu = 0.04;
  float frictionMagnitude = normalForce * mu;
=======
  int size;
>>>>>>> 894deab49df7278e86395746c15fa442d7727d83
  float g = 0.4;

  Mover() {
    location = new PVector(0, 0, 0);
    velocity = new PVector(0, 0, 0);
    gravity = new PVector(0, 0, 0);
<<<<<<< HEAD
    friction = new PVector(0, 0, 0);
  }

  void update() {
    gravity.x = sin(rotZ) * g;
    gravity.z =  sin(-rotX) * g;
    velocity.add(gravity);
    
    friction = velocity.get();
=======
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
>>>>>>> 894deab49df7278e86395746c15fa442d7727d83
    friction.mult(-1);
    friction.normalize();
    friction.mult(frictionMagnitude);
    velocity.add(friction);
<<<<<<< HEAD
    
=======

    
    //Move
>>>>>>> 894deab49df7278e86395746c15fa442d7727d83
    location.add(velocity);
  }

  void display() {
<<<<<<< HEAD
    strokeWeight(2);
    fill(127);
    translate(location.x, -(sizeSphere+boxY/2) + location.y, location.z);
    sphere(sizeSphere);
  }

  void checkEdges() {
    float dissipation = 0.8;
    float bornes = 0.2;
    if (location.x >= boxX/2) {
      if (velocity.x < bornes || velocity.x > bornes){
        location.x = boxX/2;
      }
      velocity.x = -dissipation*velocity.x;
    } else if (location.x <= -boxX/2) {
      if (velocity.x < bornes || velocity.x > bornes){
        location.x = -boxX/2;
      }
      velocity.x = -dissipation*velocity.x;
    }
    if (location.z >= boxZ/2) {
      if (velocity.z < bornes || velocity.z > bornes){
        location.z = boxZ/2;
      }
      velocity.z = -dissipation*velocity.z;
    } else if (location.z <= -boxZ/2) {
      if (velocity.z < bornes || velocity.z > bornes){
        location.z = -boxZ/2;
      }
      velocity.z = -dissipation*velocity.z;
=======
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
>>>>>>> 894deab49df7278e86395746c15fa442d7727d83
    }
  }
}