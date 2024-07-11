import 'package:tetris/values.dart';

List<Blocks> nextBlocks = [];

void suffleBlocks() {

  List<Blocks> temp = Blocks.values.toList();

  temp.shuffle();
  nextBlocks.addAll(temp);
}

void initNexts() {
  List<Blocks> temp = Blocks.values.toList();
  temp.shuffle();
  nextBlocks = temp.toList();

  temp.shuffle();
  nextBlocks.addAll(temp);
}