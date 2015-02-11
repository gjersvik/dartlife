part of dartlife;

abstract class Instruction{
  String get name;
  int get byte;
  double get cost;
  
  String toString() => name;
}

class Noop implements Instruction{
  final int byte;
  final double cost = 0.0;
  
  Noop(this.byte);
  
  String get name => 'nop$byte';
}

class Mod implements Noop{
  final String name;
  final int byte;
  final double cost = 0.0;
  final int value;
  
  Mod(this.byte,this.name, this.value);
}

abstract class Runnable implements Instruction{
  void run(Cpu cpu);
}

abstract class Modefiable implements Runnable{
  void run(Cpu cpu, [int mod]);
}

abstract class Labelable implements Runnable{
  void run(Cpu cpu, [Label label]);
}

