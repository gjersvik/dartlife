part of dartlife;

addComputeInstuction(InstructionSet set){
  set.add(new Mod(1,'moda',0));
  set.add(new Mod(2,'modb',1));
  set.add(new Mod(3,'modc',2));
  set.add(new Mod(4,'modd',3));
  set.add(new IfEqual());
  set.add(new IfLess());
  set.add(new Pop());
  set.add(new Push());
  set.add(new SwapStack());
  set.add(new Swap());
  set.add(new ShiftLeft());
  set.add(new ShiftRight());
  set.add(new Increment());
  set.add(new Decrement());
  set.add(new Add());
  set.add(new Sub());
  set.add(new NotAnd());
  set.add(new MoveHead());
  set.add(new JumpHead());
  set.add(new GetHead());
  set.add(new SetHead());
}

class IfEqual extends Modefiable{
  final int byte = 5;
  final double cost = 1.0;
  final name = 'ifequ';
  
  void run(Cpu c, [int mod = 1]) {
    var comp = mod + 1;
    if(comp >= 3){
      comp = 0;
    }
    //skip text istuction if not equal.
    if(c.r[mod] != c.r[comp]){
      c.ip += 1;
    }
  }
}

class IfLess extends Modefiable{
  final int byte = 6;
  final double cost = 1.0;
  final name = 'ifless';
  
  void run(Cpu c, [int mod = 1]) {
    var comp = mod + 1;
    if(comp >= 3){
      comp = 0;
    }
    //skip text istuction if not less.
    if(c.r[mod] >= c.r[comp]){
      c.ip += 1;
    }
  }
}

class Pop extends Modefiable{
  final int byte = 7;
  final double cost = 1.0;
  final name = 'pop';
  
  void run(Cpu c, [int mod = 1]) {
    if(c.stack0.isNotEmpty){
      c.r[mod] = c.stack0.pop();
    }
  }
}

class Push extends Modefiable{
  final int byte = 8;
  final double cost = 1.0;
  final name = 'push';
  
  void run(Cpu c, [int mod = 1]) => c.stack0.push(c.r[mod]);
}

class SwapStack extends Runnable{
  final int byte = 9;
  final double cost = 1.0;
  final name = 'swapstk';
  
  void run(Cpu c){
    var temp = c.stack0;
    c.stack0 = c.stack1;
    c.stack1 = temp;
  }
}

class Swap extends Modefiable{
  final int byte = 10;
  final double cost = 1.0;
  final name = 'swap';
  
  void run(Cpu c, [int mod = 1]){
    var comp = mod + 1;
    if(comp >= 3){
      comp = 0;
    }
    var temp = c.r[mod];
    c.r[mod] = c.r[comp];
    c.r[comp] = temp;
  }
}

class ShiftRight extends Modefiable{
  final int byte = 11;
  final double cost = 1.0;
  final name = 'shiftr';
  
  run(Cpu c, [int mod = 1]) => c.r[mod] = c.r[mod] ~/ 2;
}

class ShiftLeft extends Modefiable{
  final int byte = 12;
  final double cost = 1.0;
  final name = 'shiftl';
  
  run(Cpu c, [int mod = 1]) => c.r[mod] = c.r[mod] * 2;
}

class Increment extends Modefiable{
  final int byte = 13;
  final double cost = 1.0;
  final name = 'inc';
  
  run(Cpu c, [int mod = 1]) => c.r[mod] += 1;
}

class Decrement extends Modefiable{
  final int byte = 14;
  final double cost = 1.0;
  final name = 'dec';
  
  run(Cpu c, [int mod = 1]) => c.r[mod] -= 1;
}

class Add extends Modefiable{
  final int byte = 15;
  final double cost = 1.0;
  final name = 'add';
  
  run(Cpu c, [int mod = 1]) => c.r[mod] = c.r[2] + c.r[3];
}

class Sub extends Modefiable{
  final int byte = 16;
  final double cost = 1.0;
  final name = 'sub';
  
  run(Cpu c, [int mod = 1]) => c.r[mod] = c.r[2] - c.r[3];
}

class NotAnd extends Modefiable{
  final int byte = 17;
  final double cost = 1.0;
  final name = 'nand';
  
  run(Cpu c, [int mod = 1]) => c.r[mod] = ~(c.r[2] & c.r[3]);
}

class MoveHead extends Modefiable{
  final int byte = 18;
  final double cost = 1.0;
  final name = 'mhead';
  
  run(Cpu c, [int mod = 0]) => c.setHead(mod, c.flow);
}

class JumpHead extends Modefiable{
  final int byte = 19;
  final double cost = 1.0;
  final name = 'jhead';
  
  run(Cpu c, [int mod = 0]) => c.setHead(mod,c.r[mod] + c.reg4);
}

class GetHead extends Modefiable{
  final int byte = 20;
  final double cost = 1.0;
  final name = 'ghead';
  
  run(Cpu c, [int mod = 0]) => c.reg4 = c.getHead(mod);
}

class SetHead extends Modefiable{
  final int byte = 21;
  final double cost = 1.0;
  final name = 'shead';
  run(Cpu c, [int mod = 0]) => c.setHead(mod,c.reg4);
}