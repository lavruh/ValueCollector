import 'package:flutter/material.dart';

class MeterGroup {
  String id;
  String name;

  MeterGroup({required this.id, required this.name});

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
    };
  }

  MeterGroup.fromJson(Map<String, dynamic> map)
      : id = map["id"] ?? UniqueKey().toString(),
        name = map["name"] ?? "";
}
