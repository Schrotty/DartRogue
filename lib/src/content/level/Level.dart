part of rogue;

class Level {
  int _id;

  Field spawnPoint;
  List<List<Field>> fields;
  List<Field> _pathGrid = new List<Field>();
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

        int col = 0;
        data["rows"][index]["row"].forEach((tile) {
          Field f = new Field.create(tile["accessible"], tile["style"], "tile-${fieldID++}", index, col, data['id'], tile['monster']);
          if (tile.containsKey("spawn")) {
            spawnPoint = f;
          }

          fields[index].add(f);
          col++;
        });

        index++;
      });

      for (int i = fields.length; i < 32; i++) {
        fields.add(new List<Field>());
      }

      fields.forEach((List<Field> row) {
        for (int i = row.length; i < 32; i++) {
          row.add(new Field.create(false, "none", "tile-${fieldID++}", -1, -1));
        }
      });
    }

    _calcPathGrid();
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
  
  _calcPathGrid() {
    Field tmp = null;
    fields.forEach((row) {
      row.forEach((field) {
        if (field.id >= 0 && field.row >= 0 && field.col >= 0 && field.isAccessible) {
          if (field.row != 0) {
            tmp = fields[field.row - 1][field.col];
            if (tmp.isAccessible) field.top = tmp;
          }

          if (field.row != 31) {
            tmp = fields[field.row + 1][field.col];
            if (tmp.isAccessible) field.bottom = tmp;
          }

          if (field.col != 0) {
            tmp = fields[field.row][field.col - 1];
            if (tmp.isAccessible) field.left = tmp;
          }

          if (field.col != 31) {
            tmp = fields[field.row][field.col + 1];
            if (tmp.isAccessible) field.right = tmp;
          }

          _pathGrid.add(field);
        }
      });
    });
  }
}