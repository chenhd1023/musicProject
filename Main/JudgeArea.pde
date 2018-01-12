class JudgeArea {
  int x, y;
  JudgeArea(int x, int y) {
    this.x=x;
    this.y=y;
  }
  void drawJudgeArea() {
    stroke(#000000);
    fill(#ffffff);
    ellipse(x, y, 250, 250);
    noStroke();
    //fill(#0000ff);
    //ellipse(x, y, 45, 45);
    fill(#ffff00);
    ellipse(x, y, 30, 30);
    //fill(#ff0000);
    //ellipse(x, y, 15, 15);
  }
}