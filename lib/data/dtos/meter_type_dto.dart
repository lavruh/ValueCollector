import 'dart:convert';
import 'package:rh_collector/domain/entities/meter_type.dart';

class MeterTypeDto {
  String? id;
  String name;
  int? iconCode;
  int? color;

  MeterTypeDto({
    required this.id,
    required this.name,
    required this.iconCode,
    required this.color,
  });

  factory MeterTypeDto.fromDomain(MeterType type) {
    return MeterTypeDto(
      id: type.id,
      name: type.name,
      iconCode: type.iconCode,
      color: type.color,
    );
  }

  MeterType toDomain() {
    return MeterType(
      id: id,
      name: name,
      iconCode: iconCode,
      color: color,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'iconCode': iconCode,
      'color': color,
    };
  }

  factory MeterTypeDto.fromMap(Map<String, dynamic> map) {
    return MeterTypeDto(
      id: map['id'],
      name: map['name'] ?? 'name',
      iconCode: map['iconCode'],
      color: map['color'],
    );
  }

  String toJson() => json.encode(toMap());

  factory MeterTypeDto.fromJson(String source) =>
      MeterTypeDto.fromMap(json.decode(source));
}
