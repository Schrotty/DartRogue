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
}