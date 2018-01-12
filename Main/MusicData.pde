class MusicData {
  PImage cover;
  //Minim minim;
  AudioPlayer groove;
  String songName;
  Table basicTable;
  Table advanceTable;
  ArrayList<BasicHit> basicHitList = new ArrayList<BasicHit>();
  ArrayList<PressedHit> pressedHitList = new ArrayList<PressedHit>();
  ArrayList<DraggedHit> draggedHitList = new ArrayList<DraggedHit>();
  MusicData(String songName) {
    this.songName = songName;
    //minim = new Minim(this);
    groove = minim.loadFile("data/"+songName+"/music.mp3");
    cover=loadImage("data/"+songName+"/cover.png");
    load();
  }
  void load() {
    basicTable = loadTable("data/"+songName+"/basic.csv", "header");
    for (TableRow row : basicTable.rows()) {
      int time = row.getInt("time");
      int type = row.getInt("type");
      basicHitList.add(new BasicHit(time, type));
    }
    advanceTable = loadTable("data/"+songName+"/advance.csv", "header");
    for (TableRow row : advanceTable.rows()) {
      int startTime = row.getInt("startTime");
      int endTime = row.getInt("endTime");
      int type = row.getInt("type");
      if (type>3 && type<8) {
        pressedHitList.add(new PressedHit(startTime, endTime, type));
      } else {
        draggedHitList.add(new DraggedHit(startTime, type));
      }
    }
  }
}