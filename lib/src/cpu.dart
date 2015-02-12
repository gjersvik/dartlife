part of dartlife;

typedef void LifeCallback(Lifeform);

class Cpu {
  Lifeform life;
  Uint32List r = new Uint32List(8);
  Uint8ClampedList c;
  Stack<int> stack0 = new Stack();
  Stack<int> stack1 = new Stack();
  
  //for factory
  LifeCallback birth = (_){};
  LifeCallback death = (_){};
  double mutation = 0.01;
  Random rand = new Random();
  InstructionSet iset;
  
  //private
  Op current;
  int _x = 0;
  int _comp = 0;
  bool _noop = false;
  int _temp = 0;
  List<int> copyLable = [];
  
  Cpu();
  
  int get reg1 => r[0];
  set reg1(int n) => r[0] = n;
  
  int get reg2 => r[1];
  set reg2(int n) => r[1] = n;
  
  int get reg3 => r[2];
  set reg3(int n) => r[2] = n;
  
  int get reg4 => r[3];
  set reg4(int n) => r[3] = n;

  getHead(int i){
    i += 4;
    return r[i];
  }
  
  setHead(int i, int v){
    i += 4;
    r[i] = v;
    while(r[i] >= c.length){
      r[i] -= c.length;
    }
  }
  
  int get ip => r[4];
  set ip(int n) => setHead(0,n);
  
  int get read => r[5];
  set read(int n) => setHead(1,n);
  
  int get write => r[6];
  set write(int n) => setHead(2,n);
  
  int get flow => r[7];
  set flow(int n) => setHead(3,n);
    
    
  
  //friend
  _newLife(Lifeform lifeform){
    life = lifeform;
    if(life != null){
      c = new Uint8ClampedList((life.dna.length * 2.5).truncate());
      c.setRange(0, life.dna.length, life.dna);
    }
  }
  
  //friend
  _clear(){
    life = null;
    r.fillRange(0, r.length, 0);
    c = null;
    stack0.clear();
    stack1.clear();
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
    while(iset.inst[ip] is Noop){
      ip += 1;
      if(ip == 0){
        return false;
      }
    }
    
    Runnable current = iset.inst[ip];
    ip += 1;
    
    if(current is Modefiable && iset.inst[ip] is Mod){
      var mod = (iset.inst[ip] as Mod).value;
      ip +=1;
      current.run(this, mod);
    }else if(current is Labelable){
      var label = new Label.fromDna(c, ip);
      ip += label.length;
      current.run(this,label);
    }else{
      current.run(this);
    }
    
    life.energy -= current.cost;
    
    if(life.energy < 0){
      death(life);
    }
    return true;
  }
}