part of rogue;

class Settings {
  static String _dataPath = 'data/';
  static String _imgPath = 'img/';
  static String _weaponImgPath = 'img/items/weapon/';
  static String _armorImgPath = 'img/items/armor/';

  static int _strengthMod = 1;
  static int _constMod = 2;
  static int _luckMod = 2;

  static double _monsterScaling = 1.3;
  static double _playerStatScaling = 1.15;
  static double _playerXpScaling = 1.3;

  static const gameRefreshTime = 16;
  static const movementRefreshTime = 320;

  static String getDataPath() {
    return _dataPath;
  }

  static String getImgPath() {
    return _imgPath;
  }

  static String getWeaponImgPath() {
    return _weaponImgPath;
  }

  static String getArmorImgPath() {
    return _armorImgPath;
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
}