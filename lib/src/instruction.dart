part of dartlife;

typedef void InstructionCallback(Cpu cpu, int Modifier, Label label);

class Instruction{
  final bool noop;
  final bool useModifier;
  final bool useLable;
  final int defultModifier;
  final InstructionCallback run;

  Instruction(this.run, {this.useModifier: false, this.useLable: false,
      this.defultModifier: 0}): noop = false;
  Instruction.noopration():noop = true, useModifier = false, useLable = false,defultModifier = 0, run = _noop;
}

List <Instruction> instructionSet = [];

_noop(a,b,c){}
