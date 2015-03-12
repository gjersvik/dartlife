part of dartlife;

class Lifeform{
  Uint8ClampedList dna;
  
  /** The cpu conectec to this lifeform. 
   * 
   * It may be null and that means that the lifeform is dead.
   */
  Cpu cpu;
  
  double energy = 10000000.0;
  
  Lifeform(this.dna);
}