import 'content/Storage.dart';
import 'content/item/Item.dart';

main () async {
  await buildStorage();

  weapons.forEach((int key, List<Item> items) => items.forEach((w) => print(w)));
  armors.forEach((int key, List<Item> items) => items.forEach((w) => print(w)));
  potions.forEach((int key, List<Item> items) => items.forEach((w) => print(w)));
}