class Mover {
  PVector location;
  PVector velocity;
  PVector gravity;
  PVector friction;
  
  int sizeSphere = 40;
  
  float normalForce = 1;
  float mu = 0.04;
  float frictionMagnitude = normalForce * mu;
  float g = 0.4;

  Mover() {
    location = new PVector(0, 0, 0);
    velocity = new PVector(0, 0, 0);
    gravity = new PVector(0, 0, 0);
    friction = new PVector(0, 0, 0);
  }

  void update() {
    gravity.x = sin(rotZ) * g;
    gravity.z =  sin(-rotX) * g;
    velocity.add(gravity);
    
    friction = velocity.get();
    friction.mult(-1);
    friction.normalize();
    friction.mult(frictionMagnitude);
    velocity.add(friction);
    
    location.add(velocity);
  }

  void display() {
    pushMatrix();
    strokeWeight(2);
    fill(176,196,222);
    translate(location.x, -(sizeSphere+boxY/2) + location.y, location.z);
    sphere(sizeSphere);
    popMatrix();
  }

  void checkEdges() {
    float dissipation = 0.8;
    float bornes = 0.2;
    if (location.x >= boxX/2) {
      totalScore -= velocity.mag();
      if (velocity.x < bornes || velocity.x > bornes){
        location.x = boxX/2;
      }
      velocity.x = -dissipation*velocity.x;
    } else if (location.x <= -boxX/2) {
      totalScore -= velocity.mag();
      if (velocity.x < bornes || velocity.x > bornes){
        location.x = -boxX/2;
      }
      velocity.x = -dissipation*velocity.x;
    }
    if (location.z >= boxZ/2) {
      totalScore -= velocity.mag();
      if (velocity.z < bornes || velocity.z > bornes){
        location.z = boxZ/2;
      }
      velocity.z = -dissipation*velocity.z;
    } else if (location.z <= -boxZ/2) {
      totalScore -= velocity.mag();
      if (velocity.z < bornes || velocity.z > bornes){
        location.z = -boxZ/2;
      }
      velocity.z = -dissipation*velocity.z;
    }
    if (totalScore < 0.0){
      totalScore = 0.0; 
    }
  }
  
  void checkCylinderCollision() {
    for (int i=0; i<cylinders.size(); i++){
      int dist = (int)(sqrt(sq(cylinders.get(i).pos.x-location.x) + sq(cylinders.get(i).pos.z-location.z)));
      if (dist <= cylinders.get(i).cylinderBaseSize+sizeSphere){
         lastHitValue = velocity.mag();
         totalScore += lastHitValue;
         PVector n = new PVector();
         PVector.sub(location, cylinders.get(i).pos, n);
         PVector.add(cylinders.get(i).pos, n.mult(1.01), location);
         n.normalize();
         velocity.sub(n.mult(velocity.dot(n)).mult(2));
      }
    }
  }
}