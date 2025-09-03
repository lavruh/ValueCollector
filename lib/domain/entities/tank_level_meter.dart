import 'package:get/get.dart';
import 'package:rh_collector/data/dtos/meter_dto.dart';
import 'package:rh_collector/domain/entities/meter.dart';
import 'package:rh_collector/domain/entities/meter_value.dart';
import 'package:rh_collector/domain/states/meter_types_state.dart';
import 'package:rh_collector/domain/states/sounding_tables.dart';

class TankLevelMeter extends Meter {
  final String? soundingTablePath;

  TankLevelMeter(
      {required super.id,
      required super.name,
      required super.unit,
      required super.groupId,
      required super.correction,
      required super.values,
      this.soundingTablePath})
      : super(typeId: DefaultMeterTypes.tank.value.id);

  TankLevelMeter.empty({required super.name, this.soundingTablePath})
      : super(
          typeId: DefaultMeterTypes.calc.value.id,
          unit: "",
          groupId: "",
          correction: 0,
        );

  @override
  Meter copyWith({
    String? id,
    String? name,
    String? unit,
    String? groupId,
    String? typeId,
    int? correction,
    List<MeterValue>? values,
    String? soundingTablePath,
  }) {
    return MeterDto(
      id: id ?? this.id,
      name: name ?? this.name, //,
      unit: unit ?? this.unit,
      groupId: groupId ?? this.groupId,
      typeId: typeId ?? this.typeId,
      correction: correction ?? this.correction,
      soundingTablePath: soundingTablePath ?? this.soundingTablePath,
      values: values ?? this.values,
    ).toDomain();
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is TankLevelMeter &&
        other.id == id &&
        other.name == name &&
        other.unit == unit &&
        other.groupId == groupId &&
        other.typeId == typeId &&
        other.correction == correction &&
        other.soundingTablePath == soundingTablePath &&
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
        soundingTablePath.hashCode ^
        values.hashCode;
  }

  @override
  MeterValue processValue(MeterValue v) {
    final path = soundingTablePath;
    if (path == null) return super.processValue(v);
    final value = v.value+correction;
    final vol = calculateVolume(soundingTablePath: path, level: value);
    return v.copyWith(correctedValue: vol);
  }

  num calculateVolume({required String soundingTablePath, required num level}) {
    final tables = Get.find<SoundingTables>();
    final r = tables.calculateVolume(soundingTablePath, level);
    return r;
  }
}
