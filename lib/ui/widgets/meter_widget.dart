import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rh_collector/domain/entities/meter.dart';
import 'package:rh_collector/ui/widgets/meter_value_widget.dart';

class MeterWidget extends StatelessWidget {
  MeterWidget({Key? key, required Meter meter})
      : _meter = Get.put<Meter>(meter, tag: meter.id);

  final Meter _meter;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      child: GetBuilder<Meter>(
          tag: _meter.id,
          builder: (_) {
            return Wrap(
              alignment: WrapAlignment.spaceBetween,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                Text(
                  _meter.name,
                  style: Theme.of(context).textTheme.headline5,
                ),
                Text(_meter.unit ?? ""),
                _meter.values.isNotEmpty
                    ? MeterValueWidget(v: _meter.values.reversed.toList()[1])
                    : const SizedBox.shrink(),
                _meter.values.isNotEmpty
                    ? MeterValueWidget(v: _meter.values.last)
                    : const SizedBox.shrink(),
                IconButton(onPressed: () {}, icon: const Icon(Icons.add)),
              ],
            );
          }),
    );
  }
}
