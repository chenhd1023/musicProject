import ddf.minim.*;
Minim minim;
final int GAME_START = 0, GAME_RUN = 1, GAME_OVER = 2, GAME_WIN = 3, GAME_CHOOSE = 4, GAME_SETTING = 5, GAME_RANK = 8, GAME_FINISH = 6, GAME_RANK_CHOOSE=7;
PImage bg;
int gameState = 0;
int songChoose = -1;
MenuButton[] menuButtonArray = new MenuButton[4];
JudgeArea[] judgeAreas=new JudgeArea[4];
boolean[][] hitPoint ;
int frameNum=0;
MusicData[] musicDatas =new MusicData[3];
HitResultText[] hitResultTexts = new HitResultText[5];
DraggablePoint draggablePoint;
int score=0;
String name="";
Rank rank;
char[] keyboard={'q', 'w', 'i', 'u', 'z', 'x', 'm', 'n'};
int keyboardSetting=-1;
void setup() {
  size(800, 600, P2D);
  menuButtonArray[0]=new MenuButton(height/5, "start");
  menuButtonArray[1]=new MenuButton(height/5*2, "setting");
  menuButtonArray[2]=new MenuButton(height/5*3, "rank");
  menuButtonArray[3]=new MenuButton(height/5*4, "end");
  judgeAreas[0]=new JudgeArea(width/4, height/4);
  judgeAreas[1]=new JudgeArea(width/4*3, height/4);
  judgeAreas[2]=new JudgeArea(width/4, height/4*3);
  judgeAreas[3]=new JudgeArea(width/4*3, height/4*3);
  minim = new Minim(this);
  musicDatas[0]=new MusicData("Lightly_Row");
  musicDatas[1]=new MusicData("Unreachable_Love");
  musicDatas[2]=new MusicData("Thats_What_I_Like");
  hitResultTexts[0] = new HitResultText(width/16, height/16, 255);
  hitResultTexts[1] = new HitResultText(width/16*15, height/16, 255);
  hitResultTexts[2] = new HitResultText(width/16, height/16*15, 255);
  hitResultTexts[3] = new HitResultText(width/16*15, height/16*15, 255);
  hitResultTexts[4] = new HitResultText(width/2, height/2, 0);
  rank=new Rank();
  bg = loadImage("background.jpeg");
}

void draw() {
  background(0);
  switch (gameState) {
  case GAME_START:
    background(bg);
    fill(0);
    rectMode(CORNER);
    rect(width-300, height-50, 300, 50);
    for (MenuButton button : menuButtonArray) {
      button.display();
    }
    break;
  case GAME_CHOOSE:
    for (int i = 0; i<musicDatas.length; i++) {
      int xLocation = 50+i*250;
      image(musicDatas[i].cover, xLocation, 150, 200, 200);
      fill(255);
      textAlign(CENTER);
      textFont(createFont("OpenSansRegular.ttf", 20));
      text(musicDatas[i].songName, xLocation+100, 405);
    }
    break;
  case GAME_RANK_CHOOSE:
    for (int i = 0; i<musicDatas.length; i++) {
      int xLocation = 50+i*250;
      image(musicDatas[i].cover, xLocation, 150, 200, 200);
      fill(255);
      textAlign(CENTER);
      textFont(createFont("OpenSansRegular.ttf", 20));
      text(musicDatas[i].songName, xLocation+100, 405);
    }
    break;
  case GAME_RUN:
    if (frameNum==0) {
      musicDatas[songChoose].groove.play(0);
      name="";
      score=0;
    }
    frameNum++;
    fill(#f2f2f2);
    rect(width/8, 280, width/8*6, 40, 20, 20, 20, 20);
    rect(380, height/8, 40, height/8*6, 20, 20, 20, 20);
    fill(#ffffb3);
    ellipse(width/8*3, height/2, 40, 40);
    ellipse(width/8*5, height/2, 40, 40);
    ellipse(width/2, height/8*3, 40, 40);
    ellipse(width/2, height/8*5, 40, 40);
    for (int i=0; i<judgeAreas.length; i++) {
      judgeAreas[i].drawJudgeArea();
    }
    for (BasicHit basicHit : musicDatas[songChoose].basicHitList) {
      if (basicHit.alive && frameNum>basicHit.time) {
        hitResultTexts[basicHit.type].setter(true, "MISS");
        score=score-20;
        basicHit.alive=false;
      }
      basicHit.display();
    }
    for (PressedHit pressedHit : musicDatas[songChoose].pressedHitList) {
      if (pressedHit.alive && frameNum>pressedHit.endTime) {
        hitResultTexts[pressedHit.type-4].setter(true, "MISS");
        score=score-20;
        pressedHit.alive=false;
      }
      pressedHit.display();
    }
    for (DraggedHit draggedHit : musicDatas[songChoose].draggedHitList) {
      if (draggedHit.alive && frameNum>draggedHit.time) {
        hitResultTexts[4].setter(true, "MISS");
        score=score-20;
        draggedHit.alive=false;
      }
      draggedHit.display();
    }
    for (HitResultText hitResultText : hitResultTexts) {
      hitResultText.display();
    }
    if (draggablePoint != null) {
      draggablePoint.display();
    }
    fill(255);
    textAlign(CENTER);
    textFont(createFont("OpenSansRegular.ttf", 40));
    text("SCORE:"+score, width/2, 40);
    if (((float)musicDatas[songChoose].groove.position()/(float)musicDatas[songChoose].groove.length())>0.99) {
      gameState=GAME_FINISH;
    }
    break;
  case GAME_FINISH:
    fill(255);
    textAlign(CENTER);
    textFont(createFont("OpenSansRegular.ttf", 40));
    text("TOTAl SCORE:"+score, width/2, 50);
    text("YOUR RANK :"+rank.rank(songChoose, score), width/2, 150);
    text("PLEASE ENTER YOUR NAME:", width/2, 250);
    if (name=="") {
      text("____", width/2, 350);
    } else {
      text(name, width/2, 350);
    }
    fill(255);
    rect(100, 400, 200, 60);
    rect(100, 500, 200, 60);
    rect(500, 400, 200, 60);
    rect(500, 500, 200, 60);
    fill(0);
    text("TRY AGAIN", width/4, 450);
    text("CHANGE", width/4, 550);
    text("RANK", width/4*3, 450);
    text("END", width/4*3, 550);
    break;
  case GAME_RANK:
    fill(255);
    textAlign(CENTER);
    textFont(createFont("OpenSansRegular.ttf", 40));
    text(musicDatas[songChoose].songName, width/2, 50);
    ArrayList<Score> tmp = new ArrayList<Score>();
    if (songChoose==0) {
      tmp=rank.rankList0;
    } else if (songChoose==1) {
      tmp=rank.rankList1;
    } else if (songChoose==0) {
      tmp=rank.rankList2;
    }
    int max=tmp.size();
    if (max>5) max=5;
    for (int i = 0; i<max; i++) {
      text(i+1, width/8, 100+i*100);
      text(tmp.get(i).name, width/16*7, 100+i*100);
      text(tmp.get(i).score, width/4*3, 100+i*100);
    }
    rect(300, 520, 200, 60);
    fill(0);
    text("MAIN", 400, 570);
    break;
  case GAME_SETTING:
    fill(255);
    for (int i=0; i<4; i++) {
      rect(50, 60+140*i, 300, 60);
      rect(450, 60+140*i, 300, 60);
    }
    rect(300, 520, 200, 60);
    fill(0);
    text("LeftTop Single:"+keyboard[0], 200, 100);
    text("LeftTop Combo:"+keyboard[1], 200, 240);
    text("RightTop Single:"+keyboard[2], 600, 100);
    text("RightTop Combo:"+keyboard[3], 600, 240);
    text("LeftDown Single:"+keyboard[4], 200, 380);
    text("LeftDown Combo:"+keyboard[5], 200, 520);
    text("RightDown Single:"+keyboard[6], 600, 380);
    text("RightDown Combo:"+keyboard[7], 600, 520);
    text("MAIN", 400, 570);
    break;
  }
}

void mousePressed() {
  switch (gameState) {
  case GAME_START:
    if (menuButtonArray[0].checkOnclick()) {
      gameState=GAME_CHOOSE;
    } else  if (menuButtonArray[1].checkOnclick()) {
      gameState=GAME_SETTING;
    } else  if (menuButtonArray[2].checkOnclick()) {
      gameState=GAME_RANK_CHOOSE;
    } else  if (menuButtonArray[3].checkOnclick()) {
      exit();
    }
    break;
  case GAME_CHOOSE:
    if (mouseY>=150 && mouseY<=350) {
      if (mouseX>=50 && mouseX<=250) {
        musicDatas[0].groove.pause();
        musicDatas[1].groove.pause();
        musicDatas[2].groove.pause();
        songChoose=0;
        gameState=GAME_RUN;
      } else  if (mouseX>=300 && mouseX<=500) {
        musicDatas[0].groove.pause();
        musicDatas[1].groove.pause();
        musicDatas[2].groove.pause();
        songChoose=1;
        gameState=GAME_RUN;
      } else  if (mouseX>=550 && mouseX<=750) {
        musicDatas[0].groove.pause();
        musicDatas[1].groove.pause();
        musicDatas[2].groove.pause();
        songChoose=2;
        gameState=GAME_RUN;
      }
    }
    break;
  case GAME_RANK_CHOOSE:
    if (mouseY>=150 && mouseY<=350) {
      if (mouseX>=50 && mouseX<=250) {
        musicDatas[0].groove.pause();
        musicDatas[1].groove.pause();
        musicDatas[2].groove.pause();
        songChoose=0;
        gameState=GAME_RANK;
      } else  if (mouseX>=300 && mouseX<=500) {
        musicDatas[0].groove.pause();
        musicDatas[1].groove.pause();
        musicDatas[2].groove.pause();
        songChoose=1;
        gameState=GAME_RANK;
      } else  if (mouseX>=550 && mouseX<=750) {
        musicDatas[0].groove.pause();
        musicDatas[1].groove.pause();
        musicDatas[2].groove.pause();
        songChoose=2;
        gameState=GAME_RANK;
      }
    }
    break;
  case GAME_RUN:
    if (dist(mouseX, mouseY, width/8*3, height/2)<=20) {
      draggablePoint=new DraggablePoint(mouseX, mouseY, 8, frameNum);
    } else if (dist(mouseX, mouseY, width/8*5, height/2)<=20) {
      draggablePoint=new DraggablePoint(mouseX, mouseY, 9, frameNum);
    } else if (dist(mouseX, mouseY, width/2, height/8*3)<=20) {
      draggablePoint=new DraggablePoint(mouseX, mouseY, 10, frameNum);
    } else if (dist(mouseX, mouseY, width/2, height/8*5)<=20) {
      draggablePoint=new DraggablePoint(mouseX, mouseY, 11, frameNum);
    }
    break;
  case GAME_FINISH:
    if (mouseY>=400 && mouseY<=460 && mouseX>=100 && mouseX<=300) {
      rank.save(songChoose, name, score);
      frameNum=0;
      musicDatas[0].groove.play(0);
      gameState =GAME_RUN;
    } else if (mouseY>=400 && mouseY<=460 && mouseX>=500 && mouseX<=700) {
      rank.save(songChoose, name, score);
      frameNum=0;
      musicDatas[0].groove.play(0);
      musicDatas[1].groove.play(0);
      musicDatas[2].groove.play(0);
      gameState =GAME_RANK;
    } else if (mouseY>=500 && mouseY<=560 && mouseX>=100 && mouseX<=300) {
      rank.save(songChoose, name, score);
      frameNum=0;
      musicDatas[0].groove.play(0);
      musicDatas[1].groove.play(0);
      musicDatas[2].groove.play(0);
      gameState =GAME_CHOOSE;
    } else if (mouseY>=500 && mouseY<=560 && mouseX>=500 && mouseX<=700) {
      rank.save(songChoose, name, score);
      frameNum=0;
      musicDatas[0].groove.play(0);
      musicDatas[1].groove.play(0);
      musicDatas[2].groove.play(0);
      exit();
    }
    break;
  case GAME_RANK:
    if (mouseY>=520 && mouseY<=580 && mouseX>=300 && mouseX<=500) {
      gameState =GAME_START;
    }
    break;
  case GAME_SETTING:
   if (mouseY>=520 && mouseY<=580 && mouseX>=300 && mouseX<=500) {
      gameState =GAME_START;
    }
    if (mouseX>=50 && mouseX<=350) {
      if (mouseY>=60 && mouseY<=120) {
        keyboardSetting=0;
      } else if (mouseY>=200 && mouseY<=260) {
        keyboardSetting=1;
      } else if (mouseY>=340 && mouseY<=400) {
        keyboardSetting=4;
      } else if (mouseY>=480 && mouseY<=540) {
        keyboardSetting=5;
      }
    } else if (mouseX>=450 && mouseX<=750) {
      if (mouseY>=60 && mouseY<=120) {
        keyboardSetting=2;
      } else if (mouseY>=200 && mouseY<=260) {
        keyboardSetting=3;
      } else if (mouseY>=340 && mouseY<=400) {
        keyboardSetting=6;
      } else if (mouseY>=480 && mouseY<=540) {
        keyboardSetting=7;
      }
    }
    break;
  }
}

void mouseReleased() {
  switch (gameState) {
  case GAME_RUN:
    if (draggablePoint!=null) {
      for (DraggedHit draggedHit : musicDatas[songChoose].draggedHitList) {
        if (draggedHit.alive && draggablePoint.dragStartTime>0) {
          float accuracy=1-((float)(abs(draggablePoint.dragStartTime-draggedHit.time)+abs(draggablePoint.dragStartTime+60-frameNum))/4)/((float)(60));
          //pressedHit.hitStartTime=frameNum;
          if (accuracy >0.75) {
            draggedHit.alive=false;
            hitResultTexts[4].setter(true, "PERFECT");
            score=score+50;
            break;
          } else  if (accuracy >0.5) {
            draggedHit.alive=false;
            hitResultTexts[4].setter(true, "GREAT");
            score=score+30;
            break;
          } else if (accuracy >0) {
            draggedHit.alive=false;
            hitResultTexts[4].setter(true, "GOOD");
            score=score+20;
            break;
          } else {
            draggedHit.alive=false;
            hitResultTexts[4].setter(true, "MISS");
            score=score-20;
            break;
          }
        }
      }
      draggablePoint=null;
      break;
    }
  }
}

void mouseMoved() {
  switch (gameState) {
  case GAME_CHOOSE:
  case GAME_RANK_CHOOSE:
    if (mouseY>=150 && mouseY<=350) {
      if (mouseX>=50 && mouseX<=250) {
        musicDatas[0].groove.play();
        musicDatas[1].groove.pause();
        musicDatas[2].groove.pause();
      } else  if (mouseX>=300 && mouseX<=500) {
        musicDatas[0].groove.pause();
        musicDatas[1].groove.play();
        musicDatas[2].groove.pause();
      } else  if (mouseX>=550 && mouseX<=750) {
        musicDatas[0].groove.pause();
        musicDatas[1].groove.pause();
        musicDatas[2].groove.play();
      } else {
        musicDatas[0].groove.pause();
        musicDatas[1].groove.pause();
        musicDatas[2].groove.pause();
      }
    } else {
      musicDatas[0].groove.pause();
      musicDatas[1].groove.pause();
      musicDatas[2].groove.pause();
    }
    break;
  }
}

void keyPressed() {
  switch (gameState) {
  case GAME_RUN:
    if (key == keyboard[0]) {
      boolean hasHit=false;
      for (BasicHit basicHit : musicDatas[songChoose].basicHitList) {
        if (basicHit.type==0) {
          int resultTime = 2*(basicHit.time-frameNum);
          if (30>resultTime && resultTime>=20) {
            basicHit.alive=false;
            hitResultTexts[0].setter(true, "GOOD");
            score=score+20;
            hasHit=true;
            break;
          } else if (20>resultTime && resultTime>=10) {
            basicHit.alive=false;
            hitResultTexts[0].setter(true, "GREAT");
            score=score+30;
            hasHit=true;
            break;
          } else if (10>resultTime && resultTime>=0) {
            basicHit.alive=false;
            hitResultTexts[0].setter(true, "PERFECT");
            score=score+50;
            hasHit=true;
            break;
          }
        }
      }
      if (!hasHit) {
        hitResultTexts[0].setter(true, "MISS");
        score=score-20;
      }
    } else  if (key == keyboard[2]) {
      boolean hasHit=false;
      for (BasicHit basicHit : musicDatas[songChoose].basicHitList) {
        if (basicHit.type==1) {
          int resultTime = 2*(basicHit.time-frameNum);
          if (30>resultTime && resultTime>=20) {
            basicHit.alive=false;
            hitResultTexts[1].setter(true, "GOOD");
            score=score+20;
            hasHit=true;
            break;
          } else if (20>resultTime && resultTime>=10) {
            basicHit.alive=false;
            hitResultTexts[1].setter(true, "GREAT");
            score=score+30;
            hasHit=true;
            break;
          } else if (10>resultTime && resultTime>=0) {
            basicHit.alive=false;
            hitResultTexts[1].setter(true, "PERFECT");
            score=score+50;
            hasHit=true;
            break;
          }
        }
      }
      if (!hasHit) {
        hitResultTexts[1].setter(true, "MISS");
        score=score-20;
      }
    } else  if (key == keyboard[4]) {
      boolean hasHit=false;
      for (BasicHit basicHit : musicDatas[songChoose].basicHitList) {
        if (basicHit.type==2) {
          int resultTime = 2*(basicHit.time-frameNum);
          if (30>resultTime && resultTime>=20) {
            basicHit.alive=false;
            hitResultTexts[2].setter(true, "GOOD");
            score=score+20;
            hasHit=true;
            break;
          } else if (20>resultTime && resultTime>=10) {
            basicHit.alive=false;
            hitResultTexts[2].setter(true, "GREAT");
            score=score+30;
            hasHit=true;
            break;
          } else if (10>resultTime && resultTime>=0) {
            basicHit.alive=false;
            hitResultTexts[2].setter(true, "PERFECT");
            score=score+50;
            hasHit=true;
            break;
          }
        }
      }
      if (!hasHit) {
        hitResultTexts[2].setter(true, "MISS");
        score=score-20;
      }
    } else if (key == keyboard[6]) {
      boolean hasHit=false;
      for (BasicHit basicHit : musicDatas[songChoose].basicHitList) {
        if (basicHit.type==3) {
          int resultTime = 2*(basicHit.time-frameNum);
          if (30>resultTime && resultTime>=20) {
            basicHit.alive=false;
            hitResultTexts[3].setter(true, "GOOD");
            score=score+20;
            hasHit=true;
            break;
          } else if (20>resultTime && resultTime>=10) {
            basicHit.alive=false;
            hitResultTexts[3].setter(true, "GREAT");
            score=score+30;
            hasHit=true;
            break;
          } else if (10>resultTime && resultTime>=0) {
            basicHit.alive=false;
            hitResultTexts[3].setter(true, "PERFECT");
            score=score+50;
            hasHit=true;
            break;
          }
        }
      }
      if (!hasHit) {
        hitResultTexts[3].setter(true, "MISS");
        score=score-20;
      }
    } else if (key == keyboard[1]) {
      boolean hasHit=false;
      for (PressedHit pressedHit : musicDatas[songChoose].pressedHitList) {
        if (pressedHit.type==4) {
          int resultTime = 2*(pressedHit.startTime-frameNum);
          if (pressedHit.alive && 30>resultTime && pressedHit.endTime>frameNum) {
            pressedHit.hitStartTime=frameNum;
            hasHit=true;
            break;
          }
        }
      }
      if (!hasHit) {
        hitResultTexts[0].setter(true, "MISS");
        score=score-20;
      }
    } else if (key == keyboard[3]) {
      boolean hasHit=false;
      for (PressedHit pressedHit : musicDatas[songChoose].pressedHitList) {
        if (pressedHit.type==5) {
          int resultTime = 2*(pressedHit.startTime-frameNum);
          if (pressedHit.alive && 30>resultTime && pressedHit.endTime>frameNum) {
            pressedHit.hitStartTime=frameNum;
            hasHit=true;
            break;
          }
        }
      }
      if (!hasHit) {
        hitResultTexts[1].setter(true, "MISS");
        score=score-20;
      }
    } else if (key == keyboard[5]) {
      boolean hasHit=false;
      for (PressedHit pressedHit : musicDatas[songChoose].pressedHitList) {
        if (pressedHit.type==6) {
          int resultTime = 2*(pressedHit.startTime-frameNum);
          if (pressedHit.alive && 30>resultTime && pressedHit.endTime>frameNum) {
            pressedHit.hitStartTime=frameNum;
            hasHit=true;
            break;
          }
        }
      }
      if (!hasHit) {
        hitResultTexts[2].setter(true, "MISS");
        score=score-20;
      }
    } else if (key == keyboard[7]) {
      boolean hasHit=false;
      for (PressedHit pressedHit : musicDatas[songChoose].pressedHitList) {
        if (pressedHit.type==7) {
          int resultTime = 2*(pressedHit.startTime-frameNum);
          if (pressedHit.alive && 30>resultTime && pressedHit.endTime>frameNum) {
            pressedHit.hitStartTime=frameNum;
            hasHit=true;
            break;
          }
        }
      }
      if (!hasHit) {
        hitResultTexts[3].setter(true, "MISS");
        score=score-20;
      }
    }
    //quick end
    if (key == 'b') {
      gameState=GAME_FINISH;
    }
    break;
  case GAME_FINISH:
    name+=key;
    break;
  case GAME_SETTING:
    if (keyboardSetting != -1) {
      keyboard[keyboardSetting]=key;
    }
    break;
  }
}
void keyReleased() {
  switch (gameState) {
  case GAME_RUN:
    if (key == keyboard[1]) {
      for (PressedHit pressedHit : musicDatas[songChoose].pressedHitList) {
        if (pressedHit.type==4 && pressedHit.alive && pressedHit.hitStartTime>0) {
          float accuracy=1-((float)(abs(pressedHit.hitStartTime-pressedHit.startTime)+abs(pressedHit.hitEndTime-pressedHit.endTime))/4)/((float)(pressedHit.endTime-pressedHit.startTime+30));
          pressedHit.hitStartTime=frameNum;
          if (accuracy >0.75) {
            pressedHit.alive=false;
            hitResultTexts[0].setter(true, "PERFECT");
            score=score+50;
            break;
          } else  if (accuracy >0.5) {
            pressedHit.alive=false;
            hitResultTexts[0].setter(true, "GREAT");
            score=score+30;
            break;
          } else if (accuracy >0) {
            pressedHit.alive=false;
            hitResultTexts[0].setter(true, "GOOD");
            score=score+20;
            break;
          } else {
            pressedHit.alive=false;
            hitResultTexts[0].setter(true, "MISS");
            score=score-20;
            break;
          }
        }
      }
    } else if (key == keyboard[3]) {
      for (PressedHit pressedHit : musicDatas[songChoose].pressedHitList) {
        if (pressedHit.type==5 && pressedHit.alive && pressedHit.hitStartTime>0) {
          float accuracy=1-((float)(abs(pressedHit.hitStartTime-pressedHit.startTime)+abs(pressedHit.hitEndTime-pressedHit.endTime))/4)/((float)(pressedHit.endTime-pressedHit.startTime+30));
          pressedHit.hitStartTime=frameNum;
          if (accuracy >0.75) {
            pressedHit.alive=false;
            hitResultTexts[1].setter(true, "PERFECT");
            score=score+50;
            break;
          } else  if (accuracy >0.5) {
            pressedHit.alive=false;
            hitResultTexts[1].setter(true, "GREAT");
            score=score+30;
            break;
          } else if (accuracy >0) {
            pressedHit.alive=false;
            hitResultTexts[1].setter(true, "GOOD");
            score=score+20;
            break;
          } else {
            pressedHit.alive=false;
            hitResultTexts[1].setter(true, "MISS");
            score=score-20;
            println(accuracy);
            break;
          }
        }
      }
    } else if (key == keyboard[5]) {
      for (PressedHit pressedHit : musicDatas[songChoose].pressedHitList) {
        if (pressedHit.type==6 && pressedHit.alive && pressedHit.hitStartTime>0) {
          float accuracy=1-((float)(abs(pressedHit.hitStartTime-pressedHit.startTime)+abs(pressedHit.hitEndTime-pressedHit.endTime))/4)/((float)(pressedHit.endTime-pressedHit.startTime+30));
          pressedHit.hitStartTime=frameNum;
          if (accuracy >0.75) {
            pressedHit.alive=false;
            hitResultTexts[2].setter(true, "PERFECT");
            score=score+50;
            break;
          } else  if (accuracy >0.5) {
            pressedHit.alive=false;
            hitResultTexts[2].setter(true, "GREAT");
            score=score+30;
            break;
          } else if (accuracy >0) {
            pressedHit.alive=false;
            hitResultTexts[2].setter(true, "GOOD");
            score=score+20;
            break;
          } else {
            pressedHit.alive=false;
            hitResultTexts[2].setter(true, "MISS");
            score=score-20;
            break;
          }
        }
      }
    } else if (key == keyboard[7]) {
      for (PressedHit pressedHit : musicDatas[songChoose].pressedHitList) {
        if (pressedHit.type==7 && pressedHit.alive && pressedHit.hitStartTime>0) {
          float accuracy=1-((float)(abs(pressedHit.hitStartTime-pressedHit.startTime)+abs(pressedHit.hitEndTime-pressedHit.endTime))/4)/((float)(pressedHit.endTime-pressedHit.startTime+30));
          pressedHit.hitStartTime=frameNum;
          if (accuracy >0.75) {
            pressedHit.alive=false;
            hitResultTexts[3].setter(true, "PERFECT");
            score=score+50;
            break;
          } else  if (accuracy >0.5) {
            pressedHit.alive=false;
            hitResultTexts[3].setter(true, "GREAT");
            score=score+30;
            break;
          } else if (accuracy >0) {
            pressedHit.alive=false;
            hitResultTexts[3].setter(true, "GOOD");
            score=score+20;
            break;
          } else {
            pressedHit.alive=false;
            hitResultTexts[3].setter(true, "MISS");
            score=score-20;
            break;
          }
        }
      }
    }
    break;
  }
}