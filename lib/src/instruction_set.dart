part of dartlife;

class InstructionSet {
  List<Instruction> inst =
      new List.generate(255, (i) => new Noop(i), growable: false);
  Map<String, Instruction> names;

  InstructionSet(){
    names = new Map.fromIterables(inst.map((i)=> i.name), inst);
  }

  add(Instruction i) {
    int b = i.byte;
    //see if the byte is avalable.
    if(inst[b].name != 'nop$b'){
      throw "There is already an instruction ${inst[b]} at the adress $b, can't add $i";
    }
    
    //see if the name is avalable.
    if(names.containsKey(i.name)){
      throw "The name ${i.name} is already taken by instuction at adress ${names[i.name].byte}";
    }
    
    replace(i);
  }
  
  replace(Instruction i){
    int b = i.byte;
    names.remove(inst[b].name);
    inst[b] = i;
    names[i.name] = i;
  }
  
  Instruction random(){
    
  }
}
