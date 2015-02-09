part of dartlife;

class Stack<T>{
  List _data = new List();
  bool get isNotEmpty => _data.isNotEmpty;
  
  T pop(){
    if(_data.isEmpty){
      return null;
    }
    return _data.removeLast();
  }
  push(T value) =>_data.add(value);
}