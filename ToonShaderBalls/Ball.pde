// Fabián Alfonso Beirutti Pérez
// 2021 - CIU

class Ball{
  
  PVector location;
  PVector speed;
  
  Ball(){
    reset();
  }
  
  void update(){
    pushMatrix();
    translate(location.x, location.y);
    int c = cp5.get(ColorWheel.class, "Ball #1").getRGB();
    noStroke();
    fill(c);
    sphere(width*0.02);
    popMatrix();
    location.add(speed);
    checkBounds();
  }
  
  void checkBounds(){
    if (location.x < 0 || location.x > width){
      speed.x *= -1.0;
    }
    if (location.y < 0 || location.y > height){
      speed.y *= -1.0;
    }
  }
  
  void reset(){
    location = new PVector(random(width), random(height));
    speed = new PVector(random(-1.0, 1.0), random(-1.0, 1.0));
    speed.normalize();
    speed.mult(3);
  }
}
