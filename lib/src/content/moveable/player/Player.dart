part of rogue;

class Player extends Moveable {
  int _strength;
  int _constitution;
  int _luck;
  int _critChance;
  double _critDamage;
  int _baseXp;
  int _gainedXp;
  int _neededXp;

  Item helmet;
  Item chest;
  Item gloves;
  Item legs;
  Item boots;

  Item weapon;

  Map<int, int> pots = new Map();

  Player.fromMap(Map data) {
    if (data.containsKey('attributes')) {
      if (data['attributes'].containsKey('strength'))
        _strength = data['attributes']['strength'];
      if (data['attributes'].containsKey('constitution'))
        _constitution = data['attributes']['constitution'];
      if (data['attributes'].containsKey('luck'))
        _luck = data['attributes']['luck'];
    }

    if (data.containsKey('talents')) {
      if (data['talents'].containsKey('crit-chance'))
        _critChance = data['talents']['crit-chance'];
      if (data['talents'].containsKey('crit-damage-mod'))
        _critDamage = data['talents']['crit-damage-mod'];
    }

    if (data.containsKey('armor')) {
      if (data['armor'].containsKey('helmet'))
        helmet = armors['helmets'][data['armor']['helmet']][0];
      if (data['armor'].containsKey('chest'))
        chest = armors['chests'][data['armor']['chest']][0];
      if (data['armor'].containsKey('gloves'))
        gloves = armors['gloves'][data['armor']['gloves']][0];
      if (data['armor'].containsKey('legs'))
        legs = armors['legs'][data['armor']['legs']][0];
      if (data['armor'].containsKey('boots'))
        boots = armors['boots'][data['armor']['boots']][0];
    }

    if (data.containsKey('weapon')) {
      weapon = weapons[data['weapon'][0]][data['weapon'][1]][0];
    }

    if (data.containsKey('potions')) {
      pots[0] = data['potions'][0];
      pots[1] = data['potions'][1];
      pots[2] = data['potions'][2];
    }

    _maxHealth = data['health'];
    _speed = data['speed'];
    _currHealth = maxHealth;
    _lvl = 1;
    _baseXp = data['baseXp'];
    _gainedXp = 35;
    _neededXp = data['baseXp'];
  }

  int calcDamage() {
    var rand = new Random().nextInt(101);
    if (rand <= critChance) {
      return critDamage;
    }

    return damage;
  }

  // TODO monsters must give xp less than two full lvl!
  gainXP(int xp) {
    this._gainedXp += xp;
    if (_gainedXp >= _neededXp) {
      _levelUp();
    }
  }

  _levelUp() {
    this._lvl = ++this._lvl;
    double scale = Settings.playerStatScaling;
    this._neededXp +=
        (_baseXp * pow(Settings.playerXpScaling, _lvl - 1)).ceil();
    this._maxHealth = (this._maxHealth * scale).ceil();
    this._currHealth = _maxHealth; // restore to full health;
    this._constitution = (this._constitution * scale).ceil();
    this._strength = (this._strength * scale).ceil();
    this._luck = (this._luck * scale).ceil();
    // Balancing: maybe use different scaling for crit? we'll see...
    this._critChance = (this._critChance * scale).ceil();
    this._critDamage = (this._critDamage * scale);
  }

  void usePotion(int type) {
    if (pots[type] >= 1) {
      _currHealth += (maxHealth * (potions[type].value / 100)).round().floor();
      pots[type]--;
    }
  }

  int getGainedXpByCurrentLvl() {
    return _lvl == 1 ? gainedXp : gainedXp - _currentLvlXp();
  }

  int getNeededXpByCurrentLvl() {
    return _lvl == 1 ? neededXp : neededXp - _currentLvlXp();
  }

  int _currentLvlXp() {
    return neededXp -
        (_baseXp * pow(Settings.playerXpScaling, _lvl - 1)).ceil();
  }

  int getLeftXpUntilLvlUp() {
    return neededXp - gainedXp;
  }

  int _getMod(String type) {
    int value = 0;
    var items = [helmet, chest, gloves, legs, boots, weapon];

    items.forEach((item) {
      if (item.modifier.containsKey(type)) value += item.modifier[type];
    });

    return value;
  }

  /* === MODS === */
  get healthMod {
    return _getMod('health');
  }

  get armorMod {
    return _getMod('armor');
  }

  get damageMod {
    return _getMod('damage');
  }

  get luckMod {
    return _getMod('luck');
  }

  get critMod {
    return _getMod('crit-chance');
  }

  get critDamageMod {
    return _getMod('crit-damage');
  }

  /* === ATTRIBUTES === */
  get maxHealth {
    return healthMod + (_maxHealth + (_constitution * Settings.getConstMod()));
  }

  get currHealth {
    return _currHealth > 0 ? _currHealth : 0;
  }

  set currHealth(int health) {
    this._currHealth = health;
    if (_currHealth > maxHealth) {
      _currHealth = maxHealth;
    }

    if (_currHealth <= 0) {
      _die();
    }
  }

  get armor {
    return armorMod +
        (helmet.value + chest.value + gloves.value + legs.value + boots.value);
  }

  get damage {
    return damageMod + (weapon.value + (_strength * Settings.getStrengthMod()));
  }

  get luck {
    return luckMod + (_luck * Settings.getLuckMod());
  }

  get critChance {
    return critMod + _critChance;
  }

  get critMulti {
    return critDamageMod + _critDamage;
  }

  get critDamage {
    return (critMulti * damage).round();
  }

  get currXpPercent => (this.getGainedXpByCurrentLvl() / this.getNeededXpByCurrentLvl()) * 100;

  // TODO mods missing?
  get strength => _strength;

  get constitution => _constitution;

  get gainedXp => _gainedXp;

  get neededXp => _neededXp;
}
