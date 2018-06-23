part of rogue;

class Monster extends Moveable {
  int _attackPoints;
  int _grantedXP;
  bool _boss;
  Field _patrolPoint;
  Field _spawn;

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
    this.skin = "demon";

    if (data.containsKey('static')) {
      this._static = data['static'];
    }

    if (data.containsKey('loot')) {
      if (data['loot'].containsKey('helmet')) _loot['helmets'] = data['loot']['helmet'];
      if (data['loot'].containsKey('chest')) _loot['chests'] = data['loot']['chest'];
      if (data['loot'].containsKey('gloves')) _loot['gloves'] = data['loot']['gloves'];
      if (data['loot'].containsKey('legs')) _loot['legs'] = data['loot']['legs'];
      if (data['loot'].containsKey('boots')) _loot['boots'] = data['loot']['boots'];

      if (data['loot'].containsKey('sword')) _loot['swords'] = data['loot']['sword'];
      if (data['loot'].containsKey('axe')) _loot['axes'] = data['loot']['axe'];
      if (data['loot'].containsKey('dagger')) _loot['daggers'] = data['loot']['dagger'];
      if (data['loot'].containsKey('hammer')) _loot['hammers'] = data['loot']['hammer'];

      if (data['loot'].containsKey('potions')) {
        pots[0] = data['loot']['potions'][0];
        pots[1] = data['loot']['potions'][1];
        pots[2] = data['loot']['potions'][2];
      }
    }

    if (data.containsKey('skin')) skin = data['skin'];

    skins = new List<String>()
      ..add(skin + "-up")
      ..add(skin + "-right")
      ..add(skin + "-left")
      ..add(skin + "-down");
  }

  Monster() {}

  int calcDamage() {
    int dmg = _attackPoints - player.armor / 5;
    return dmg > 1 ? dmg.ceil() : 1;
  }

  _die() {
    print("${this.name} died!");
    this._alive = false;
  }

  move() {
    super.move();

    if (_detectPlayer()) {
      calcPath(player.position.accessibleNeighbour);
    }

    if (_patrolPoint == null && levels[player.currentStage].patrolPoints.isNotEmpty) {
      _spawn = _position;

      _patrolPoint = levels[player.currentStage].patrolPoints.removeLast();
    }

    if (start == null) {
      if (_patrolPoint == null) return;
      calcPath(_position.id == _spawn.id ? _patrolPoint : _spawn);
    }
  }

  bool _detectPlayer() {
    List<Field> area = position._neighbours();
    for (Field f in area) {
      for (Field n in f._neighbours()) {
        if (n.isNeighbour(player.position)) {
          return true;
        }
      }
    }

    return false;
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
