import ddf.minim.*;
Minim minim;
AudioPlayer groove;
int buttomNum;
float position;
boolean[][] hitPoint ;
PImage space;
color turnOnColor = #F0F5FB ;
color turnOffColor = #022547 ;
Table table1;
Table table2;
int moveSpeed=1;
void setup() {
  size(1024, 240, P2D);
  space = loadImage("white.png");
  minim = new Minim(this);
  //change your music file here
  groove = minim.loadFile("data/music.mp3");
  buttomNum=groove.length()/20;
  hitPoint=new boolean[buttomNum][12];
}

void draw() {
  if (mouseY > height-25 && mouseY < height && mouseX < 100 && mouseX > 0) {
    if (mousePressed) {
      println("saveStart");
      save();
      println("saveEnd");
    }
  } else if (mouseY > 0 && mouseY < 25 && mouseX < 100 && mouseX > 0) {
    if (mousePressed) {
      load();
      println("load");
    }
  } else if (mouseY > (height-25)/2 && mouseY < (height-25)/2+25 && mouseX < 100 && mouseX > 0) {
    if (mousePressed) {
      println("reloadStart");
      reload();
      println("reloadEnd");
    }
  }
  position =  groove.position()/2;
  background(0);
  stroke( 0 );
  //rect(25, 25, 100, 100);
  pushMatrix();
  translate(-position, 0);
  for (int i = 0; i < buttomNum; i++) {
    for (int j = 0; j < 12; j++) {
      color statusColor = (hitPoint[i][j]) ? turnOnColor : turnOffColor ;
      fill(statusColor) ;
      rect(i*10+100, j*20, 10, 20);
    }
  }
  stroke( 255, 0, 0 );
  line( position+100, 0, position+100, height );
  popMatrix();
  //println(groove.length());
  //text("Click anywhere to jump to a position in the song.", 10, 20);

  //fill(255) ;
  //noStroke(); 
  //rect(0, 0, 100, height);
  image(space, 0, 0, 100, 240);
  fill(0) ;
  noStroke();
  rect(0, height-25, 100, 25);
  rect(0, 0, 100, 25);
  rect(0, (height-25)/2, 100, 25);
  fill(255);
  text("save", 30, 230);
  text("reload", 30, 125);
  text("load", 30, 20);
}

void keyPressed() {
  if (key==CODED) {
    //int positionInt=(int)position;
    switch(keyCode) {
    case LEFT:  
      position=-moveSpeed*1000+position*2;
      groove.cue((int)position);
      break;
    case RIGHT:
      position=moveSpeed*1000+position*2;
      groove.cue((int)position);
      break;
    }
  } else if (key==32) {//space
    if ( groove.isPlaying() ) {
      groove.pause();
    } else {
      // simply call loop again to resume playing from where it was paused
      groove.loop();
    }
  } else if (key == 'a') {
    int col = ((int)position)*2/20;
    int row = 0;
    changelight(col, row);
  } else if (key == 's') {
    int col = ((int)position)*2/20;
    int row = 1;
    changelight(col, row);
  } else if (key == 'd') {
    int col = ((int)position)*2/20;
    int row = 2;
    changelight(col, row);
  } else if (key == 'f') {
    int col = ((int)position)*2/20;
    int row = 3;
    changelight(col, row);
  }
}


void mousePressed() {
  if (mouseX>100) {
    int col = int((position+mouseX-100) / 10);
    int row = int(mouseY / 20);
    changelight(col, row);
  }
}

void changelight( int col, int row) {
  //middle
  if (hitPoint[col][row] == false) {
    hitPoint[col][row]=true;//change color
  } else {
    hitPoint[col][row]=false;
  }
}



void save() {
  table1 = new Table();
  table1.addColumn("time");
  table1.addColumn("type");
  for (int i = 0; i < buttomNum; i++) {
    for (int j = 0; j < 4; j++) {
      if (hitPoint[i][j] ) {
        TableRow newRow = table1.addRow();
        //newRow.setInt("id", table1.getRowCount() - 1);
        newRow.setString("time", i+"");
        newRow.setString("type", j+"");
      }
    }
  }
  saveTable(table1, "data/basic.csv");
  //table2
  table2 = new Table();
  table2.addColumn("startTime");
  table2.addColumn("endTime");
  table2.addColumn("type");
  for (int j = 4; j < 12; j++) {
    for (int i = 0; i < buttomNum; i++) {
      if (hitPoint[i][j] ) {
        int iTmp=i;
        while (hitPoint[iTmp][j]) {
          iTmp++;
        }
        TableRow newRow = table2.addRow();
        newRow.setString("startTime", i+"");
        newRow.setString("endTime", iTmp+"");
        newRow.setString("type", j+"");
        i=iTmp;
      }
    }
  }
  saveTable(table2, "data/advance.csv");
}
void load() {
  hitPoint=new boolean[buttomNum][12];
  table1 = loadTable("data/basic.csv", "header");
  //println(table1.getRowCount() + " total rows in table"); 
  for (TableRow row : table1.rows()) {
    int time = row.getInt("time");
    int type = row.getInt("type");
    //String name = row.getString("name");
    //println(name + " (" + species + ") has an ID of " + id);
    hitPoint[time][type] =true;
  }
  table2 = loadTable("data/advance.csv", "header");
  //println(table1.getRowCount() + " total rows in table"); 
  for (TableRow row : table2.rows()) {
    int startTime = row.getInt("startTime");
    int endTime = row.getInt("endTime");
    int type = row.getInt("type");
    //String name = row.getString("name");
    //println(name + " (" + species + ") has an ID of " + id);
    for (int i=startTime; i<endTime; i++) {
      hitPoint[i][type] =true;
    }
  }
}


void reload() {
  hitPoint=new boolean[buttomNum][12];
  table1 = loadTable("data/basic.csv", "header");
  //println(table1.getRowCount() + " total rows in table"); 
  for (TableRow row : table1.rows()) {
    int time = row.getInt("time");
    int type = row.getInt("type");
    //String name = row.getString("name");
    //println(name + " (" + species + ") has an ID of " + id);
    hitPoint[time][type] =true;
  }
  table2 = loadTable("data/advance.csv", "header");
  ArrayList<PressedHit> pressedHitList = new ArrayList<PressedHit>();
  for (TableRow row : table2.rows()) {
    int startTime = row.getInt("startTime");
    int endTime = row.getInt("endTime");
    int type = row.getInt("type");
    PressedHit pressedHit = new PressedHit(startTime, endTime, type);
    //pressedHitList.add(new PressedHit(startTime, endTime, type));
    boolean firstTime = true; 
    for (PressedHit p : pressedHitList) {
      if (pressedHit.endTime == p.endTime && pressedHit.type == p.type) {
        firstTime=false;
      }
    }
    if (firstTime) {
      pressedHitList.add(pressedHit);
      for (int i=startTime; i<endTime; i++) {
        hitPoint[i][type] =true;
      }
    }
    //String name = row.getString("name");
    //println(name + " (" + species + ") has an ID of " + id);
  }
}