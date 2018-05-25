part of rogue;

class Level {
  int _id;

  List<List<Field>> fields;
  List<SpawnPoint> restPlaces;
  List<SpawnPoint> monsterSpawnPoints;

  static Field clicked;

  Level.build() {
    fields = new List();

    int id = 0;
    for (int i = 0; i < 32; i++) {
      fields.add(new List<Field>());

      for (int t = 0; t < 32; t++) {
        fields[i].add(new Field.create(false, "tile-${id++}"));
      }
    }
  }

  Field getField(int id) {
    Field result = null;

    fields.forEach((row) {
      row.forEach((field) {
        if (field.id == id) {
          result = field;
          return;
        }
      });
    });

    return result;
  }
}