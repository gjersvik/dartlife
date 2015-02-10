part of dartlife;

class Lifeform{
  Uint8ClampedList dna;
  
  /** The cpu conectec to this lifeform. 
   * 
   * It may be null and that means that the lifeform is dead.
   */
  Cpu cpu;
  
  Lifeform(this.dna);
  Lifeform.fromOps(Iterable<Op> ops){
    dna = new Uint8ClampedList.fromList(ops.map((Op op) => op.index).toList());
  }
}