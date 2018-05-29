part of rogue;

Item createArmor(Map data, [int quality = -1, String type]) => new Item.fromJson(data, quality, "Armor", type);
Item createWeapon(Map data, [int quality = -1, String type]) => new Item.fromJson(data, quality, "Weapon", type);
Item createPotion(Map data, [int quality = -1]) => new Item.fromJson(data, quality, "Potion", "Potion");