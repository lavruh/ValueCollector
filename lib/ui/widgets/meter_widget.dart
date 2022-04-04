import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rh_collector/domain/entities/meter.dart';
import 'package:rh_collector/domain/entities/meter_value.dart';
import 'package:rh_collector/domain/entities/meter_value_delta.dart';
import 'package:rh_collector/ui/screens/camera_screen.dart';
import 'package:rh_collector/ui/screens/meter_edit_screen.dart';
import 'package:rh_collector/ui/widgets/meter_value_delta_widget.dart';
import 'package:rh_collector/ui/widgets/meter_value_widget.dart';

class MeterWidget extends StatelessWidget {
  MeterWidget({Key? key, required String meterId, this.newReadingSetCallBack})
      : _id = meterId;
  final String _id;
  late Meter _meter;
  Function? newReadingSetCallBack;

  @override
  Widget build(BuildContext context) {
    _meter = Get.find<Meter>(tag: _id);
    return Card(
      elevation: 3,
      child: GetBuilder<Meter>(
          tag: _id,
          builder: (_) {
            return Wrap(
              alignment: WrapAlignment.spaceBetween,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                SizedBox(
                  width: 120,
                  child: TextButton(
                    onPressed: () {
                      _openEditor(context);
                    },
                    child: Text(
                      _meter.name,
                      overflow: TextOverflow.clip,
                      style: Theme.of(context).textTheme.headline2,
                    ),
                  ),
                ),
                SizedBox(
                  width: 30,
                  child: Text(_meter.unit ?? ""),
                ),
                _meter.values.length > 1
                    ? MeterValueDeltaWidget(
                        v: MeterValueDelta(
                        v1: _meter.values.reversed.toList()[1],
                        v2: _meter.values.last,
                      ))
                    : const SizedBox.shrink(),
                _meter.values.length > 1
                    ? MeterValueWidget(v: _meter.values.reversed.toList()[1])
                    : const SizedBox.shrink(),
                _meter.values.isNotEmpty
                    ? MeterValueWidget(v: _meter.values.last)
                    : const SizedBox.shrink(),
                IconButton(
                    onPressed: () {
                      _addReading(context);
                    },
                    icon: const Icon(Icons.add_a_photo_outlined)),
              ],
            );
          }),
    );
  }

  _openEditor(BuildContext context) async {
    await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => MeterEditScreen(
                  meter: Get.find<Meter>(tag: _id),
                )));
  }

  _addReading(BuildContext context) async {
    String? reading = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => CameraScreen(
                  meterName: _meter.name,
                )));
    if (reading != null) {
      Get.find<Meter>(tag: _id)
          .addValue(MeterValue(DateTime.now(), int.tryParse(reading) ?? 0));
      newReadingSetCallBack!();
    }
  }
}
