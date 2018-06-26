part of rogue;

/// Class representing a [Monster].
class Monster extends Moveable {
  int attackPoints;
  int grantedXP;

  bool isBoss;
  bool isEndboss = false;

  Field patrolPoint;
  Field spawn;

  /// Create an empty [Monster].
  Monster() {
    // empty
  }

  /// Create a new [Monster] based on [data].
  Monster.fromMap(Map data) {
    // monster just have basic stats, some are stronger, some weaker => getting stronger by scaling with their level
    this.lvl = data['lvl'];
    double scale = pow(Settings.monsterScaling, this.lvl - 1);

    this.name = data['name'];
    this.currHealth = ((data['hp'] + 2) * scale).ceil();
    this.maxHealth = ((data['hp'] + 2) * scale).ceil();
    this.attackPoints = (data['attack'] * scale).ceil();
    this.speed = data['speed'];
    this.grantedXP = (data['grantedXP'] * scale).ceil();
    this.stage = data['stage'];
    this.skin = "demon";

    if (data.containsKey('static')) {
      this.isStatic = data['static'];
    }

    if (data.containsKey('endboss')) {
      this.isEndboss = data['endboss'];
    }

    if (data.containsKey('loot')) {
      if (data['loot'].containsKey('helmet'))
        loot['helmets'] = data['loot']['helmet'];
      if (data['loot'].containsKey('chest'))
        loot['chests'] = data['loot']['chest'];
      if (data['loot'].containsKey('gloves'))
        loot['gloves'] = data['loot']['gloves'];
      if (data['loot'].containsKey('legs'))
        loot['legs'] = data['loot']['legs'];
      if (data['loot'].containsKey('boots'))
        loot['boots'] = data['loot']['boots'];

      if (data['loot'].containsKey('sword'))
        loot['swords'] = data['loot']['sword'];
      if (data['loot'].containsKey('axe')) loot['axes'] = data['loot']['axe'];
      if (data['loot'].containsKey('dagger'))
        loot['daggers'] = data['loot']['dagger'];
      if (data['loot'].containsKey('hammer'))
        loot['hammers'] = data['loot']['hammer'];

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

  /// Calculates the damage the player will take from an attack.
  int calcDamage() {
    int dmg = attackPoints - player.armor / 3;
    return dmg > 1 ? dmg.ceil() : 1;
  }

  /// Moves the [Monster].
  ///
  /// Also checks each turn if the [Player] was detected. In this case
  /// the [Monster] will calculate a path to attack the [Player].
  move() {
    super.move();

    if (_detectPlayer()) {
      calcPath(player.position.accessibleNeighbour);
    }

    if (patrolPoint == null &&
        levels[player.currentStage].patrolPoints.isNotEmpty) {
      spawn = position;

      patrolPoint = levels[player.currentStage].patrolPoints.removeLast();
    }

    if (start == null) {
      if (patrolPoint == null) return;
      calcPath(position.id == spawn.id ? patrolPoint : spawn);
    }
  }

  /// Is [Player] in detection range?
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
}