import 'package:dartlife/dartlife.dart';

main(){
  var code = 'search:c:a mhead:c search copy iflabel:c:a inc:c jhead mhead devide a:b';
  
  var dartlife = new Dartlife();
  
  var world = dartlife.world;
  world.birthLife(dartlife.lifeFromString(code));
  
  while(true){
    world.run(new Duration(milliseconds: 100));
    print("Lifeforms: ${world.lifeforms.length}");
    print("Ticks per secound: ${world.tps.toInt()}");
    print("Tps minute avrage: ${world.tpsAvg.toInt()}");
  }
}