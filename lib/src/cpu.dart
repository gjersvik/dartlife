part of dartlife;

typedef void LifeCallback(Lifeform);
typedef void CpuCallback(Cpu);

enum Op{
  nopA,
  nopB,
  nopC,
  ifEqu,
  ifLess,
  pop,
  push,
  swapStk,
  swap,
  shiftR,
  shiftL,
  inc,
  dec,
  add,
  sub,
  nand,
  hDivide,
  hCopy,
  hSearch,
  movHead,
  jmpHead,
  getHead,
  ifLabel,
  setFlow
}

class Cpu {
  static LifeCallback birth = (_){};
  static CpuCallback death = (_){};
  
  static double mutation = 0.01;
  static Random rand = new Random();
  
  static const regA = 0;
  static const regB = 1;
  static const regC = 2;
  static const ip = 3;
  static const read = 4;
  static const write = 5;
  static const flow = 6;
  
  Lifeform _life;
  Uint32List r = new Uint32List(7);
  Uint8ClampedList c;
  Stack<int> stack0 = new Stack();
  Stack<int> stack1 = new Stack();
  
  Op current;
  int _x = 0;
  int _comp = 0;
  bool _noop = false;
  int _temp = 0;
  Stack<int> _tempStack;
  List<int> _copyLable = [];
  
  Cpu([Lifeform life]){
    if(life != null){
      newLife(life);
    }
  }
  
  newLife(Lifeform life){
    _life = life;
    r = new Uint32List(7);
    c = new Uint8ClampedList((life.dna.length * 2.5).truncate());
    for(var i = 0; i < life.dna.length; i += 1){
      c[i] = life.dna[i];
    }
    stack0 = new Stack();
    stack1 = new Stack();
  }
  
  safeSet(reg,value){
    r[reg] = value;
    while(r[reg] >= c.length){
      r[reg] -= c.length;
    }
  }
  
  // returns false when its done with a run.
  bool tick(){
    //skip all noop instuctions
    while(r[ip] < c.length && c[r[ip]] < 3){
      r[ip] += 1;
    }
    if(r[ip] == c.length){
      r[ip] = 0;
      return false;
    }
    
    current = Op.values[c[r[ip]]];
    
    //move instuction pointer;
    safeSet(ip,r[ip] + 1);
    
    _noop = c[r[ip]] < 3;
    
    _x = 1;
    if(_noop){
      _x = c[r[ip]];
    }
    _comp = _x + 1;
    if(_comp == 3){
      _comp = 0;
    }
    
    switch(current) {
      case Op.nopA:
      case Op.nopB:
      case Op.nopC:
        break;
      case Op.ifEqu:
        if(_noop){
          safeSet(ip,r[ip] + 1);
        }
        //skip text istuction if not equal.
        if(r[_x] != r[_comp]){
          safeSet(ip,r[ip] + 1);
        }
        break;
      case Op.ifLess:
        if(_noop){
          safeSet(ip,r[ip] + 1);
        }
        //skip text istuction if not less.
        if(r[_x] >= r[_comp]){
          safeSet(ip,r[ip] + 1);
        }
        break;
      case Op.pop:
        if(stack0.isNotEmpty){
          r[_x] = stack0.pop();
        }
        break;
      case Op.push:
        stack0.push(r[_x]);
        break;
      case Op.swapStk:
        _tempStack = stack0;
        stack0 = stack1;
        stack1 = _tempStack;
        break;
      case Op.swap:
        _temp = r[_x];
        r[_x] = r[_comp];
        r[_comp] = _temp;
        break;
      case Op.shiftR:
        r[_x] = r[_x] ~/ 2;
        break;
      case Op.shiftL:
        r[_x] = r[_x] * 2;
        break;
      case Op.inc:
        r[_x] += 1;
        break;
      case Op.dec:
        r[_x] -= 1;
        break;
      case Op.add:
        r[_x] = r[1] + r[2];
        break;
      case Op.sub:
        r[_x] = r[1] - r[2];
        break;
      case Op.nand:
        r[_x] = ~(r[1] & r[2]);
        break;
      case Op.hDivide:
          _devide();
        break;
      case Op.hCopy:
        if(c[r[read]] < 3){
          _copyLable.add(c[r[read]]);
        }else{
          _copyLable.clear();
        }
        if(rand.nextDouble() > mutation){
          c[r[write]] = c[r[read]];
          safeSet(write, r[write]+1);
          safeSet(read, r[read]+1);
        }else{
          _mutate();
        }
        break;
      case Op.hSearch:
          _seatch();
        break;
      case Op.movHead:
        _x = 3;
        if(_noop){
          _x = c[r[ip]] + 3;
        }
        r[_x] = r[flow];
        break;
      case Op.jmpHead:
        _x = 3;
        if(_noop){
          _x = c[r[ip]] + 3;
        }
        safeSet(_x, r[_x] + r[2]);
        break;
      case Op.getHead:
        _x = 3;
        if(_noop){
          _x = c[r[ip]] + 3;;
        }
        r[2] = r[_x];
        break;
      case Op.ifLabel:
        _ifLabel();
        break;
      case Op.setFlow:
        _x = 2;
        if(_noop){
          _x = c[r[ip]];
        }
        safeSet(flow, r[_x]);
        break;
    }
    return true;
  }
  
  _devide(){
    int length = r[write] - r[read];
    if(length < 1){
      return;
    }
    Uint8ClampedList dna = new Uint8ClampedList(length);
    for(var i = 0; i < dna.length; i += 1){
      dna[i] = c[r[read] + i];
      c[r[read] + i] = 0;
    }
    
    for(var i = r[write]; i < c.length; i += 1){
      c[i] = 0;
    }
    
    birth(new Lifeform(dna));
  }
  _mutate(){
    var d = rand.nextDouble();
    if(d < 0.5){
      // Mutate
      c[r[write]] = rand.nextInt(Op.values.length);
      safeSet(write, r[write]+1);
      safeSet(read, r[read]+1);
    }else if(d < 0.75){
      // Duplicate
      c[r[write]] = c[r[read]];
      safeSet(write, r[write]+1);
      c[r[write]] = c[r[read]];
      safeSet(write, r[write]+1);
      safeSet(read, r[read]+1);
    }else{
      // Delete
      safeSet(read, r[read]+1);
    }
  }
  _seatch(){
    var label = new Label.fromDna(c, r[ip]).comp();
    int to = -1;
    if(label.length != 0){
      to = label.find(c, r[ip]);
    }
    if(to == -1 ){
      r[regB] = 0;
      r[flow] = r[ip];
    }else{
      r[regB] = to - r[ip] + 1;
      r[flow] = to;
    }
    r[regC] = label.length;
  }
  _ifLabel(){
    var label = new Label.fromDna(c, r[ip]).comp();
    var i = label.find(_copyLable, 0);
    if(i != label.length){
      safeSet(ip, r[ip] + label.length + 1);
    }
  }
}