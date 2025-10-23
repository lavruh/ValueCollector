
import 'package:flutter/material.dart';
import 'package:rh_collector/domain/helpers/color_extension.dart';


class Setting<T> {
  final String id;
  final String title;
  final T value;
  final FormFieldValidator? validator;

  Setting(
      this.id,
      this.title,
      this.value, {
        this.validator,
      });

  Setting<T> setValue(T? value) {
    return Setting<T>(
      id,
      title,
      value ?? this.value,
      validator: validator,
    );
  }

  Setting<T> fromMap(Map<String, dynamic> map) {
    return setValue(
      _processValue(map['value']),
    );
  }

  Map<String, dynamic> toMap() {
    final v = value is Color ? (value as Color).toHex() : value;
    return {
      'id': id,
      'value': v,
    };
  }

  static dynamic _processValue(map) {
    if (map is String && map.startsWith("#")) return HexColor.fromHex(map);
    return map;
  }
}
