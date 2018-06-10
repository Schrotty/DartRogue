part of rogue;

class Level {
  int _id;

  Field spawnPoint;
  List<List<Field>> fields;
  //obsolete?
  List<SpawnPoint> restPlaces;
  List<SpawnPoint> monsterSpawnPoints;

  static Field clicked;

  Level.build(int id, Map data) {
    _id = id;
    fields = new List();

    int fieldID = 0;
    if (data.containsKey("rows")) {

      int index = 0;
      data["rows"].forEach((value) {
        fields.add(new List<Field>());

        data["rows"][index]["row"].forEach((tile) {
          Field f = new Field.create(tile["accessible"], tile["style"], "tile-${fieldID++}", data['id'], tile['monster']);
          if (tile.containsKey("spawn")) {
            spawnPoint = f;
          }

          fields[index].add(f);
        });

        index++;
      });

      for (int i = fields.length; i < 32; i++) {
        fields.add(new List<Field>());
      }

      fields.forEach((List<Field> row) {
        for (int i = row.length; i < 32; i++) {
          row.add(new Field.create(false, "none", "tile-${fieldID++}"));
        }
      });
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