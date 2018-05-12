import 'config/Settings.dart';
import 'content/Storage.dart';

main () {
  Settings.loadSettings();
  buildStorage();

  print(player.health);
  player.takeDamage(5);
  print(player.health);
  player.usePotion(0);
  print(player.health);
}