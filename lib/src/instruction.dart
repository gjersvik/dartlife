part of dartlife;

abstract class Instruction{
  String get name;
  int get byte;
  
  String toString() => name;
}
