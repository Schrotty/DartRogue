part of rogue;

/// Class representing a single [Level].
class Level {
  int id;
  int _tileCount = 0;
  int _rowCount = 0;

  String name;

  Moveable boss = null;

  Field bossSpawn = null;
  Field spawnPoint;
  Field exit;

  List<List<Field>> fields = new List();

  List<Field> monsterSpawnPoints = new List();
  List<Field> treasureFields = new List();
  List<Field> patrolPoints = new List();

  List<Node> _pathGraph = new List<Node>();

  List<Treasure> treasures = new List();
  List<Moveable> monsters = new List();

  Map<int, Treasure> monsterDrops = new Map();

  static Field clicked;

  /// Create a new [Level] from [data].
  Level.build(int id, Map data) {
    id = id;

    name = "Level - " + id.toString();
    if (data.containsKey('name')) {
      name = data['name'];
    }

    if(data.containsKey('treasures')) {
      data['treasures'].forEach((Map treasure){
        treasures.add(new Treasure.build(treasure));
      });
    }

    if (data.containsKey('rows')) {
      _createHorizonBorder();
      data['rows'].forEach((Map row) {
        _buildRow(row['row'], row['id'], data['id']);
      });

      _createHorizonBorder();
    }

    calcPathGraph(fields);
  }

  /// Build a single level row.
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

  /// Build a single [Field].
  _buildTile(int row, Map tile, int level) {
    Field f = new Field.create(tile["accessible"], tile["style"], "tile-${_tileCount++}", row, tile['id'], level, tile['monster']);
    if (tile.containsKey("spawn")) {
      spawnPoint = f;
    }

    if(tile.containsKey("exit")) {
      f.isExit = true;
      exit = f;
    }

    if (tile.containsKey("monster")) {
      monsterSpawnPoints.add(f);
    }

    if (tile.containsKey("treasure")) {
      f.hasTreasure = true;
      treasureFields.add(f..isAccessible = false);
    }

    if (tile.containsKey("boss")) {
      bossSpawn = f;
    }

    if (tile.containsKey("patrol")) {
      patrolPoints.add(f);
    }

    fields[_rowCount].add(f);
  }

  /// Fill [cols] [Field]s in.
  _fill(int cols) {
    for (int i = cols; i < 32; i++) {
      fields[_rowCount].addAll(_createBorderFields(1));
    }
  }

  /// Create a list of non-accessible [Field]s.
  List<Field> _createBorderFields(int count) {
    List<Field> f = new List<Field>();
    for (int i = 0; i < count; i++) f.add(new Field.empty(_tileCount++));

    return f;
  }

  /// Create a horizontal border of [Field]s.
  _createHorizonBorder() {
    for (int i = 0; i < 4; i++) {
      fields.add(new List<Field>());
      fields[_rowCount++].addAll(_createBorderFields(40));
    }
  }

  /// Create a vertical border of [Field]s.
  _createVerticalBorder() {
    fields[_rowCount].addAll(_createBorderFields(4));
  }

  /// Return the [Field] with id [id] within this [Level].
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

  /// Return the [Node] with the id [id].
  Node getNode(Field field) {
    return _pathGraph.firstWhere((Node n) {
      return field.id == n.field.id;
    });
  }

  /// Calculates the pathfinding graph for this [Level] using a list of [Field]s.
  calcPathGraph(List<List<Field>> fields) {
    Field tmp = null;
    fields.forEach((row) {
      row.forEach((field) {
        if (field.isAccessible) {
          int row = field.row + 4;
          int col = field.col + 4;
          if (field.row > 0) {
            tmp = fields[row - 1][col];
            if (tmp.isAccessible || tmp.hasTreasure) field.top = tmp;
          }

          if (field.row >= 0) {
            tmp = fields[row + 1][col];
            if (tmp.isAccessible || tmp.hasTreasure) field.bottom = tmp;
          }

          if (field.col > 0) {
            tmp = fields[row][col - 1];
            if (tmp.isAccessible || tmp.hasTreasure) field.left = tmp;
          }

          if (field.col >= 0) {
            tmp = fields[row][col + 1];
            if (tmp.isAccessible || tmp.hasTreasure) field.right = tmp;
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
}