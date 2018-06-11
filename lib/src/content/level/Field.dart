part of rogue;

class Field {
  int _id;
  int _row;
  int _col;
  bool _accessible;
  String _style;
  int _stageId;
  int _monsterId;

  Field.create(bool accessible, String style, String id, int row, int col, [this._stageId, this._monsterId]) {
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

  get monsterId => _monsterId;

  set monsterId(int id) => _monsterId = id;

  get stageId => _stageId;

  get row => _row;

  get col => _col;

}
