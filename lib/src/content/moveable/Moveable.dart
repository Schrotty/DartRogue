part of rogue;

abstract class Moveable {
  String _name;
  int _lvl;
  int _maxHealth;
  int _currHealth;
  int _speed;

  takeDamage(int damage) {
    this._currHealth -= damage;
    if (_currHealth <= 0) {
      _die();
    }
  }

  int calcDamage();

  _die() {
    print("$name died!");
  }

  move(int x, int y) {
    print("Not implemented yet!");
  }

  get name => this._name;

  set name(String name) => this._name = name;

  get level => this._lvl;

  set level(int lvl) => this._lvl = lvl;

  get maxHealth => this._maxHealth;

  set maxHealth(int health) => this._maxHealth = health;

  get currHealth => this._currHealth;

  set currHealth(int health) => this._currHealth = health;

  get speed => this._speed;

  set speed(int speed) => this._speed = speed;
}
