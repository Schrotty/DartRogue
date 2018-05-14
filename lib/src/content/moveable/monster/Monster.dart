part of rogue;

class Monster extends Moveable {
  int _attackPoints;
  List loot;
  String icon;

  Monster.fromMap(Map data) {
    this.name = data['name'];
    this.currHealth = data['hp'];
    this.maxHealth = data['hp'];
    this.attackPoints = data['attack'];
    this.loot = [];
  }

  int calcDamage() {
    return _attackPoints;
  }

  get attackPoints => _attackPoints;

  set attackPoints(int attack) => this._attackPoints = attack;
}
