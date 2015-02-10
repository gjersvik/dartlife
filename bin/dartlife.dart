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
  
  var world = new World();
  world.birthLife(new Lifeform.fromOps(code));
  
  while(true){
    world.run(new Duration(milliseconds: 100));
    print("Lifeforms: ${world.lifeforms.length}");
    print("Ticks per secound: ${world.tps.toInt()}");
    print("Tps minute avrage: ${world.tpsAvg.toInt()}");
  }
}