part of rogue;

class Level {
  int _id;
  int _tileCount = 0;
  int _rowCount = 0;

  Field spawnPoint;
  List<List<Field>> fields = new List();
  List<SpawnPoint> restPlaces;
  List<Field> monsterSpawnPoints = new List();
  List<Field> treasures = new List();
  List<Moveable> monsters = new List();
  Moveable boss = null;

  static Field clicked;
  List<Node> _pathGraph = new List<Node>();

  Level.build(int id, Map data) {
    _id = id;

    if (data.containsKey('rows')) {
      _createHorizonBorder();
      data['rows'].forEach((Map row) {
        _buildRow(row['row'], row['id'], data['id']);
      });

      _createHorizonBorder();
    }

    _calcPathGraph(fields);
  }

  _buildRow(row, id, int level) {
    int cols = 0;
    fields.add(new List<Field>());

    _createVerticalBorder();
    row.forEach((Map rw) {
      _buildTile(id, rw, level);
      cols++;
    });

    _fill(cols);

    _createVerticalBorder();
    _rowCount++;
  }

  _buildTile(int row, Map tile, int level) {
    Field f = new Field.create(tile["accessible"], tile["style"], "tile-${_tileCount++}", row, tile['id'], level, tile['monster']);
    if (tile.containsKey("spawn")) {
      spawnPoint = f;
    }

    if (tile.containsKey("monster")) {
      f.monsterId = tile["monster"];
      monsterSpawnPoints.add(f);

      monsters.addAll(monsters.where((Monster move) {
        return move.stage == level;
      }));
    }

    if (tile.containsKey("treasure")) {
      f.accessible = false;

      treasures.add(f);
    }

    fields[_rowCount].add(f);
  }

  _fill(int cols) {
    for (int i = cols; i < 32; i++) {
      fields[_rowCount].addAll(_createBorderFields(1));
    }
  }

  List<Field> _createBorderFields(int count) {
    List<Field> f = new List<Field>();
    for (int i = 0; i < count; i++) f.add(new Field.empty(_tileCount++));

    return f;
  }

  _createHorizonBorder() {
    for (int i = 0; i < 4; i++) {
      fields.add(new List<Field>());
      fields[_rowCount++].addAll(_createBorderFields(40));
    }
  }

  _createVerticalBorder() {
    fields[_rowCount].addAll(_createBorderFields(4));
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

  Node getNode(Field field) {
    return _pathGraph.firstWhere((Node n) {
      return field.id == n.field.id;
    });
  }
  
  _calcPathGraph(List<List<Field>> fields) {
    Field tmp = null;
    fields.forEach((row) {
      row.forEach((field) {
        if (field.isAccessible) {
          int row = field.row + 4;
          int col = field.col + 4;
          if (field.row > 0) {
            tmp = fields[row - 1][col];
            if (tmp.isAccessible) field.top = tmp;
          }

          if (field.row >= 0) {
            tmp = fields[row + 1][col];
            if (tmp.isAccessible) field.bottom = tmp;
          }

          if (field.col > 0) {
            tmp = fields[row][col - 1];
            if (tmp.isAccessible) field.left = tmp;
          }

          if (field.col >= 0) {
            tmp = fields[row][col + 1];
            if (tmp.isAccessible) field.right = tmp;
          }

          _pathGraph.add(new Node.create(field));
        }
      });
    });

    _pathGraph.forEach((Node n) {
      n.successors.addAll(_pathGraph.where((Node nn) {
        return n.field.isNeighbour(nn.field);
      }));
    });
  }

  calcPathGraph() {
    _calcPathGraph(fields);
  }
}