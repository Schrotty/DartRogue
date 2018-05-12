import '../config/Settings.dart';
import 'dart:convert';
import 'dart:io';
import 'item/Item.dart';
import 'item/ItemGenerator.dart';
import 'item/Quality.dart';
import 'monster/Monster.dart';
import 'monster/MonsterGenerator.dart';
import 'player/Player.dart';

Player player;

Map<String, Map<int, List<Item>>> weapons = new Map();
Map<String, Map<int, List<Item>>> armors = new Map();
Map<int, Item> potions = new Map();
Map<int, Monster> monsters = new Map();

void buildStorage() {
  _initMaps();

  _buildWeapons();
  _buildArmors();
  _buildPotions();
  _buildMonsters();

  _buildPlayer();
}

void _initMaps() {
  weapons = new Map<String, Map<int, List<Item>>>();
  weapons['daggers'] = new Map<int, List<Item>>();
  weapons['swords'] = new Map<int, List<Item>>();
  weapons['axes'] = new Map<int, List<Item>>();
  weapons['hammers'] = new Map<int, List<Item>>();

  // armor items
  armors = new Map<String, Map<int, List<Item>>>();
  armors['helmets'] = new Map<int, List<Item>>();
  armors['chests'] = new Map<int, List<Item>>();
  armors['gloves'] = new Map<int, List<Item>>();
  armors['legs'] = new Map<int, List<Item>>();
  armors['boots'] = new Map<int, List<Item>>();
}

void _buildWeapons() {
  _buildWeaponType("daggers");
  _buildWeaponType("swords");
  _buildWeaponType("axes");
  _buildWeaponType("hammers");
}

void _buildArmors() {
  _buildArmorType("helmets");
  _buildArmorType("chests");
  _buildArmorType("gloves");
  _buildArmorType("legs");
  _buildArmorType("boots");
}

void _buildPlayer() {
  player = new Player.fromMap(JSON.decode(new File(Settings.getDataPath() + 'player/player.json').readAsStringSync())[0]);
}

void _buildWeaponType(String type) {
  JSON.decode(new File('../data/item/weapons/$type.json').readAsStringSync()).forEach((Map w) {
    weapons[type][w['id']] = new List();
    if (w.containsKey('multi')) {
      Qualities.forEach((q) => weapons[type][w['id']].add(createWeapon(w, Qualities.indexOf(q))));
      return;
    }

    weapons[type][w['id']].add(createWeapon(w));
  });
}

void _buildArmorType(String type) {
  JSON.decode(new File(Settings.getDataPath() + 'item/armor/$type.json').readAsStringSync()).forEach((Map a) {
    armors[type][a['id']] = new List();
      if (a.containsKey('multi')) {
        Qualities.forEach((q) => armors[type][a['id']].add(createArmor(a, Qualities.indexOf(q))));
        return;
    }

    armors[type][a['id']].add(createArmor(a));
  });
}

void _buildPotions() {
  JSON.decode(new File(Settings.getDataPath() + 'item/potions.json').readAsStringSync()).forEach((Map p) {
    if (p.containsKey('multi')) {
      Qualities.forEach((q) => potions[p['id']] = createPotion(p, Qualities.indexOf(q)));
      return;
    }

    potions[p['id']] = createPotion(p);
  });
}

void _buildMonsters() {
  JSON.decode(new File(Settings.getDataPath() + 'monster/monster.json').readAsStringSync()).forEach((m) => monsters[m['id']] = createMonster(m));
}