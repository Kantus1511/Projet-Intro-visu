void settings() {
  size(1000, 1000, P2D);
}

My3DPoint eye = new My3DPoint(0, 0, -5000);
My3DPoint origin = new My3DPoint(0, 0, 0);
My3DBox input3DBox = new My3DBox(origin, 100, 150, 300);

void setup () {
  float[][] transform2 = translationMatrix(400, 400, 0);
  input3DBox = transformBox(input3DBox, transform2);
  projectBox(eye, input3DBox).render();
}


void draw() {
  background(255, 255, 255);
  projectBox(eye, input3DBox).render();
}

//Interaction :
void mouseDragged() {
  float scale = 1.0;
  if (pmouseY > mouseY) {
    scale = 1.1;
  } else if (pmouseY < mouseY) {
    scale = 0.9;
  }
  float[][] transform3 = scaleMatrix(scale, scale, scale);
  input3DBox = transformBox(input3DBox, transform3);
}

void keyPressed() {
  if (key == CODED) {
    if (keyCode == UP) {
      float[][] transform1 = rotateXMatrix(0.1);
      input3DBox = transformBox(input3DBox, transform1);
    } else if (keyCode == DOWN) {
      float[][] transform1 = rotateXMatrix(-0.1);
      input3DBox = transformBox(input3DBox, transform1);
    }
    
    if (keyCode == LEFT) {
      float[][] transform1 = rotateYMatrix(0.1);
      input3DBox = transformBox(input3DBox, transform1);
    } else if (keyCode == RIGHT) {
      float[][] transform1 = rotateYMatrix(-0.1);
      input3DBox = transformBox(input3DBox, transform1);
    }
  }
}

class My2DPoint {
  float x;
  float y;
  My2DPoint(float x, float y) {
    this.x = x;
    this.y = y;
  }
}

class My3DPoint {
  float x;
  float y;
  float z;
  My3DPoint(float x, float y, float z) {
    this.x = x;
    this.y = y;
    this.z = z;
  }
}

My2DPoint projectPoint(My3DPoint eye, My3DPoint p) {
  float xP = (p.x - eye.x)/(1-p.z/eye.z);
  float yP = (p.y - eye.y)/(1-p.z/eye.z); 
  return new My2DPoint(xP, yP);
}

class My2DBox {
  My2DPoint[] s;
  My2DBox(My2DPoint[] s) {
    this.s = s;
  }
  void render() {
    strokeWeight(2);
    stroke(0, 0, 255);
    line(s[0].x, s[0].y, s[4].x, s[4].y);   
    line(s[2].x, s[2].y, s[6].x, s[6].y); 
    line(s[5].x, s[5].y, s[1].x, s[1].y); 
    line(s[7].x, s[7].y, s[3].x, s[3].y);

    stroke(0, 255, 0);
    line(s[5].x, s[5].y, s[6].x, s[6].y); 
    line(s[5].x, s[5].y, s[4].x, s[4].y);
    line(s[7].x, s[7].y, s[4].x, s[4].y); 
    line(s[7].x, s[7].y, s[6].x, s[6].y);

    stroke(255, 0, 0);
    line(s[0].x, s[0].y, s[1].x, s[1].y); 
    line(s[0].x, s[0].y, s[3].x, s[3].y);
    line(s[2].x, s[2].y, s[1].x, s[1].y); 
    line(s[2].x, s[2].y, s[3].x, s[3].y);
  }
}

class My3DBox {
  My3DPoint[] p;
  My3DBox(My3DPoint origin, float dimX, float dimY, float dimZ) {
    float x = origin.x;
    float y = origin.y;
    float z = origin.z;
    this.p = new My3DPoint[]{new My3DPoint(x, y+dimY, z+dimZ), 
      new My3DPoint(x, y, z+dimZ), 
      new My3DPoint(x+dimX, y, z+dimZ), 
      new My3DPoint(x+dimX, y+dimY, z+dimZ), 
      new My3DPoint(x, y+dimY, z), 
      origin, 
      new My3DPoint(x+dimX, y, z), 
      new My3DPoint(x+dimX, y+dimY, z)
    };
  }
  My3DBox(My3DPoint[] p) {
    this.p = p;
  }
}

My2DBox projectBox (My3DPoint eye, My3DBox box) {
  My2DPoint[] s = new My2DPoint[box.p.length];
  for (int i = 0; i< box.p.length; ++i) {
    s[i] = projectPoint(eye, box.p[i]);
  }
  return new My2DBox(s);
}

float[] homogeneous3DPoint (My3DPoint p) {
  float[] result = {p.x, p.y, p.z, 1};
  return result;
}

float[][] rotateXMatrix(float angle) {
  return(new float[][] {{1, 0, 0, 0}, 
    {0, cos(angle), sin(angle), 0}, 
    {0, -sin(angle), cos(angle), 0}, 
    {0, 0, 0, 1}});
}
float[][] rotateYMatrix(float angle) {
  return(new float[][] {{cos(angle), 0, -sin(angle), 0}, 
    {0, 1, 0, 0}, 
    {sin(angle), 0, cos(angle), 0}, 
    {0, 0, 0, 1}});
}

float[][] rotateZMatrix(float angle) {
  return(new float[][] {{cos(angle), sin(angle), 0, 0}, 
    {-sin(angle), cos(angle), 0, 0}, 
    {0, 0, 1, 0}, 
    {0, 0, 0, 1}});
}
float[][] scaleMatrix(float x, float y, float z) {
  return(new float[][] {{x, 0, 0, 0}, 
    {0, y, 0, 0}, 
    {0, 0, z, 0}, 
    {0, 0, 0, 1}});
}
float[][] translationMatrix(float x, float y, float z) {
  return(new float[][] {{1, 0, 0, x}, 
    {0, 1, 0, y}, 
    {0, 0, 1, z}, 
    {0, 0, 0, 1}});
}

float[] matrixProduct(float[][] a, float[] b) {
  float[] p = new float[4];
  for (int i=0; i<4; ++i) {
    int sum =0;
    for (int j=0; j<4; ++j) {
      sum += a[i][j]*b[j];
    }
    p[i] = sum;
  }
  return p;
}

My3DPoint euclidian3DPoint (float[] a) {
  My3DPoint result = new My3DPoint(a[0]/a[3], a[1]/a[3], a[2]/a[3]);
  return result;
}

My3DBox transformBox(My3DBox box, float[][] transformMatrix) {
  My3DPoint[] prod = new My3DPoint[box.p.length];

  for (int i=0; i<box.p.length; ++i) {
    prod[i] = euclidian3DPoint(matrixProduct(transformMatrix, homogeneous3DPoint(box.p[i])));
  }

  return new My3DBox(prod);
}