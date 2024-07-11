import 'dart:math';
import 'package:tetris/values.dart';


class nowBlock {
  Blocks type;
  nowBlock({required this.type});
  List<int> position = [];
  int typeColor = 0;
  List<int> posGhost = [0,0,0,0];
  int turnCnt = 0;

  void initblock() {
    position.clear();

    if (type == Blocks.I) {
      position.addAll([3,4,5,6]);
      typeColor = 1;
    }

    else if (type == Blocks.J) {
      position.addAll([3,13,14,15]);
      typeColor = 2;
    }

    else if (type == Blocks.L) {
      position.addAll([13,14,15,5]);
      typeColor = 3;
    }

    else if (type == Blocks.O) {
      position.addAll([3,4,13,14]);
      typeColor = 4;
    }

    else if (type == Blocks.S) {
      position.addAll([13,14,4,5]);
      typeColor = 5;
    }

    else if (type == Blocks.T) {
      position.addAll([13,14,15,4]);
      typeColor = 6;
    }

    else if (type == Blocks.Z) {
      position.addAll([3,4,14,15]);
      typeColor = 7;
    }


    turnCnt = 0;
  }


  void makeGhost() {
    for(int i = 0;i<4;i++) {
      boardinfo[posGhost[i]] = 0;
    }
    posGhost = position.toList();

    while(willDrop(posGhost) == false) {
      for(int i = 0;i<4;i++) {
        posGhost[i] += 10;
      }
    }

    for(int i = 0;i<4;i++) {
      boardinfo[posGhost[i]] = -1;
    }
  }

  bool moveDown() {
    if(willDrop(position) == true) return false;
    
    for(int i = 0;i<4;i++) {
      if (position[i] >= 0) boardinfo[position[i]] = 0;
      position[i] += 10;
    }
    return true;
  }

  void DrawBlock() {
    for(int i = 0;i<4;i++) {
      if (position[i] >= 0)      
        boardinfo[position[i]] = typeColor;
    }
  }

  bool willDrop(List<int> pos) {
    for(int i = 0;i<4;i++) {

      if(pos[i]+10 < 0) continue;
      if(pos[i]+10 >= 220) return true;


      if(boardinfo[pos[i]+10] > 0) {
        bool check = true;
        for(int k = 0;k<4;k++) {
          if(pos[i]+10 == pos[k]) {
            check = false;
            break;
          }
        }
        if(check == true) {
          return true;
        }
      }
    }
    return false;
  }


  void moveLeft() {
    List<int> temp = position.toList();
    for(int i = 0;i<4;i++) {
      temp[i] -= 1;
    }
    if(checkOut(temp) == false) return;

    for(int i = 0;i<4;i++) {
      if(boardinfo[position[i]-1] > 0) {
        bool check = true;
        for(int k = 0;k<4;k++) {
          if(position[i]-1 == position[k]) {
            check = false;
            break;
          }
        }
        if(check == true) {
          return;
        }
      }
    }

    
    for(int i = 0;i<4;i++) {
      boardinfo[position[i]] = 0;
    }

    for(int i = 0;i<4;i++) {
      position[i] -= 1;
      boardinfo[position[i]] = typeColor;
    }
  }

  
  void moveRight() {

    List<int> temp = position.toList();
    for(int i = 0;i<4;i++) {
      temp[i] += 1;
    }
    if(checkOut(temp) == false) return;

    for(int i = 0;i<4;i++) {
      if(boardinfo[position[i]+1] > 0) {
        bool check = true;
        for(int k = 0;k<4;k++) {
          if(position[i]+1 == position[k]) {
            check = false;
            break;
          }
        }
        if(check == true) {
          return;
        }
      }
    }

    
    for(int i = 0;i<4;i++) {
      boardinfo[position[i]] = 0;
    }

    for(int i = 0;i<4;i++) {
      position[i] += 1;
      boardinfo[position[i]] = typeColor;
    }
  }


  void moveGhost() {
    for(int i = 0;i<4;i++) {
      boardinfo[position[i]] = 0;
    }
    
    position = posGhost.toList();
  }


  List<List<List<int>>> turn = [
    [[-8,1,10,19],[18,9,0,-9],[-19,-10,-1,8],[9,0,-9,-18]],
    [[2,-9,0,9],[20,11,0,-11],[-2,9,0,-9],[-20,-11,0,11]],
    [[-9,0,9,20],[11,0,-11,-2],[9,0,-9,-20],[-11,0,11,2]],
    [[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0]],
    [[-9,0,11,20],[11,0,9,-2],[9,0,-11,-20],[-11,0,-9,2]],
    [[-9,0,9,11],[11,0,-11,9],[9,0,-9,-11],[-11,0,11,-9]],
    [[2,11,0,9],[20,9,0,-11],[-2,-11,0,-9],[-20,-9,0,11]]
  ];

  void turnRight() {
    List<int> temp = position.toList();
    for(int i = 0;i<4;i++) {
      temp[i] += turn[typeColor-1][turnCnt%4][i];
    }

    for(int i = 0;i<4;i++) {
      boardinfo[position[i]] = 0;
    }
    position = kick(temp).toList();
  }

  List<List<List<int>>> teleport = [
      [[0,0],[-1,0],[-1,1],[0,-2],[-1,-2]],
      [[0,0],[1,0],[1,-1],[0,2],[1,2]],
      [[0,0],[1,0],[1,1],[0,-2],[1,-2]],
      [[0,0],[-1,0],[-1,-1],[0,2],[-1,2]],
  ];


    
  List<List<List<int>>> Iteleport = [
    [[0,0],[-2,0],[1,0],[-2,-1],[1,2]],
    [[0,0],[-1,0],[2,0],[-1,2],[2,-1]],
    [[0,0],[2,0],[-1,0],[2,1],[-1,-2]],
    [[0,0],[1,0],[-2,0],[1,-2],[-2,1]]
  ]; 

  List<int> kick(List<int> pos) {
    if(type == Blocks.I) {
      for(int i = 0;i<5;i++) {
        List<int> temp = pos.toList();
        for(int k = 0;k<4;k++) {
          temp[k] += Iteleport[turnCnt%4][i][0] - Iteleport[turnCnt%4][i][1]*10;
        }

        if(ispossible(temp) == true) {
          pos = temp.toList();
          turnCnt += 1;
          
          return pos.toList();
        }
      }
    }
    else {
      for(int i = 0;i<5;i++) {
        List<int> temp = pos.toList();
        for(int k = 0;k<4;k++) {
          temp[k] += teleport[turnCnt%4][i][0] - teleport[turnCnt%4][i][1]*10;
        }
        if(ispossible(temp) == true) {
          pos = temp.toList();
          turnCnt += 1;

          return pos.toList();
        }
      }
    }


    return position.toList();
  }


  bool ispossible(List<int> pos) {
    if(checkOut(pos) == false) return false;
    for(int i = 0;i<4;i++) {
      if(boardinfo[pos[i]] > 0) {
        if(!position.contains(pos[i])) return false;
      }
    }
    return true;
  }



  bool checkOut(List<int> pos) {

    for(int i = 0;i<4;i++) {
      if(pos[i] >= 220) return false;
    }

    int a = 0;
    int b = 9;
    for(int i = 0;i<4;i++) {
      a = max(pos[i]%10,a);
      b = min(pos[i]%10,b);
    }

    if(a-b > 4) return false;

    if(type == Blocks.I && turnCnt%2 == 1) {
      
      if(position[0]%10 == 0 && a == 9) {
        return false;
      }


      if(position[0]%10 == 9 && b == 0) {
        return false;
      }
    }
    return true;
  }
}

