part of dartlife;

class Label{
  final List<int> label;
  Label(this.label);
  factory Label.fromDna(List<int> code, i){
    List data = [];
    while(i < code.length && code[i] < 3){
      data.add(code[i]);
      i += 1;
    }
    return new Label(data);
  }
  
  get length => label.length;
  
  Label comp() => new Label(label.map((i){
    i += 1;
    if(i == 3){
      return 0;
    }
    return i;
  }).toList());
  
  int find(List<int> code, i){
    if(code.isEmpty || label.isEmpty){
      return -1;
    }
    var length = code.length - label.length + 1;
    for(;i < length;i += 1){
      if(code[i] > 2){
        continue;
      }
      for(var j = 0; j < label.length; j +=1){
        if(code[i + j] != label[j]){
          break;
        }
        if(j == label.length - 1){
          return i + j + 1;
        }
      }
    }
    return -1;
  }
  
  int get hashCode => label.length;
  
  bool operator == (Label other){
    if(hashCode != other.hashCode){
      return false;
    }
    
    for(var i = 0; i < label.length; i += 1){
      if(label[i] != other.label[i]){
        return false;
      }
    }
      
    return true;
  }
  
}