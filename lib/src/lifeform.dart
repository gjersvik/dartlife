part of dartlife;

class Lifeform{
  Uint8ClampedList dna;
  Lifeform(this.dna);
  Lifeform.fromOps(Iterable<Op> ops){
    dna = new Uint8ClampedList.fromList(ops.map((Op op) => op.index).toList());
  }
}