part of rogue;

class Settings {
  static String _dataPath;
  static int _strengthMod;
  static int _constMod;
  static int _luckMod;

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

  static void loadSettings() {
    Map<String, dynamic> settings = JSON.decode(new io.File('lib/src/config/config.json').readAsStringSync());

    _dataPath = settings['data-path'];
    _strengthMod = settings['modifiers']['strength'];
    _constMod = settings['modifiers']['constitution'];
    _luckMod = settings['modifiers']['luck'];
  }
}