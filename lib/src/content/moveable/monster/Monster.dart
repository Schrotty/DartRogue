part of rogue;

class Monster extends Moveable {
  int _attackPoints;
  int _grantedXP;
  List loot;
  String icon;

  Monster.fromMap(Map data) {
    // monster just have basic stats, some are stronger, some weaker => getting stronger by scaling with their level
    this.level = data['lvl'];
    double scale = pow(Settings.monsterScaling, this._lvl);

    this.name = data['name'];
    this.currHealth = (data['hp'] * scale).ceil();
    this.maxHealth = (data['hp'] * scale).ceil();
    this.attackPoints = (data['attack'] * scale).ceil();
    this.speed = data['speed'];
    this.grantedXP = (data['grantedXP'] * scale).ceil();
    this.loot = [];
  }

  int calcDamage() {
    return _attackPoints;
  }

  get attackPoints => this._attackPoints;

  set attackPoints(int attack) => this._attackPoints = attack;

  get grantedXP => this._grantedXP;

  set grantedXP(int xp) => this._grantedXP = xp;
}