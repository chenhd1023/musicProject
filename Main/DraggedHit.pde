class DraggedHit {
  int time ;
  int type ;
  boolean alive =true;
  DraggedHit(int time, int type) {
    this.time = time; 
    this.type = type;
  }
  void display() {
    if ((time-60)<frameNum && (time+60)>=frameNum) {
      fill(#99c2ff);
      //if(frameNum>=time)  fill(#0066ff);
      float m;
      switch (type) {
      case 8:
        m = map(frameNum, (time-60), (time+60), width/8, width/8*5);
        ellipse(m, height/2, 40, 40);
        break;
      case 9:
        m = map(frameNum, (time-60), (time+60), width/8*7, width/8*3);
        ellipse(m, height/2, 40, 40);
        break;
      case 10:
        m = map(frameNum, (time-60), (time+60), height/8, height/8*5);
        ellipse(width/2, m, 40, 40);
        break;
      case 11:
        m = map(frameNum, (time-60), (time+60), height/8*7, height/8*3);
        ellipse(width/2, m, 40, 40);
        break;
      }
    }
  }
}