part of dartlife.test;

Cpu getCpu(List<Op> code) => new Cpu(new Lifeform.fromOps(code));

Cpu runCpu(Cpu cpu){
  while(cpu.tick());
  return cpu;
}

Cpu cpuRun(List<Op> code) => runCpu(getCpu(code));

Matcher cpuHasRegisters(regs) => new _CpuRegester(orderedEquals(regs));

class _CpuRegester extends CustomMatcher {
  _CpuRegester(matcher) : super('Cpu with regersters that is', 'registeres', matcher);
  featureValueOf(Cpu actual) => actual.r.take(3);
}