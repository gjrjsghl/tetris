import 'dart:typed_data';

import 'package:flutter/material.dart';



int boardHeight = 22;
int boardWidth = 10;


Uint8List data = Uint8List(0);

enum Blocks {
  I,J,L,O,S,T,Z
}

List<int> boardinfo = List.generate(boardHeight*boardWidth, (index) => 0);


Color getPixelColor(int n) {
  if(n == 1) return Colors.lightBlue;
  if(n == 2) return Colors.indigo;
  if(n == 3) return Colors.orange;
  if(n == 4) return Colors.yellow;
  if(n == 5) return Colors.lightGreen;
  if(n == 6) return Colors.purple;
  if(n == 7) return Colors.red;

  if(n == -1) return const Color.fromARGB(255, 189, 182, 182); //ghost

  if(n == -2) return Colors.black;

  return Color.fromARGB(255, 41, 41, 41);
}