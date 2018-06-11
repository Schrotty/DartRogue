part of rogue;

Player player;
Monster attacker = new Monster();
int attackerId;
int monsterCount_DEBUG = 8;

Map<String, Map<int, List<Item>>> weapons = new Map();
Map<String, Map<int, List<Item>>> armors = new Map();
Map<int, Skill> skills = new Map();
Map<int, Item> potions = new Map();
Map<int, Map<int, Monster>> monsterList = new Map<int, Map<int, Monster>>();
Map<int, Monster> monstersLvl_0 = new Map();
Map<int, Monster> monstersLvl_1 = new Map();
Map<int, Monster> bosses = new Map();
List<Level> levels;

buildStorage() async {
  _initMaps().then((b) {
    _build();
  });
}

_build() async {
  await _buildLevel();
  await _buildWeapons();
  await _buildArmors();
  await _buildSkills();
  await _buildPotions();
  await _buildMonsters();
  await _buildBosses();
  await _buildPlayer();
}

Future<bool> _initMaps() async {
  weapons = new Map<String, Map<int, List<Item>>>();
  weapons['daggers'] = new Map<int, List<Item>>();
  weapons['swords'] = new Map<int, List<Item>>();
  weapons['axes'] = new Map<int, List<Item>>();
  weapons['hammers'] = new Map<int, List<Item>>();

  // armor items
  armors = new Map<String, Map<int, List<Item>>>();
  armors['helmets'] = new Map<int, List<Item>>();
  armors['chests'] = new Map<int, List<Item>>();
  armors['gloves'] = new Map<int, List<Item>>();
  armors['legs'] = new Map<int, List<Item>>();
  armors['boots'] = new Map<int, List<Item>>();

  levels = new List<Level>();

  return true;
}

_buildWeapons() async {
  await _buildWeaponType("daggers");
  await _buildWeaponType("swords");
  await _buildWeaponType("axes");
  await _buildWeaponType("hammers");
}

_buildArmors() async {
  await _buildArmorType("helmets");
  await _buildArmorType("chests");
  await _buildArmorType("gloves");
  await _buildArmorType("legs");
  await _buildArmorType("boots");
}

_buildMonsters() async {
  _buildMonstersPerLvl(0);
  _buildMonstersPerLvl(1);
  _buildMonstersPerLvl(2);
  _buildMonstersPerLvl(3);
  _buildMonstersPerLvl(4);
  _buildMonstersPerLvl(5);
  _buildMonstersPerLvl(6);
}

_buildPlayer() async {
  await _requestData(Settings.getDataPath() + 'player/player.json').then((response) {
    player = new Player.fromMap(JSON.decode(response).asMap()[0]);
  });
}

_buildWeaponType(String type) async {
  await _requestData(Settings.getDataPath() + 'item/weapons/$type.json').then((response) {
    Map w = JSON.decode(response).asMap();

    w.forEach((key, value) {
      weapons[type][value['id']] = new List();
      if (value.containsKey('multi')) {
        Qualities.forEach((q) {
          weapons[type][value['id']].add(createWeapon(w, Qualities.indexOf(q), type));
        });

        return;
      }

      weapons[type][value['id']].add(createWeapon(value));
    });
  });
}

_buildArmorType(String type) async {
  await _requestData(Settings.getDataPath() + 'item/armor/$type.json').then((response) {
    Map a = JSON.decode(response).asMap();

    a.forEach((key, value) {
      armors[type][value['id']] = new List();
      if (value.containsKey('multi')) {
        Qualities.forEach((q) {
          armors[type][value['id']].add(createArmor(value, Qualities.indexOf(q), type));
        });

        return;
      }

      armors[type][value['id']].add(createArmor(value));
    });
  });
}

_buildSkills() async {
  await _requestData(Settings.getDataPath() + 'skill/skills.json').then((response) {
    JSON.decode(response).forEach((s) {
      skills[s['id']] = createSkill(s);
    });
  });
}

_buildPotions() async {
  await _requestData(Settings.getDataPath() + 'item/potions.json').then((response) {
    Map p = JSON.decode(response).asMap();

    p.forEach((id, pot) => potions[id] = createPotion(pot));
  });
}

_buildMonstersPerLvl(int lvl) async {
  _requestData(Settings.getDataPath() + 'monster/monster.json').then((response) {
    Map<int, Monster> mnstr = new Map();
    JSON.decode(response).forEach((m) {
      if (lvl == m['stage']) {
        mnstr[m['id']] = createMonster(m);
      }
    });
    monsterList[lvl] = mnstr;
  });
}

_buildBosses() async {
  _requestData(Settings.getDataPath() + 'monster/bosses.json').then((response) {
    JSON.decode(response).forEach((m) {
      bosses[m['id']] = createMonster(m);
    });
  });
}

_buildLevel() async {
  var response = await _requestData(Settings.getDataPath() + 'level/levels.json');
  JSON.decode(response).asMap().forEach((int key, Map value) {
    levels.add(new Level.build(key, value));
  });
}

Future<String> _requestData(String url) async {
  return HttpRequest.getString(url);
}
