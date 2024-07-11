import 'dart:math';
import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:tetris/setBlock.dart';
import 'package:tetris/setNext.dart';
import 'package:tetris/values.dart';

class board extends StatefulWidget {
  final bluetoothClassicPlugin;
  board({required this.bluetoothClassicPlugin});

  @override
  State<board> createState() => _boardState();
}

class _boardState extends State<board> {
  @override
  void initState() {
    super.initState();

    initgame();
  }

  void initgame() {
    gameover = false;
    boardinfo = List.generate(boardHeight * boardWidth, (index) => 0);
    initNexts();
    makePiece();
    gameroop();
    readroop();
  }

  

  nowBlock currentBlock = nowBlock(type: Blocks.I);
  int gameSpeed = 200;
  bool island = false;
  

  void readroop() {
    widget.bluetoothClassicPlugin.onDeviceDataReceived().listen((event) {

    data = Uint8List.fromList(event);

    String s = String.fromCharCodes(data);
    if(s == "G") {
      if(gameover == true) {
        initgame();

        return;
      }
      else {
        goGhost();
      }
    }
    if(s == "L") goLeft();
    if(s == "R") goRight();
    if(s == "T") turnToRight();
    if(s == "D") goDown();
    });
  }

  bool gameover = false;
  void gameroop() {
    Duration fps = Duration(milliseconds: gameSpeed);
    Timer.periodic(fps, (timer) {
      bool check = currentBlock.moveDown();

      if (check == false) {
        if(island == false) {
          island = true;
        }
        else {
          island = false;
          ghost = false;
          checkClear();
          if (isgameover() == true) {
            gameover = true;
            timer.cancel();
            widget.bluetoothClassicPlugin.write("ping");
          }
          else  {
            makePiece();
          }
        }
      }
      currentBlock.DrawBlock();
      setState(() {});

    });
  }


  bool isgameover() {
    if (boardinfo[4] > 0 || boardinfo[5] > 0) return true;
    return false;
  }

  void makePiece() {
    currentBlock = nowBlock(type: nextBlocks[0]);
    currentBlock.initblock();

    nextBlocks.removeAt(0);
    if (nextBlocks.length == 7) {
      suffleBlocks();
    }

    currentBlock.makeGhost();
  }

  void goDown() {
    if(ghost == true) return;
    setState(() {
      currentBlock.moveDown();
      currentBlock.DrawBlock();
    });
  }

  void goLeft() {
      if(ghost == true) return;
    setState(() {
      currentBlock.moveLeft();
      currentBlock.makeGhost();
      currentBlock.DrawBlock();
    });
  }

  void goRight() {
    if(ghost == true) return;
    setState(() {
      currentBlock.moveRight();
      currentBlock.makeGhost();
      currentBlock.DrawBlock();
    });
  }
  bool ghost = false;
  void goGhost() {
    setState(() {
      island = true;
      ghost = true;
      currentBlock.moveGhost();
      currentBlock.DrawBlock();

    });
  }

  void checkClear() {
    for (int i = 0; i < boardHeight; i++) {
      bool check = true;
      for (int j = 0; j < boardWidth; j++) {
        if (boardinfo[i * 10 + j] <= 0) {
          check = false;
          break;
        }
      }

      if (check == true) {
        boardinfo.removeRange(i * 10, (i + 1) * 10);
        List<int> temp = List.generate(10, (index) => 0);
        temp.addAll(boardinfo);
        boardinfo = temp.toList();
      }
    }
  }

  void turnToRight() {
    if(ghost == true) return;
    setState(() {
      currentBlock.turnRight();
      currentBlock.makeGhost();
      currentBlock.DrawBlock();
    });
  }


  Image nextImage(int idx) {
    if(nextBlocks[idx] == Blocks.I) return Image.asset("assets/I.png");
    if(nextBlocks[idx] == Blocks.J) return Image.asset("assets/J.png");
    if(nextBlocks[idx] == Blocks.L) return Image.asset("assets/L.png");
    if(nextBlocks[idx] == Blocks.O) return Image.asset("assets/O.png");
    if(nextBlocks[idx] == Blocks.S) return Image.asset("assets/S.png");
    if(nextBlocks[idx] == Blocks.T) return Image.asset("assets/T.png");

    return Image.asset("assets/Z.png");
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height - 160;
    double screenWidth = MediaQuery.of(context).size.width;
    double blockSize =
        min(screenHeight / boardHeight, screenWidth / boardWidth);

    return Column(
      children: [
        SizedBox(width: screenWidth,height: 10),

        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,

          children: [
            Container(
              width: screenWidth/6,
              height: 60,
              decoration : BoxDecoration(border: Border.all(color: Colors.red,width: 2)),
              child: nextImage(0),
            ),

            for(int i = 1;i<5;i++) 
              Container(
                width: screenWidth/6,
                height: 60,
                child: nextImage(i),
              )
          ]
        ),


        Center(
            child: Container(

                width: blockSize * boardWidth,
                height: blockSize * boardHeight,
                child: GridView.builder(
                  itemCount: boardHeight * boardWidth,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: boardWidth,
                    childAspectRatio: 1,
                    mainAxisSpacing: 0,
                    crossAxisSpacing: 0,
                  ),
                  itemBuilder: (BuildContext context, int index) {
                    if (index < 20) {
                      return Container(
                        width: blockSize,
                        height: blockSize,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(7),
                            color: getPixelColor(boardinfo[index])),
                      );
                    } else {
                      return Container(
                        width: blockSize,
                        height: blockSize,
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.white, width: 1),
                            borderRadius: BorderRadius.circular(7),
                            color: getPixelColor(boardinfo[index])),
                      );
                    }
                  },
                ))),


        SizedBox(width: screenWidth,height: 10),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
              color: Colors.white,
              height: 80,
              width: screenWidth / 5,
              child: IconButton(
                  onPressed: () {
                    goLeft();
                  },
                  icon: Icon(Icons.arrow_left_outlined)),
            ),
            Container(
              color: Colors.white,
              height: 80,
              width: screenWidth / 5,
              child: IconButton(
                  onPressed: () {
                    goRight();
                  },
                  icon: Icon(Icons.arrow_right_outlined)),
            ),
            
            Container(
              color: Colors.white,
              height: 80,
              width: screenWidth / 5,
              child: IconButton(
                  onPressed: () {
                    goGhost();
                  },
                  icon: Icon(Icons.file_download_outlined)),
            ),
            Container(
              color: Colors.white,
              height: 80,
              width: screenWidth / 5,
              child: IconButton(
                  onPressed: () {
                    turnToRight();
                  },
                  icon: Icon(Icons.turn_right)),
            ),

            Container(
              color: Colors.white,
              height: 80,
              width: screenWidth / 5,
              child: IconButton(
                  onPressed: () {
                    goDown();
                  },
                  icon: Icon(Icons.arrow_downward)),
            ),
          ],
        )
      ],
    );
  }
}