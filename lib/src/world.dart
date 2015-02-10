part of dartlife;

class World{
  /// List of all [Lifeform]s in this world. Do not edit this list.
  List<Lifeform> lifeforms = [];
  
  /// List of all [Cpu]s in this world. Do not edit this list.
  List<Cpu> cpus = [];
  
  double tps = 0.0;
  double tpsAvg = 0.0;
  
  var _i = 0;
  
  World(){
    Cpu.birth = birthLife;
    Cpu.death = killLife;
  }
  
  /// puts a new [life] into the world
  birthLife(Lifeform life){
    if(life.cpu != null){
      throw "This life is allready alive";
    }
    life.cpu = new Cpu(life);
    lifeforms.add(life);
    cpus.add(life.cpu);
  }
  
  /** 
   * Removes the spesifc program from the world.
   * 
   * All the running state of this life will be deleted. So if its birthed again
   * it will start to run from the top.
   */
  killLife(Lifeform life){
    if(life.cpu == null){
      // its aready dead.
      return;
    }
    
    life.cpu.newLife(null);
    cpus.remove(life.cpu);
    life.cpu = null;
    lifeforms.remove(life);
  }
  
  
  /**
   * Runs the world for specefied amout of [time].
   * 
   * It will run sync for that time and will block timers and other events from
   * running. For gui application run 1-10 ms is recomened. Will at lest do one
   * tick for one of the lifeforms.
   */
  void run(Duration time){
    var micros = time.inMicroseconds;
    var runTimer = new Stopwatch()..start();
    var t = 0;
    do{
      if(cpus.isEmpty){
        break;
      }
      if(_i >= cpus.length){
        _i = 0;
      }
      cpus[_i].tick();
      t += 1;
      _i += 1;
    }while(runTimer.elapsedMicroseconds < micros);
    runTimer.stop();
    var secounds = runTimer.elapsedMicroseconds / 1000000;
    tps = t / secounds;
    tpsAvg -= tpsAvg / 60 / secounds;
    tpsAvg += tps / 60 / secounds;
  }
}