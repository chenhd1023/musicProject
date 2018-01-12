class MenuButton {
  int y ;
  String name;
  MenuButton(int y, String name) {
    this.y=y;
    this.name=name;
  }
  void display() {
    fill(255);
    rectMode(CORNER);
    rect(width/2-60, y-20, 120, 40);
    fill(0);
    textAlign(CENTER);
    textFont(createFont("OpenSansRegular.ttf", 30));
    text(name, width/2, y+10);
  }
  boolean checkOnclick() {
    if (mouseX>width/2-60 && mouseX<width/2+60 && mouseY>y-20 && mouseY<y+20) {
      return true;
    } else {
      return false;
    }
  }
}