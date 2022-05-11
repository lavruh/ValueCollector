import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rh_collector/domain/entities/meter.dart';
import 'package:rh_collector/ui/widgets/meter_value_edit_widget.dart';

class MeterValuesWidget extends StatelessWidget {
  const MeterValuesWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<Meter>(
        tag: "meterEdit",
        builder: (_) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView(
              children: _.values.reversed
                  .map((element) => MeterValueEditWidget(
                        meterValue: element,
                        deleteCallback: _.deleteValue,
                        updateCallback: _.updateValue,
                      ))
                  .toList(),
            ),
          );
        });
  }
}
