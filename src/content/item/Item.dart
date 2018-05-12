import 'Quality.dart';
import 'dart:math';

class Item {
  int _id;

  String name;

  String quality;

  int value;

  int type;

  Map modifier;

  String icon;

  int _quality;

  int _min;

  int _max;

  Item.fromJson(Map data, [int quality]) {
    this._id = data['id'];
    this.name = data['name'];
    this.type = data['type'];
    this.icon = data['icon'];

    this._quality = quality;
    if (quality  == -1) {
      this._quality = new Random().nextInt(5);
      if (data.containsKey('quality')) {
        this._quality = data['quality'];
      }
    }

    this.quality = _getQuality();
    this.modifier = data['mods'];

    if (data.containsKey('value-range')) {
      this._min = data['value-range'][this._quality][0];
      this._max = data['value-range'][this._quality][1];
      this.value = _getValue();
      return;
    }

    this.value = data['value'];
  }

  int get id => _id;

  int _getValue() => _min + new Random().nextInt(_max - _min);

  String _getQuality() => Qualities[_quality];

  String toString() {
    return "Name: $name\r\nQuality: $quality\r\nValue: $value\r\n";
  }
}