class HitResultText {
  int x;
  int y;
  int textColor;
  int lifeTime=0;
  boolean show=false;
  String status;
  int score;
  HitResultText(int x, int y, int textColor) {
    this.x=x;
    this.y=y;
    this.textColor=textColor;
  }
  void setter(boolean show, String status) {
    this.show=show;
    this.status=status;
    lifeTime=0;
  }
  void display() {
    if (show) {
      fill(textColor);
      textAlign(CENTER);
      textFont(createFont("OpenSansRegular.ttf", 20));
      text(status, x, y);
      lifeTime++;
      if (lifeTime==30) {
        lifeTime=0;
        show=false;
      }
    }
  }
}