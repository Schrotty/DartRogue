part of rogue;

class Skill {
  String _name;
  double _skillMod;
  int _useableCount;
  int _useableCountMax;

  get isUseable => useableCount > 0;

  get name => _name;

  get skillMod => _skillMod;

  get useableCount => _useableCount;
  get useableCountMax => _useableCountMax;

  Skill.fromJson(Map data) {
    this._name = data['name'];
    this._skillMod = data['mod'];

    if (data.containsKey("useableCount")) {
      this._useableCount = data['useableCount'];
      this._useableCountMax = data['useableCount'];
    }
  }

  use() {
    _useableCount -= 1;
  }
}
