class BasicHit {
  int time ;
  int type ;
  float angle = random(-PI, PI);
  boolean alive =true;
  int dieTime=0;
  BasicHit( int time, int type) {
    this.time = time; 
    this.type = type;
  }
  void display() {
    if (alive &&(time-60)<frameNum && (time)>=frameNum ) {
      pushMatrix();
      switch (type) {
      case 0:
        translate(width/4, height/4);
        break;
      case 1:
        translate(width/4*3, height/4);
        break;
      case 2:
        translate(width/4, height/4*3);
        break;
      case 3:
        translate(width/4*3, height/4*3);
        break;
      }
      rotate(angle); 
      fill(#ff00ff);
      ellipse(2*(time-frameNum), 0, 30, 30);
      popMatrix();
    }
  }
} 