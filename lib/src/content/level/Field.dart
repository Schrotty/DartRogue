part of rogue;

class Field {
  int _id;
  bool _accessible;

  Field.create(bool accessible, [String id]) {
    _accessible = accessible;
    _id = int.parse(id.substring(5));
  }

  get id => _id;

  get isAccessible => _accessible;

  set accessible(bool accessible) => this._accessible = accessible;
}
