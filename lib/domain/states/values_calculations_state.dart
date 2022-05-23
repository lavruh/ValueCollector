import 'package:get/get.dart';
import 'package:rh_collector/data/services/info_msg_service.dart';
import 'package:rh_collector/domain/entities/calculation_result.dart';
import 'package:rh_collector/domain/entities/meter.dart';
import 'package:rh_collector/domain/entities/meter_calculation.dart';

enum MeterType { rh, coldwater, hotwater, gas, elec }

class ValuesCalculationsState extends GetxController {
  final calculationResults = <CalculationResult>[].obs;
  final meterType = MeterType.rh.obs;
  final calculationStrategiesId = ["Difference", "Production cost"];
  final selectedCalculationStrategie = 0.obs;
  late IMeterCalculationStrategy _strategy;
  final infoMsg = Get.find<InfoMsgService>();

  calculate() async {
    calculationResults.clear();
    final meter = Get.find<Meter>(tag: 'meterEdit');
    for (int i = 1; i < meter.values.length; i++) {
      try {
        calculationResults.add(_strategy.compute(
          meter.values[i - 1],
          meter.values[i],
        ));
      } on MeterCalculationException catch (e) {
        infoMsg.push(msg: e.toString());
        break;
      }
    }
  }

  changeMeterType(MeterType type) {
    meterType.value = type;
    setCalculationStrategie(selectedCalculationStrategie.value);
  }

  setCalculationStrategie(int val) {
    selectedCalculationStrategie.value = val;
    if (val == 1) {
      if (meterType.value == MeterType.rh) {
        infoMsg.push(
            msg: 'Please select different meter type for this calculation');
        return;
      }
      _strategy = MeterProductionCostCalculation(type: meterType.value);
    } else {
      _strategy = MeterValueDeltaCalculation();
    }
    calculate();
  }
}
