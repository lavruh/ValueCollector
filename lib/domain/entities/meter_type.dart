import 'package:flutter/material.dart';
import 'package:rh_collector/di.dart';

class MeterType {
  String id;
  String name;
  int iconCode;
  int color;
  MeterType({
    String? id,
    required this.name,
    int? iconCode,
    int? color,
  })  : id = id ?? generateId(),
        iconCode = iconCode ?? Icons.electric_meter.codePoint,
        color = color ?? Colors.black.value;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is MeterType &&
        other.id == id &&
        other.name == name &&
        other.iconCode == iconCode &&
        other.color == color;
  }

  @override
  int get hashCode {
    return id.hashCode ^ name.hashCode ^ iconCode.hashCode ^ color.hashCode;
  }

  MeterType copyWith({
    String? id,
    String? name,
    int? iconCode,
    int? color,
  }) {
    return MeterType(
      id: id ?? this.id,
      name: name ?? this.name,
      iconCode: iconCode ?? this.iconCode,
      color: color ?? this.color,
    );
  }

  @override
  String toString() {
    return 'MeterType(id: $id, name: $name, iconCode: $iconCode, color: $color)';
  }
}
