part of rogue;

class Level {
  int _id;

  Map<int, List<Field>> fields;
  List<SpawnPoint> restPlaces;
  List<SpawnPoint> monsterSpawnPoints;
}