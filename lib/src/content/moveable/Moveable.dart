part of rogue;

/// Class representing a moveable entity.
abstract class Moveable {
  int id;
  int lvl;
  int maxHealth;
  int _currHealth;
  int speed;
  int direction;
  int stage;

  String name;
  String skin;

  Field position;
  Field target;

  bool isAlive = true;
  bool isStatic = false;

  Node start;

  Map<String, int> loot = new Map();
  Map<int, int> pots = new Map();

  List<String> skins;

  static final int UP = 0;

  static final int RIGHT = 1;

  static final int LEFT = 2;

  static final int DOWN = 3;

  get currHealth => _currHealth;
  void set currHealth(int health) => _currHealth = health;

  double get currHealthPercent => (_currHealth / maxHealth) * 100;

  /// Take [damage] an loose health and/ or die.
  takeDamage(int damage) {
    if ((_currHealth - damage) <= 0) {
      _currHealth = 0;
    } else {
      _currHealth -= damage;
    }

    if (_currHealth <= 0) {
      _die();
    }
  }

  /// Calculate the damage an enemy will take.
  int calcDamage();

  /// die
  _die() {
    this.isAlive = false;
  }

  /// Update the position and sprites, based on movement direction.
  move() {
    if (start != null && start.predecessor != null && !isStatic) {
      if (start.predecessor.field.isAccessible) {
        if (!(this is Player) && _detectLoop()) {
          calcPath(position.accessibleNeighbour);
        }

        int col = start.field.col;
        int row = start.field.row;

        position.isAccessible = true;
        position = start.predecessor.field;
        position.isAccessible = false;

        start = start.predecessor;

        if (start.field.id == target.id) {
          start = null;
        }

        if (col > position.col) skin = skins[LEFT];
        if (col < position.col) skin = skins[RIGHT];

        if (row > position.row) skin = skins[UP];
        if (row < position.row) skin = skins[DOWN];
        return;
      }

      calcPath(target);
    }
  }

  /// Calculate a path to [target].
  calcPath(Field target) {
    this.target = target;

    position.isAccessible = true;
    start = new Pathfinding().calcPath(position, target);
  }

  /// Is [Moveable] looping around?
  bool _detectLoop() {
    return start.predecessor == start || start.predecessor.predecessor == start;
  }
}
