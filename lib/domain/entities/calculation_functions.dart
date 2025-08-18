import 'package:dart_eval/dart_eval.dart';
import 'package:get/get.dart';
import 'package:rh_collector/domain/entities/meter.dart';
import 'package:rh_collector/domain/states/meters_state.dart';

mixin CalculationFunctions {
  String encodeMeter({required Meter meter, String indexString = "n"}) {
    return encodeMeterById(meterId: meter.id, indexString: indexString);
  }

  String getIndexString(String encodedMeter) {
    final vals = encodedMeter.split("_");
    if (vals.length != 2) return "";
    return vals[1];
  }

  String? getMeterId(String encodedMeter) {
    final vals = encodedMeter.split("_");
    if (vals.length != 2) return null;
    return vals[0];
  }

  String encodeMeterById({required String meterId, String indexString = "n"}) {
    return "${meterId}_$indexString";
  }

  num getValueOfEncodedMeter(String encodedMeter) {
    final vals = encodedMeter.split("_");
    if (vals.length != 2) return 0;
    final meterId = vals[0];
    final indexString = vals[1];
    try {
      final meter = Get.find<MetersState>().getMeter(meterId);
      final values = meter.values;
      if (values.isEmpty) return 0;
      final valIndex =
          eval(indexString.replaceAll("n", "${values.length - 1}"));
      if (valIndex < 0 || valIndex >= values.length) return 0;
      return values[valIndex].correctedValue;
    } catch (e) {
      Get.snackbar("Error:", "$e\nPlease check formula");
    }
    return 0;
  }
}
