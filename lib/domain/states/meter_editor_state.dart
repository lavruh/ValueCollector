import 'package:get/get.dart';
import 'package:rh_collector/data/services/db_service.dart';
import 'package:rh_collector/domain/entities/meter.dart';
import 'package:rh_collector/domain/entities/meter_value.dart';

class MeterEditorState extends GetxController {
  final _state = Rxn<Meter>();
  final mValues = RxList<MeterValue>([]);

  String get _id => meter!.id;
  Meter? get meter => _state.value;

  final db = Get.find<DbService>();

  void set(Meter m) {
    _state.value = m;
    mValues(m.values.toList());
  }

  Meter get() {
    final meter = this.meter;
    if (meter == null) throw Exception("Editor is not set");
    return meter.copyWith(values: mValues.toList());
  }

  Future<void> getValues() async {
    final meter = this.meter;
    if (meter == null) return;
    List res = await db.getEntries([], table: _id);
    List<MeterValue> tmp = [];
    for (final e in res) {
      final value = MeterValue.fromJson(e);
      if (!tmp.contains(value)) {
        tmp.add(value);
      }
    }
    tmp.sort(((a, b) =>
        a.date.millisecondsSinceEpoch - b.date.millisecondsSinceEpoch));
    mValues(tmp);
  }

  Future<Meter> addValueToMeter(
      {required MeterValue value, required Meter meter}) async {
    set(meter);
    await addValue(value);
    return get();
  }

  addValue(MeterValue v) async {
    final meter = this.meter;
    if (meter == null) return;
    final value = meter.processValue(v);
    mValues.add(value);
    await db.updateEntry(value.toJson(), table: _id);
  }

  updateValue(MeterValue v) async {
    final meter = this.meter;
    if (meter == null) return;
    int index = mValues.indexWhere((element) => element.id == v.id);
    if (index == -1) {
      throw Exception("Update failure - Meter value does not exist");
    }
    mValues[index] = meter.processValue(v);
    await db.updateEntry(v.toJson(), table: _id);
  }

  deleteValue(MeterValue v) async {
    final meter = this.meter;
    if (meter == null) return;
    if (mValues.contains(v)) {
      mValues.removeWhere((element) => element.id == v.id);
      await db.removeEntry(v.id, table: _id);
    }
  }
}
