part of rogue;

class Treasure {
  int _id;
  Map<String, int> treasureLoot = new Map();
  Map<int, int> treasurePotions = new Map();

  Treasure.build(Map data) {
    _id = data['id'];

    if (data.containsKey('helmet')) treasureLoot['helmets'] = data['helmet'];
    if (data.containsKey('chest')) treasureLoot['chests'] = data['chest'];
    if (data.containsKey('gloves')) treasureLoot['gloves'] = data['gloves'];
    if (data.containsKey('legs')) treasureLoot['legs'] = data['legs'];
    if (data.containsKey('boots')) treasureLoot['boots'] = data['boots'];

    if (data.containsKey('sword')) treasureLoot['swords'] = data['sword'];
    if (data.containsKey('axe')) treasureLoot['axes'] = data['axe'];
    if (data.containsKey('dagger')) treasureLoot['daggers'] = data['dagger'];
    if (data.containsKey('hammer')) treasureLoot['hammers'] = data['hammer'];

    if (data.containsKey('potions')) {
      treasurePotions[0] = data['potions'][0];
      treasurePotions[1] = data['potions'][1];
      treasurePotions[2] = data['potions'][2];
    }
  }

  get isEmpty => treasureLoot.isEmpty && treasurePotions.isEmpty;
}
