part of rogue;

/// Class representing the player character.
class Player extends Moveable {
  int _strength;
  int _constitution;
  int _luck;
  int _baseXp;
  int _gainedXp;
  int _neededXp;
  int _currentStage;
  int _highscorePoints;
  int _selectedPot = 0;

  double _critChance;
  double _critDamage;

  String _highscoreName;

  Item helmet;
  Item chest;
  Item gloves;
  Item legs;
  Item boots;
  Item weapon;
  Item currentInvtentoryItem;

  bool _inFight;
  bool _killedEndboss;

  List<Item> inventory;

  /// Create a new [Player] based on [data].
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

    maxHealth = data['health'];
    speed = data['speed'];
    _currHealth = maxHealth;
    lvl = 1;
    _baseXp = data['baseXp'];
    _gainedXp = 0;
    _neededXp = data['baseXp'];
    _currentStage = 0;
    _inFight = false;
    _highscorePoints = 0;
    inventory = new List();
    currentInvtentoryItem = null;

    skins = new List<String>()
      ..add("player-up")
      ..add("player-right")
      ..add("player-left")
      ..add("player-down");

    skin = "player-left";
  }

  /// Calculates the damage an enemy will take.
  int calcDamage([int skillMod]) {
    var rand = new Random().nextInt(101);
    if (rand <= critChance) {
      return (skillMod * critDamage).round();
    }

    return (skillMod * damage).round();
  }

  /// Gain [xp] experience points.
  gainXP(int xp) {
    this._gainedXp += xp;
    if (_gainedXp >= _neededXp) {
      _levelUp();
    }
  }

  /// Increase [Player] level.
  _levelUp() {
    this.lvl = ++this.lvl;
    double scale = Settings.playerStatScaling;
    this._neededXp +=
        (_baseXp * pow(Settings.playerXpScaling, lvl - 1)).ceil();
    this._constitution = (this._constitution * scale).ceil();
    this._strength = (this._strength * scale).ceil();
    this._luck = (this._luck * scale).ceil();
    this._critChance = (this._critChance * (scale - 0.08));
    this._critDamage = (this._critDamage * (scale + 9) / 10);
    this.maxHealth = (this.maxHealth * scale).ceil();
    this._currHealth = maxHealth; // restore to full health;
    skills.forEach((k, v) => v._useableCount =
        v.useableCountMax); // every skill is restored to max usability
  }

  /// Use a potion to heal the [Player].
  void usePotion(int type) {
    if (!hasFullHealth && pots[type] >= 1) {
      var potionHealth =
          (maxHealth * (potions[type].value / 100)).round().floor();

      if ((currHealth + potionHealth) > maxHealth) {
        currHealth = maxHealth;
      } else {
        currHealth += potionHealth;
      }

      pots[type]--;
    }
  }

  /// Equip [item].
  void equip(Item item) {
    inventory.remove(item);

    if (item.type == 0) {
      inventory.add(player.weapon);
      player.weapon = item;
    }

    if (item.type == 1) {
      inventory.add(player.helmet);
      player.helmet = item;
    }

    if (item.type == 2) {
      inventory.add(player.chest);
      player.chest = item;
    }

    if (item.type == 3) {
      inventory.add(player.gloves);
      player.gloves = item;
    }

    if (item.type == 4) {
      inventory.add(player.legs);
      player.legs = item;
    }

    if (item.type == 5) {
      inventory.add(player.boots);
      player.boots = item;
    }

    _sortInventory();
  }

  /// Drop [item].
  void drop(Item item) {
    inventory.remove(item);
  }

  /// Sort the players inventory.
  _sortInventory() {
    if (inventory.isNotEmpty)
      inventory.sort((a, b) => a.quality.compareTo(b.quality));
  }

  get gainedXpByCurrentLvl {
    return lvl == 1 ? gainedXp : gainedXp - _currentLvlXp();
  }

  get neededXpByCurrentLvl {
    return lvl == 1 ? neededXp : neededXp - _currentLvlXp();
  }

  /// Return the current experience points.
  int _currentLvlXp() {
    return neededXp -
        (_baseXp * pow(Settings.playerXpScaling, lvl - 1)).ceil();
  }

  get leftXpUntilLvlUp {
    return neededXp - gainedXp;
  }

  /// Return the modifier value of [type].
  int _getMod(String type) {
    int value = 0;
    var items = [helmet, chest, gloves, legs, boots, weapon];

    items.forEach((item) {
      if (item.modifier.containsKey(type)) value += item.modifier[type];
    });

    return value;
  }

  /* === MODS === */
  get strengthMod {
    return _getMod('strength');
  }

  get constitutionMod {
    return _getMod('constitution');
  }

  get luckMod {
    return _getMod('luck');
  }

  get healthMod {
    return _getMod('health');
  }

  get armorMod {
    return _getMod('armor');
  }

  get damageMod {
    return _getMod('damage');
  }

  get critMod {
    return _getMod('crit-chance');
  }

  get critDamageMod {
    return _getMod('crit-damage');
  }

  /* === ATTRIBUTES === */
  get maxHealth {
    return healthMod +
        (super.maxHealth +
            ((_constitution + constitutionMod) * Settings.getConstMod()));
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
    return damageMod +
        (weapon.value +
            ((_strength + strengthMod) * Settings.getStrengthMod()));
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

  get currXpPercent =>
      (this.gainedXpByCurrentLvl / this.neededXpByCurrentLvl) * 100;

  get luck => _luck + luckMod;

  get strength => _strength + strengthMod;

  get constitution => _constitution + constitutionMod;

  get gainedXp => _gainedXp;

  get neededXp => _neededXp;

  get currentStage => _currentStage;

  set currentStage(int stage) => _currentStage = stage;

  bool get inFight => _inFight;

  set fight(bool inFight) => _inFight = inFight;

  get selectedPot => _selectedPot;

  set selectedPot(int pot) => _selectedPot = pot;

  bool get hasFullHealth => (maxHealth - currHealth) == 0;

  get isInventoryFull => inventory.length >= 12;

  get highscorePoints => _highscorePoints;

  set highscorePoints(int p) => _highscorePoints = p;

  get highscoreName => _highscoreName;

  set highscoreName(String name) => _highscoreName = name;

  bool get killedEndboss => _killedEndboss;

  set killedEnboss(bool killedEndboss) => _killedEndboss = killedEndboss;
}
