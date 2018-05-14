part of rogue;

abstract class Moveable {
  String name;
  int _maxHealth;
  int _currHealth;

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

  get maxHealth => this._maxHealth;

  set maxHealth(int health) => this._maxHealth = health;

  get currHealth => this._currHealth;

  set currHealth(int health) => this._currHealth = health;

}
