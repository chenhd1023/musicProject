import java.util.Collections;
class Rank {
  Table table1;
  ArrayList<Score> rankList0 = new ArrayList<Score>();
  ArrayList<Score> rankList1 = new ArrayList<Score>();
  ArrayList<Score> rankList2 = new ArrayList<Score>();
  Rank() {
    load();
    Collections.sort(rankList0);
    Collections.sort(rankList1);
    Collections.sort(rankList2);
  }
  void save(int type, String name, int score) {
    /*table1 = new Table();
     table1.addColumn("type");
     table1.addColumn("name");
     table1.addColumn("score");*/

    TableRow newRow = table1.addRow();
    newRow.setInt("type", type);
    newRow.setString("name", name);
    newRow.setInt("score", score);
    saveTable(table1, "data/rank.csv");
    load();
  }
  void load() {
    table1 = loadTable("data/rank.csv", "header");
    for (TableRow row : table1.rows()) {
      int type = row.getInt("type");
      String name = row.getString("name");
      int score = row.getInt("score");
      Score tmp =new Score(type, score, name);
      if (type==0) {
        rankList0.add(tmp);
      } else if (type==1) {
        rankList1.add(tmp);
      } else if (type==2) {
        rankList2.add(tmp);
      }
    }
  }

  int rank(int type, int score) {
    if (type==0) {
      int i;
      for (i=0; i<rankList0.size(); i++ ) {
        if (score > rankList0.get(i).score) {
          return i+1;
        }
      }
      return i+2;
    } else if (type==1) {
      int i;
      for (i=0; i<rankList1.size(); i++ ) {
        if (score > rankList1.get(i).score) {
          return i+1;
        }
      }
      return i+2;
    } else if (type==2) {
      int i;
      for (i=0; i<rankList2.size(); i++ ) {
        if (score > rankList2.get(i).score) {
          return i+1;
        }
      }
      return i+2;
    }
    return 999;
  }
}