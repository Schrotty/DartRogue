part of rogue;

/// PriorityQueue used for storing [Node]s used in the path finding.
class PrioQueue<E> extends HeapPriorityQueue<E> {
  void replace(E s) {
    List l = super.toList();
    super.remove(l[l.indexOf(s)]);

    super.add(s);
  }

  /// [subject] exists in this queue?
  bool contains(E object) {
    for (E elm in super.toList()) {
      if ((elm as Node).isEqual((object as Node))) return true;
    }

    return false;
  }
}