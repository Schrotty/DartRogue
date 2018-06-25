part of rogue;

class PrioQueue<E> extends HeapPriorityQueue<E> {
  void replace(E s) {
    List l = super.toList();
    bool b = super.remove(l[l.indexOf(s)]);

    super.add(s);
  }

  /*bool contains(E object) {
    super.toList().forEach((e) {
      if ((e as Node).isEqual(object as Node))
        return true;
    });

    return false;
  }*/

  bool contains(E object) {
    for (E elm in super.toList()) {
      if ((elm as Node).isEqual((object as Node))) return true;
    }

    return false;
  }
}