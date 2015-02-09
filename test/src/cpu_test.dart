part of dartlife.test;

testCpu() => group('Cpu',(){
  test('NopABC',(){
    var code = [Op.nopA,Op.nopB,Op.nopC];
    
    expect(cpuRun(code),cpuHasRegisters([0,0,0]));
  });
  
  test('ifEqu',(){
    var code = [
      Op.ifEqu, //if(regB == regC) true
      Op.inc, //regA += 1;
      Op.nopA,
      Op.ifEqu,//if(regC == regA) false
      Op.nopC,
      Op.inc, //regB += 1; Shuld not run
      Op.nopB,
    ];
    
    expect(cpuRun(code),cpuHasRegisters([1,0,0]));
  });
  
  test('ifLess',(){
    var code = [
      Op.inc, //regC += 1;
      Op.nopC,
      Op.ifLess, //if(regB(0) < regC(1)) true
      Op.inc, //regC += 1;
      Op.nopC,
      Op.ifLess,//if(regC < regA) false
      Op.nopC,
      Op.inc, //regB += 1; Shuld not run
      Op.nopB,
    ];
    
    expect(cpuRun(code),cpuHasRegisters([0,0,2]));
  });
  test('pop/push',(){
    var code = [
      Op.inc, //regB += 1;
      Op.inc, //regB += 1;
      Op.push, // stack.push(regB(2));
      Op.pop, // regA = stack.pop();
      Op.nopA,
      Op.pop, // regC = stack.pop(); Pop an empy stak shuld be a noop.
      Op.nopC
    ];
    
    expect(cpuRun(code),cpuHasRegisters([2,2,0]));
  });
  
  test('swapStk',(){
    var code = [
      Op.inc,     //regB += 1;
      Op.inc,     //regB += 1;
      Op.push,    // stack.push(regB(2));
      Op.swapStk, //
      Op.pop,     // regA = stack.pop(); is now an empty stack.
      Op.nopA,
    ];
    
    expect(cpuRun(code),cpuHasRegisters([0,2,0]));
  });
  
  test('swap',(){
    var code = [
      Op.inc,     // regB += 1;
      Op.inc,     // regB += 1;
      Op.swap,    // swap(regB(2),regC(0));
      Op.nopB
    ];
   
    expect(cpuRun(code),cpuHasRegisters([0,0,2]));
  });
  
  test('shiftR',(){
    var code = [
      Op.inc,     // regB += 1;
      Op.inc,     // regB += 1;
      Op.shiftR,    // regB >> 1;
      Op.nopB
    ];
   
    expect(cpuRun(code),cpuHasRegisters([0,1,0]));
  });
  
  test('shiftL',(){
    var code = [
      Op.inc,     // regB += 1;
      Op.inc,     // regB += 1;
      Op.shiftL,    // regB << 1;
      Op.nopB
    ];
   
    expect(cpuRun(code),cpuHasRegisters([0,4,0]));
  });

  test('inc',(){
    var code = [
      Op.inc, //regA += 1;
      Op.nopA,
    ];
    
    expect(cpuRun(code),cpuHasRegisters([1,0,0]));
  });

  test('dec',(){
    var code = [
      Op.dec, //regA -= 1;
      Op.nopA,
    ];
    
    expect(cpuRun(code),cpuHasRegisters([4294967295,0,0]));
  });

  test('add',(){
    var code = [
      Op.inc, 
      Op.shiftL,
      Op.inc,
      Op.inc,
      Op.nopC,
      Op.add, //regA = regB(3) + regC(1);
      Op.nopA,
    ];
    
    expect(cpuRun(code),cpuHasRegisters([4,3,1]));
  });

  test('sub',(){
    var code = [
      Op.inc,
      Op.shiftL,
      Op.inc,
      Op.inc,
      Op.nopC,
      Op.sub, //regA = regB(3) + regC(1);
      Op.nopA,
    ];
    
    expect(cpuRun(code),cpuHasRegisters([2,3,1]));
  });

  test('nand',(){
    var code = [
      Op.inc,
      Op.shiftL,
      Op.inc,
      Op.inc,
      Op.nopC,
      Op.nand, //regA = regB(3) !& regC(1);
      Op.nopA,
    ];
    
    expect(cpuRun(code),cpuHasRegisters([4294967294,3,1]));
  });

  test('hDivide',(){
    var code = [
      Op.hDivide,
      Op.nopA,
      Op.nopB,
      Op.nopC,
      Op.nopA,
      Op.nopB,
      Op.nopC,
    ];
    
    var oldcall = Cpu.birth;
    Lifeform life;
    Cpu.birth = (Lifeform l) => life = l;
    
    var cpu = getCpu(code);
    cpu.safeSet(Cpu.read, 4);
    cpu.safeSet(Cpu.write, 7);
    
    runCpu(cpu);
    Cpu.birth = oldcall;
    
    print(cpu.c);
    print(life.dna);
  });

  test('hCopy',(){
    
  });

  test('hSearch',(){

    var code = [
      Op.hSearch, // 0
      Op.nopA,
      Op.nopB,
      Op.nopC,
      Op.inc,
      Op.nopA,
      Op.nopB,
      Op.nopC,
      Op.nopA
    ];
    
    var cpu = cpuRun(code);
    expect(cpu,cpuHasRegisters([1,8,3]));
    expect(cpu.r[Cpu.flow], 8);
  });

  test('hSearch not found',(){
    var code = [
      Op.hSearch,
      Op.nopA,
      Op.nopB,
      Op.nopC,
      Op.inc,
    ];
    
    var cpu = cpuRun(code);
    expect(cpu,cpuHasRegisters([1,0,3]));
    expect(cpu.r[Cpu.flow], 1);
  });

  test('hSearch no label',(){
    var code = [
      Op.hSearch,
      Op.inc,
    ];
    
    var cpu = cpuRun(code);
    expect(cpu,cpuHasRegisters([1,0,0]));
    expect(cpu.r[Cpu.flow], 1);
  });
  
  test('movHead',(){
    
  });
  
  test('jumHead',(){
    
  });
  
  test('getHead',(){
    
  });
  
  test('ifLabel',(){
    
  });
  
  test('setFlow',(){
    var code = [
      Op.setFlow,
      Op.nopC
    ];
    
    var cpu = getCpu(code);
    cpu.r.setRange(0, 3, [0, 0, 2]);
    runCpu(cpu);
    
    expect(cpu.r[Cpu.flow], 2);
  });
});