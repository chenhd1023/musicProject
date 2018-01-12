class PressedHit {
  int startTime ;
  int endTime ;
  int type ;
  boolean alive =true;
  int hitStartTime;
  int hitEndTime;
  float angle = random(-PI, PI);
  PressedHit( int startTime, int endTime, int type) {
    this.startTime = startTime; 
    this.endTime = endTime; 
    this.type = type;
  }
  void display() {
    pushMatrix();
    switch (type) {
    case 4:
      translate(width/4, height/4);
      break;
    case 5:
      translate(width/4*3, height/4);
      break;
    case 6:
      translate(width/4, height/4*3);
      break;
    case 7:
      translate(width/4*3, height/4*3);
      break;
    }
    rotate(angle); 
    fill(#00ffff);
    if ((startTime-60)<=frameNum && endTime>=frameNum) {
      for (int i=startTime; i<endTime; i++) {
        if ((2*(i-frameNum))<=125 && (i-frameNum)>0) {
          ellipse(2*(i-frameNum), 0, 30, 30);
        }
      }
    }
    popMatrix();
  }
}