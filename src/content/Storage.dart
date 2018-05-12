import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'item/Item.dart';
import 'item/ItemGenerator.dart';
import 'item/Quality.dart';
import 'monster/Monster.dart';
import 'monster/MonsterGenerator.dart';

Map<int, List<Item>> weapons = new Map();
Map<int, List<Item>> armors = new Map();
Map<int, List<Item>> potions = new Map();
Map<int, Monster> monsters = new Map();

buildStorage() async {
  await _buildWeapons();
  await _buildArmors();
  await _buildPotions();
  await _buildMonsters();
}

Future<String> _loadWeaponsData() {
  return new File('../data/item/weapons.json').readAsString();
}

Future<String> _loadArmorsData() {
  return new File('../data/item/armors.json').readAsString();
}

Future<String> _loadPotionsData() {
  return new File('../data/item/potions.json').readAsString();
}

Future<String> _loadMonsterData() {
  return new File('../data/monster/monster.json').readAsString();
}

/* === ITEMS ===*/
_buildWeapons() async {
  JSON.decode(await _loadWeaponsData()).forEach((Map w) {
    weapons[w['id']] = new List();
    if (w.containsKey('multi')) {
      Qualities.forEach((q) => weapons[w['id']].add(createWeapon(w, Qualities.indexOf(q))));
      return;
    }

    weapons[w['id']].add(createWeapon(w));
  });
}

_buildArmors() async {
  JSON.decode(await _loadPotionsData()).forEach((Map a) {
    armors[a['id']] = new List();
    if (a.containsKey('multi')) {
      Qualities.forEach((q) => armors[a['id']].add(createArmor(a, Qualities.indexOf(q))));
      return;
    }

    armors[a['id']].add(createArmor(a));
  });
}

_buildPotions() async {
  JSON.decode(await _loadArmorsData()).forEach((Map p) {
    potions[p['id']] = new List();
    if (p.containsKey('multi')) {
      Qualities.forEach((q) => potions[p['id']].add(createPotion(p, Qualities.indexOf(q))));
      return;
    }

    potions[p['id']].add(createPotion(p));
  });
}

/* === Monster === */
_buildMonsters() async {
  JSON.decode(await _loadMonsterData()).forEach((m) => monsters[m['id']] = createMonster(m));
}