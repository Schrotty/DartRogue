class Monster {
  String name;
  int hitPoints;
  List loot;
  String icon;

  Monster.fromMap(Map data) {
    this.name = data['name'];
    this.hitPoints = data['hp'];
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