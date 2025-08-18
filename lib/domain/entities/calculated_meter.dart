import 'package:dart_eval/dart_eval.dart';
import 'package:get/get.dart';
import 'package:rh_collector/data/dtos/meter_dto.dart';
import 'package:rh_collector/domain/entities/calculation_functions.dart';
import 'package:rh_collector/domain/entities/meter.dart';
import 'package:rh_collector/domain/states/meter_types_state.dart';

import 'meter_value.dart';

class CalculatedMeter extends Meter with CalculationFunctions {
  List<String> formula;

  CalculatedMeter({
    required super.id,
    required super.name,
    required super.unit,
    required super.groupId,
    required super.correction,
    required super.values,
    this.formula = const [],
  }) : super(typeId: DefaultMeterTypes.calc.value.id);

  CalculatedMeter.empty({required super.name, this.formula = const []})
      : super(
          typeId: DefaultMeterTypes.calc.value.id,
          unit: "",
          groupId: "",
          correction: 0,
        );

  @override
  Meter copyWith(
      {String? id,
      String? name,
      String? unit,
      String? groupId,
      String? typeId,
      int? correction,
      List<MeterValue>? values,
      List<String>? formula}) {
    return MeterDto(
      id: id ?? this.id,
      name: name ?? this.name, //,
      unit: unit ?? this.unit,
      groupId: groupId ?? this.groupId,
      typeId: typeId ?? this.typeId,
      correction: correction ?? this.correction,
      formula: formula ?? this.formula,
      values: values ?? this.values,
    ).toDomain();
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is CalculatedMeter &&
        other.id == id &&
        other.name == name &&
        other.unit == unit &&
        other.groupId == groupId &&
        other.typeId == typeId &&
        other.correction == correction &&
        other.formula == formula &&
        other.values == values;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        unit.hashCode ^
        groupId.hashCode ^
        typeId.hashCode ^
        correction.hashCode ^
        formula.hashCode ^
        values.hashCode;
  }

  @override
  MeterValue processValue(MeterValue v) {
    final fx = parse(formula);
    final calc = eval(fx);
    final value  = calc;
    return v.copyWith(value: value, correctedValue: value);
  }

  String parse(List<String> items) {
    String result = "";
    for (final i in items) {
      if (i.length == 1 && !i.isAlphabetOnly) {
        result += i;
        continue;
      }
      if (double.tryParse(i) != null) {
        result += i;
        continue;
      }
      if (i.length > 1) {
        result += getValueOfEncodedMeter(i).toString();
      }
    }
    return result;
  }
}
