class PressedHit {
  int startTime ;
  int endTime ;
  int type ;
  //float angle = random(-PI, PI);
  PressedHit( int startTime, int endTime, int type) {
    this.startTime = startTime; 
    this.endTime = endTime; 
    this.type = type;
  }
 
}