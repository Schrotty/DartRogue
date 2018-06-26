part of rogue;

/// Create an armor.
Item createArmor(Map data, [int quality = -1, String type]) => new Item.fromJson(data, quality, "Armor", type);

/// Create a weapon.
Item createWeapon(Map data, [int quality = -1, String type]) => new Item.fromJson(data, quality, "Weapon", type);

/// Create a potion.
Item createPotion(Map data, [int quality = -1]) => new Item.fromJson(data, quality, "Potion", "Potion");