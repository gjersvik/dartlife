part of dartlife;

addBioInstuction(InstructionSet set){
  set.add(new Divide());
  set.add(new Copy());
  set.add(new Search());
  set.add(new IfLabel());
}

class Divide extends Runnable{
  final int byte = 22;
  final double cost = 1.0;
  final name = 'divide';
  
  run(Cpu c){
    int length = c.write - c.read;
    if(length < 1){
      return;
    }
    Uint8ClampedList dna = new Uint8ClampedList(length);
    for(var i = 0; i < dna.length; i += 1){
      dna[i] = c.c[c.read + i];
      c.c[c.read + i] = 0;
    }
    
    for(var i = c.write; i < c.c.length; i += 1){
      c.c[i] = 0;
    }
    
    c.birth(new Lifeform(dna));
  }
}

class Copy extends Runnable{
  final int byte = 23;
  final double cost = 1.0;
  final name = 'copy';
  
  run(Cpu c){
    if(c.iset.inst[c.c[c.read]] is Mod){
      c.copyLable.add(c.c[c.read]);
    }else{
      c.copyLable.clear();
    }
    if(c.rand.nextDouble() > c.mutation){
      c.c[c.write] = c.c[c.read];
      c.write += 1;
      c.read += 1;
    }else{
      var d = c.rand.nextDouble();
      if(d < 0.5){
        // Mutate
        c.c[c.write] = c.iset.random().byte;
        c.write += 1;
        c.read += 1;
      }else if(d < 0.75){
        // Duplicate
        c.c[c.write] = c.c[c.read];
        c.write += 1;
        c.c[c.write] = c.c[c.read];
        c.write += 1;
        c.read += 1;
      }else{
        // Delete
        c.read += 1;
      }
    }
  }
}

class Search extends Labelable{
  final int byte = 24;
  final double cost = 1.0;
  final name = 'search';
  
  run(Cpu c, [Label label]){
    if(label == null){
      label = new Label([]);
    }
    label = label.comp(); 
    int to = -1;
    if(label.length != 0){
      to = label.find(c.c, c.ip);
    }
    if(to == -1 ){
      c.reg3 = 0;
      c.flow = c.ip;
    }else{
      c.reg3 = to - c.ip + 1;
      c.flow = to;
    }
    c.reg4 = label.length;
  }
}



class IfLabel extends Labelable{
  final int byte = 25;
  final double cost = 1.0;
  final name = 'iflabel';
  
  run(Cpu c, [Label label]){
    if(label == null){
      label = new Label([]);
    }
    label = label.comp();
    var i = label.find(c.copyLable, 0);
    if(i != label.length){
      c.ip += 1;
    }
  }
}