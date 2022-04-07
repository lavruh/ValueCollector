import 'package:flutter/material.dart';

class MeterGroup {
  final String _id;
  String name;

  MeterGroup({String? id, required this.name})
      : _id = id ?? UniqueKey().toString();

  String get id => _id;

  Map<String, dynamic> toJson() {
    return {
      "id": _id,
      "name": name,
    };
  }

  MeterGroup.fromJson(Map<String, dynamic> map)
      : _id = map["id"] ?? UniqueKey().toString(),
        name = map["name"] ?? "";
}
