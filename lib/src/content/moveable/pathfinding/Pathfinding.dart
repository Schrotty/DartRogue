part of rogue;

class Pathfinding {

  PrioQueue<Node> _openList = new PrioQueue<Node>();
  PrioQueue<Node> _closedList = new PrioQueue<Node>();
  //Set<Node> _closedList = new Set<Node>();

  Node _target;
  Node calcPath(Field start, Field target) {
    _target = levels[player.currentStage].getNode(start);
    _openList.add(levels[player.currentStage].getNode(target));

    Node current;
    while (_openList.length > 0) {
      current = _openList.removeFirst();

      if (current.isEqual(_target)) {
        return current;
      }

      _closedList.add(current);
      _expandNode(current);
    }

    return _target;
  }

  _expandNode(Node current) {
    int tentative_g = 0;

    for (Node s in current.successors) {
      tentative_g = current.g + 1;

      if (_closedList.contains(s)) continue;
      if (_openList.contains(s) && tentative_g >= s.g) continue;

      s.g = tentative_g;
      s.predecessor = current;
      s.f = s.g + _h(s);

      if (_openList.contains(s)) {
        _openList.replace(s);
        continue;
      }

      _openList.add(s);

      /*print("Current: " + current.field.id.toString());
      print("Target: " + _target.field.id.toString());

      print("OpenList: ");
      _openList.toList().forEach((n) {
        print(n.field.id.toString() + ": " + n.f.toString() + " | " + n.predecessor.field.id.toString());
      });

      print("-------------");*/
    }
  }

  double _h(Node current) {
    int x = _target.X - current.X;
    int y = _target.Y - current.Y;

    return (x + y / 2) - 1;
  }
}