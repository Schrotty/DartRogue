import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'item/Item.dart';
import 'item/ItemGenerator.dart';
import 'monster/Monster.dart';
import 'monster/MonsterGenerator.dart';

Map<int, Item> weapons = new Map();
Map<int, Item> armors = new Map();
Map<int, Item> potions = new Map();
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
  JSON.decode(await _loadWeaponsData()).forEach((w) => weapons[w['id']] = createWeapon(w));
}

_buildArmors() async {
  JSON.decode(await _loadArmorsData()).forEach((a) => armors[a['id']] = createArmor(a));
}

_buildPotions() async {
  JSON.decode(await _loadPotionsData()).forEach((p) => potions[p['id']] = createArmor(p));
}

/* === Monster === */
_buildMonsters() async {
  JSON.decode(await _loadMonsterData()).forEach((m) => monsters[m['id']] = createMonster(m));
}