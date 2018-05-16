part of rogue;

class Settings {
  static String _dataPath = 'data/';
  static int _strengthMod = 1;
  static int _constMod = 3;
  static int _luckMod = 2;

  static double _monsterScaling = 1.2;
  static double _playerStatScaling = 1.1;
  static double _playerXpScaling = 1.3;

  static const _refreshRate = 1/60; // 60Hz => 16,67ms

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

  static get refreshRate => _refreshRate;
}