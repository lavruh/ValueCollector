import 'package:get/get.dart';
import 'package:rh_collector/data/services/info_msg_service.dart';
import 'package:rh_collector/domain/entities/calculation_result.dart';
import 'package:rh_collector/domain/entities/meter.dart';
import 'package:rh_collector/domain/entities/meter_calculation.dart';
import 'package:rh_collector/domain/entities/meter_value.dart';
import 'package:rh_collector/domain/states/meter_types_state.dart';

class ValuesCalculationsState extends GetxController {
  final calculationResults = <CalculationResult>[].obs;

  final selectedCalculationStrategie = 0.obs;
  IMeterCalculationStrategy strategy = MeterValueDeltaCalculation();
  final calculationStrategies = [
    MeterValueDeltaCalculation(),
    MeterProductionCostCalculation(),
    MeterProductionCostMaxLimitCalculation(),
  ];

  final infoMsg = Get.find<InfoMsgService>();
  final meterTypesState = Get.find<MeterTypesState>();

  calculate() async {
    calculationResults.clear();
    final meter = Get.find<Meter>(tag: 'meterEdit');
    List<MeterValue> data = meter.values.toList();
    data.sort(((a, b) =>
        a.date.millisecondsSinceEpoch - b.date.millisecondsSinceEpoch));
    for (int i = 1; i < data.length; i++) {
      try {
        calculationResults.add(strategy.compute(
          data[i - 1],
          data[i],
        ));
      } on MeterCalculationException catch (e) {
        infoMsg.push(msg: e.toString());
        break;
      }
    }
  }

  setCalculationStrategie(int val) {
    selectedCalculationStrategie.value = val;
    final meter = Get.find<Meter>(tag: 'meterEdit');
    final meterType = meter.typeId;
    if (val > 0) {
      if (meterType == "rh") {
        infoMsg.push(
            msg: 'Please select different meter type for this calculation');
        return;
      }
      strategy = calculationStrategies[val];
      strategy.setMeterType(meterTypesState.getMeterTypeById(meterType));
    } else {
      strategy = MeterValueDeltaCalculation();
    }
    calculate();
  }
}
