// Copyright (c) 2015, <your name>. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

library dartlife;

import 'dart:math';
import 'dart:typed_data';

part 'src/bio_instructions.dart';
part 'src/compute_instructions.dart';
part 'src/cpu.dart';
part 'src/instruction.dart';
part 'src/instruction_set.dart';
part 'src/label.dart';
part 'src/lifeform.dart';
part 'src/stack.dart';
part 'src/world.dart';

class Dartlife{
  LifeCallback birth = (_){};
  LifeCallback death = (_){};
  double mutation = 0.01;
  Random rand = new Random();
  
  InstructionSet _iset;
  World _world;
  List<Cpu> _cache = [];
  
  InstructionSet get iset{
    if(_iset = null){
      _iset = new InstructionSet();
      addComputeInstuction(_iset);
      addBioInstuction(_iset);
    }
    return _iset;
  }
  
  World get world{
    if(_world = null){
      _world = new World(this);
    }
    return _world;
  }
  
  Cpu getCpu(Lifeform life){
    var cpu = _cache.isEmpty ? new Cpu(this) : _cache.removeLast();
    cpu.birth = world.birthLife;
    cpu.death = world.killLife(life);
    cpu._newLife(life);
    return cpu;
  }
  
  releaseCpu(Cpu cpu){
    cpu._clear();
    _cache.add(cpu);
  } 
}