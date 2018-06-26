part of rogue;

/// Class representing a single item.
class Item {
  int id;

  String name;

  String display;

  String quality;

  int value;

  int type;

  String classification;

  Map modifier;

  String icon;

  int qualityValue;

  int min;

  int max;

  /// Create item from [data].
  Item.fromJson(Map data, [int quality, String classification, String type]) {
    this.id = data['id'];
    this.name = data['name'];
    this.type = data['type'];
    this.classification = classification;
    this.icon = data['icon'];
    this.display = data['display'];

    this.qualityValue = quality;
    if (quality == -1) {
      this.qualityValue = new Random().nextInt(5);
      if (data.containsKey('quality')) {
        this.qualityValue = data['quality'];
      }
    }

    this.quality = _getQuality();
    this.modifier = data.containsKey('mods') ? data['mods'] : new Map();

    if (data.containsKey('value-range')) {
      int index = quality != -1 ? this.qualityValue : 0;

      this.min = data['value-range'][index][0];
      this.max = data['value-range'][index][1];
      this.value = _getValue();
      return;
    }

    this.value = data['value'];
  }

  /// Returns a value for this [Item].
  int _getValue() => min + new Random().nextInt(max - min);

  /// Returns the quality text for this [Item].
  String _getQuality() => Qualities[qualityValue];
}
