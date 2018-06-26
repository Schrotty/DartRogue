part of rogue;

/// Class used for the [Pathfinding].
class Node implements Comparable {
  Field field;
  Node predecessor;

  int priority;
  int _farCost = 0;
  double _compCost = 0.0;

  List<Node> successors = new List<Node>();

  get X => field.col;
  get Y => field.row;

  get g => _farCost;
  set g(int g) => _farCost = g;

  get f => _compCost;
  set f(double f) => _compCost = f;

  /// Create a new [Node] for [field].
  Node.create(Field field, [int priority = 0]) {
    this.field = field;
    this.priority = priority;
  }

  /// Compares this with [other].
  @override
  int compareTo(other) {
    if (this.f == (other as Node).f) return 0;
    if (this.f < (other as Node).f) return -1;

    return 1;
  }

  /// Is this equal to [n]?
  bool isEqual(Node n) {
    return this.field.id == n.field.id;
  }
}