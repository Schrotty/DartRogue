part of rogue;

class Monster extends Moveable {
  int _attackPoints;
  int _grantedXP;
  bool _boss;
  Field _patrolPoint;
  Field _spawn;
  bool _patrols;

  Monster.fromMap(Map data) {
    // monster just have basic stats, some are stronger, some weaker => getting stronger by scaling with their level
    this.level = data['lvl'];
    double scale = pow(Settings.monsterScaling, this._lvl - 1);

    this.name = data['name'];
    this.currHealth = (data['hp'] * scale).ceil();
    this.maxHealth = (data['hp'] * scale).ceil();
    this.attackPoints = (data['attack'] * scale).ceil();
    this.speed = data['speed'];
    this.grantedXP = (data['grantedXP'] * scale).ceil();
    this.stage = data['stage'];

    if (data.containsKey('loot')) {
      if (data['loot'].containsKey('helmet')) _loot['helmet'] = data['loot']['helmet'];
      if (data['loot'].containsKey('chest')) _loot['chest'] = data['loot']['chest'];
      if (data['loot'].containsKey('gloves')) _loot['gloves'] = data['loot']['gloves'];
      if (data['loot'].containsKey('legs')) _loot['legs'] = data['loot']['legs'];
      if (data['loot'].containsKey('boots')) _loot['boots'] = data['loot']['boots'];
      if (data['loot'].containsKey('weapon')) _loot['weapon'] = data['weapon']['weapon'];
    }

    skins = new List<String>()
      ..add("monster-up")
      ..add("monster-right")
      ..add("monster-left")
      ..add("monster-down");

    skin = "monster";
  }

  Monster() {}

  int calcDamage() {
    return _attackPoints;
  }

  _die() {
    print("${this.name} died!");
    this._alive = false;
  }

  move() {
    super.move();

    if (_patrolPoint == null && levels[player.currentStage].patrolPoints.isNotEmpty) {
      _spawn = _position;

      _patrolPoint = levels[player.currentStage].patrolPoints.removeLast();
    }

    if (start == null) {
      if (_patrolPoint == null) return;
      calcPath(_position.id == _spawn.id ? _patrolPoint : _spawn);
    }
  }

  get attackPoints => this._attackPoints;

  set attackPoints(int attack) => this._attackPoints = attack;

  get grantedXP => this._grantedXP;

  set grantedXP(int xp) => this._grantedXP = xp;

  bool get isBoss => _boss;

  set isBoss(bool isBoss) => _boss = isBoss;

  Field get patrolPoint => _patrolPoint;

  set patrolPoint(Field patrolPoint) => _patrolPoint = patrolPoint;

  toString() {
    return this.name;
  }
}
