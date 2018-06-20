part of rogue;

class Field {
  int _id;
  int _row;
  int _col;
  bool _accessible;
  String _style;
  int _stageId;
  int _monsterId;
  bool _treasure;

  Field top;
  Field left;
  Field right;
  Field bottom;

  DivElement element;

  Field.create(bool accessible, String style, String id, int row, int col, [this._stageId, this._monsterId]) {
    _accessible = accessible;
    _style = style;
    _id = int.parse(id.substring(5));
    _row = row;
    _col = col;
  }

  Field.empty(int id) {
    _accessible = false;
    _style = "none";
    _id = id;
    _row = -1;
    _col = -1;
    _monsterId = -1;
  }

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

  List<Field> _neighbours() {
    List<Field> fs = new List();
    if (hasTop) fs.add(top);
    if (hasLeft) fs.add(left);
    if (hasRight) fs.add(right);
    if (hasBottom) fs.add(bottom);

    return fs;
  }

  get id => _id;

  get isAccessible => _accessible;

  set accessible(bool accessible) => this._accessible = accessible;

  get style => _style;

  get monsterId => _monsterId;

  set monsterId(int id) => _monsterId = id;

  get stageId => _stageId;

  get row => _row;

  get col => _col;

  get hasTreasure => _treasure;

  set treasure(bool treasure) => _treasure = treasure;

  get hasTop => top != null;
  get hasLeft => left != null;
  get hasRight => right != null;
  get hasBottom => bottom != null;

  Field get accessibleNeighbour => _neighbours().firstWhere((f) => f.isAccessible, orElse: () => null);

  String toString() {
    String result = id;
    if (top != null) result = top.id;
    if (left != null) result = left.id;
    if (right != null) result = right.id;
    if (bottom != null) result = bottom.id;

    return result;
  }
}
