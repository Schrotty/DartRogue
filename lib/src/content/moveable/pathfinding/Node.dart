part of rogue;

class Node implements Comparable {
  Field _field;
  Node _predecessor;
  int _priority;

  int _farCost = 0;
  double _compCost = 0.0;

  List<Node> _successors = new List<Node>();

  Node.create(Field field, [int priority = 0]) {
    _field = field;
    _priority = priority;
  }

  Field get field => _field;

  set field(Field field) => _field = field;

  get priority => _priority;

  set priority(int priority) => _priority = priority;

  get predecessor => _predecessor;

  set predecessor(Node pre) => _predecessor = pre;

  get X => _field.col;

  get Y => _field.row;

  get g => _farCost;

  set g(int g) => _farCost = g;

  get f => _compCost;

  set f(double f) => _compCost = f;

  List<Node> get successors => _successors;

  set successors(List<Node> s) => _successors = s;

  @override
  int compareTo(other) {
    if (this.f == (other as Node).f) return 0;
    if (this.f < (other as Node).f) return -1;

    return 1;
  }

  bool isEqual(Node n) {
    return this._field.id == n.field.id;
  }
}