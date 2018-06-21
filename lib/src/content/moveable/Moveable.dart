part of rogue;

abstract class Moveable {
  int _id;
  String _name;
  int _lvl;
  int _maxHealth;
  int _currHealth;
  int _speed;
  Map<String, int> _loot = new Map();
  bool _alive = true;
  Field _position;
  Node start;
  Field _target;
  int direction;
  String skin;
  List<String> skins;
  int stage;

  static final int UP = 0;

  static final int RIGHT = 1;

  static final int LEFT = 2;

  static final int DOWN = 3;

  takeDamage(int damage) {
    if ((_currHealth - damage) <= 0) {
      _currHealth = 0;
    } else {
      _currHealth -= damage;
    }

    if (_currHealth <= 0) {
      _die();
    }
  }

  int calcDamage();

  _die();

  move() {
    if (start != null && start.predecessor != null) {
      if (start.predecessor.field.isAccessible) {
        if (!(this is Player) && _detectLoop()) {
          calcPath(_position.accessibleNeighbour);
        }

        int col = start.field.col;
        int row = start.field.row;

        _position.accessible = true;
        _position = start.predecessor.field;
        _position.accessible = false;

        start = start.predecessor;

        if (start.field.id == _target.id) {
          start = null;
        }

        if (col > _position.col) skin = skins[LEFT];
        if (col < _position.col) skin = skins[RIGHT];

        if (row > _position.row) skin = skins[UP];
        if (row < _position.row) skin = skins[DOWN];
        return;
      }

      calcPath(_target);
    }
  }

  calcPath(Field target) {
    _target = target;

    _position.accessible = true;
    start = new Pathfinding().calcPath(_position, target);
  }

  bool _detectLoop() {
    return start.predecessor == start || start.predecessor.predecessor == start;
  }

  int get id => _id;

  set(int id) => _id = id;

  get name => this._name;

  set name(String name) => this._name = name;

  get level => this._lvl;

  set level(int lvl) => this._lvl = lvl;

  get maxHealth => this._maxHealth;

  set maxHealth(int health) => this._maxHealth = health;

  get currHealth => this._currHealth;

  set currHealth(int health) => this._currHealth = health;

  get currHealthPercent => (this._currHealth / this.maxHealth) * 100;

  get loot => _loot;

  get speed => this._speed;

  set speed(int speed) => this._speed = speed;

  get isAlive => _alive;

  Field get position => _position;

  set position(Field pos) => _position = pos;
}
