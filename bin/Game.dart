import 'package:rogue/rogue.dart';
import 'package:start/start.dart';

main() {
  start(host: '0.0.0.0', port: 80).then((Server app) {
    app.static('../build/web');
  });

  /*Settings.loadSettings();
  buildStorage();

  print("==== Player ====");
  print("Health: ${player.health}/ ${player.maxHealth}\r\n");

  print("=== Attributes ===");
  print("Damage: ${player.damage}");
  print("Armor: ${player.armor}");
  print("Crit. chance: ${player.critChance}%");
  print("Crit. multi.: ${player.critMulti}");
  print("Crit. damage: ${player.critDamage}\r\n");

  print("=== Inventory ===");
  print("Helmet: ${player.helmet.name} (${player.helmet.value})");
  print("Chest: ${player.chest.name} (${player.chest.value})");
  print("Gloves: ${player.gloves.name} (${player.gloves.value})");
  print("Legs: ${player.legs.name} (${player.legs.value})");
  print("Boots: ${player.boots.name} (${player.boots.value})");
  print("Weapon: ${player.weapon.name} (${player.weapon.value})\r\n");

  print("=== Mods ===");
  print("HealthMod: ${player.healthMod}");
  print("ArmorMod: ${player.armorMod}");
  print("DamageMod: ${player.damageMod}");
  print("LuckMod: ${player.luckMod}");
  print("CritMod: ${player.critMod}");
  print("CritDamage: ${player.critDamageMod}\r\n");

  print("==== Storage ====");
  print("=== Armors ===");
  armors.forEach((type, map) => map.forEach((id, arms) => arms.forEach((arm) {
        print("${arm.name} (${arm.value})");
      })));

  print("\r\n=== Weapons ===");
  weapons.forEach((type, map) => map.forEach((id, weas) => weas.forEach((wea) {
        print("${wea.name} (${wea.value})");
      })));

  print("\r\n=== Potions ===");
  potions.forEach((type, pot) {
    print("${pot.name} (${pot.value})");
  });

  print("\r\n==== Combat ====");
  var endboss = monsters[666];
  var longsword = weapons['swords'][1][0];

  print("Boss Health: ${endboss.hitPoints}/${endboss.maxHitPoints}");
  print("Player Health: ${player.health}/${player.maxHealth}");
  print("Player attacks!");
  endboss.takeDamage(player.calcDamage());
  print("Boss Health: ${endboss.hitPoints}/${endboss.maxHitPoints}");
  print("\nPlayer equips epic Longsword!\n${longsword}");
  player.weapon = longsword;
  print("Player attacks!");
  endboss.takeDamage(player.calcDamage());
  print("Boss Health: ${endboss.hitPoints}/${endboss.maxHitPoints}");
  print("Boss attacks!");
  player.takeDamage(endboss.attackPoints);
  print("Player Health: ${player.health}/${player.maxHealth}");
  print("Player uses a small potion!");
  player.usePotion(0); // 25% potion
  print("Player Health: ${player.health}/${player.maxHealth}");
  print("Player attacks!");
  endboss.takeDamage(player.calcDamage());
  print("Boss Health: ${endboss.hitPoints}/${endboss.maxHitPoints}");
  print("Boss attacks!");
  player.takeDamage(endboss.attackPoints);
  print("Player Health: ${player.health}/${player.maxHealth}");*/
}
