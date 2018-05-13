part of rogue;

class Monster {
  String name;
  // player = health - monster = hitpoints?
  int hitPoints;
  int maxHitPoints;
  int attackPoints;
  List loot;
  String icon;

  Monster.fromMap(Map data) {
    this.name = data['name'];
    this.hitPoints = data['hp'];
    this.maxHitPoints = data['hp'];
    this.attackPoints = data['attack'];
    this.loot = [];
  }

  takeDamage(int damage) {
    this.hitPoints -= damage;
    if (hitPoints <= 0) {
      _die();
    }
  }

  _die() {
    print("$name died!");
  }
}