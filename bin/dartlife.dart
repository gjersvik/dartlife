import 'package:dartlife/dartlife.dart';

import 'dart:io';

List<Cpu> cpus = [];

main(){
  var code = [
    Op.hSearch,
    Op.nopC,
    Op.nopA,
    Op.movHead,
    Op.nopC,
    Op.hSearch,
    Op.hCopy,
    Op.ifLabel,
    Op.nopC,
    Op.nopA,
    Op.inc,
    Op.nopC,
    Op.jmpHead,
    Op.movHead,
    Op.hDivide,
    Op.nopA,
    Op.nopB
  ];
  
  Cpu.birth = runLife;
  runLife(new Lifeform.fromOps(code));
  
  int i = 0;
  int tps = 0;
  Stopwatch sp = new Stopwatch()..start();
  
  while(true){
    if(i >= cpus.length){
      i = 0;
    }
    cpus[i].tick();
    i += 1;
    tps += 1;
    if(sp.elapsedMilliseconds >= 1000){
      print("Ticks last second: $tps");
      tps = 0;
      sp.reset();
    }
  }
}

runLife(Lifeform life){
  print('newLife: ${life.dna}');
  cpus.add(new Cpu(life));
}