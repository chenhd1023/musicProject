class DraggablePoint {
  int x;
  int y;
  int dragStartTime;
  int dragEndTime;
  int type;
  DraggablePoint(int x, int y,int type,int dragStartTime) {
    this.x=x;
    this.y=y;
    this.type=type;
    this.dragStartTime=dragStartTime;
  }
  void display() {
    fill(#0066ff);
    switch (type) {
    case 8:
    case 9:
      if (mouseX<width/8*3) {
        x=width/8*3;
      } else if (mouseX>width/8*5) {
        x=width/8*5;
      } else {
        x=mouseX;
      }
      ellipse(x, height/2, 40, 40);
      break;
    case 10:
    case 11:
      if (mouseY<height/8*3) {
        y=height/8*3;
      } else if (mouseY>height/8*5) {
        y=height/8*5;
      } else {
        y=mouseY;
      }
      ellipse(width/2, y, 40, 40);
      break;
    }
  }
}