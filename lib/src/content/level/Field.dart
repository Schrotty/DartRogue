part of rogue;

class Field {
  int _id;
  int _row;
  int _col;
  bool _accessible;
  String _style;

  Field.create(bool accessible, String style, String id, int row, int col) {
    _accessible = accessible;
    _style = style;
    _id = int.parse(id.substring(5));
    _row = row;
    _col = col;
  }

  get id => _id;

  get isAccessible => _accessible;

  set accessible(bool accessible) => this._accessible = accessible;

  get style => _style;

  get row => _row;

  get col => _col;
}
