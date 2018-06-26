part of rogue;

/// Class representing a single field in a [Level].
class Field {
  int id;
  int row;
  int col;
  int stageId;
  int monsterId;
  String style;
  bool isAccessible;
  bool hasTreasure;
  bool isMonsterDrop;
  bool isExit;

  // related div element
  DivElement element;

  // neighbours
  Field top;
  Field left;
  Field right;
  Field bottom;

  get hasTop => top != null;
  get hasLeft => left != null;
  get hasRight => right != null;
  get hasBottom => bottom != null;

  /// Create a new [Field].
  Field.create(bool accessible, String style, String id, int row, int col, [this.stageId, this.monsterId]) {
    this.isAccessible = accessible;
    this.style = style;
    this.id = int.parse(id.substring(5));
    this.row = row;
    this.col = col;
  }

  /// Create an empty [Field].
  Field.empty(int id) {
    this.isAccessible = false;
    this.style = "none";
    this.id = id;
    this.row = -1;
    this.col = -1;
    this.monsterId = -1;
  }

  /// Is [pot] a neighbour of this?
  bool isNeighbour(Field pot) {
    if (pot != null) {
      if (hasTop) {
        if (top.id == pot.id) return true;
      }

      if (hasLeft) {
        if (left.id == pot.id) return true;
      }

      if (hasRight) {
        if (right.id == pot.id) return true;
      }

      if (hasBottom) {
        if (bottom.id == pot.id) return true;
      }
    }

    return false;
  }

  /// Returns a List of [Field].
  List<Field> _neighbours() {
    List<Field> fs = new List();
    if (hasTop) fs.add(top);
    if (hasLeft) fs.add(left);
    if (hasRight) fs.add(right);
    if (hasBottom) fs.add(bottom);

    return fs..shuffle();
  }

  /// Return a random accessible neighbour of this [Field].
  Field get accessibleNeighbour => _neighbours().firstWhere((f) => f.isAccessible, orElse: () => null);
}
