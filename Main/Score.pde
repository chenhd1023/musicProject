class Score implements Comparable<Score> {
  int type;
  int score;
  String name;
  Score(int type, int score, String name) {
    this.type=type;
    this.score=score;
    this.name=name;
  }

  @Override
    int compareTo(Score comparestu) {
    int comparescore=((Score)comparestu).score;
    /* For Descending order*/
    return -this.score+comparescore;

    /* For Descending order do like this */
    //return compareage-this.studentage;
  }
  @Override
    public String toString() {
    return "";
  }
}