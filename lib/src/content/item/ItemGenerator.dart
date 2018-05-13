part of rogue;

Item createArmor(Map data, [int quality = -1]) => new Item.fromJson(data, quality);
Item createWeapon(Map data, [int quality = -1]) => new Item.fromJson(data, quality);
Item createPotion(Map data, [int quality = -1]) => new Item.fromJson(data, quality);