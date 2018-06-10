part of rogue;

abstract class Moveable {
  String _name;
  int _lvl;
  int _maxHealth;
  int _currHealth;
  int _speed;
  Map<String, int> _loot = new Map();
  bool _alive = true;
  Field _position;

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

  move(Field position) {
    _position = position;
  }

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

  get position => _position;
}
