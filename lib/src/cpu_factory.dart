part of dartlife;

class CpuFactory{
  LifeCallback birth = (_){};
  LifeCallback death = (_){};
  double mutation = 0.01;
  Random _rand = new Random();
  
  List<Cpu> _cache = [];
  
  CpuFactory();
  
  Cpu getCpu(Lifeform life){
    var cpu = _cache.isEmpty ? new Cpu() : _cache.removeLast();
    cpu._birth = birth;
    cpu._death = death;
    cpu._mutation = mutation;
    cpu._rand = _rand;
    cpu._newLife(life);
    return cpu;
  }
  
  releaseCpu(Cpu cpu){
    cpu._clear();
    _cache.add(cpu);
  } 
}