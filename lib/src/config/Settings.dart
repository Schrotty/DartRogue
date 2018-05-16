part of rogue;

class Settings {
  static String _dataPath = 'data/';
  static int _strengthMod = 1;
  static int _constMod = 3;
  static int _luckMod = 2;

  static String getDataPath() {
    return _dataPath;
  }

  static int getStrengthMod() {
    return _strengthMod;
  }

  static int getConstMod() {
    return _constMod;
  }

  static int getLuckMod() {
    return _luckMod;
  }

  static get monsterScaling => _monsterScaling;

  static get playerStatScaling => _playerStatScaling;

  static get playerXpScaling => _playerXpScaling;

  static void loadSettings() {
    Map<String, dynamic> settings = JSON.decode(new io.File('lib/src/config/config.json').readAsStringSync());

    _dataPath = settings['data-path'];
    _strengthMod = settings['modifiers']['strength'];
    _constMod = settings['modifiers']['constitution'];
    _luckMod = settings['modifiers']['luck'];
    _monsterScaling = settings['balancing']['monsterScale'];
    _playerStatScaling = settings['balancing']['playerStatScale'];
    _playerXpScaling = settings['balancing']['playerXpScale'];
  }
}