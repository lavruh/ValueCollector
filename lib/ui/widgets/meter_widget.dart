import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rh_collector/domain/entities/meter.dart';
import 'package:rh_collector/domain/entities/meter_value.dart';
import 'package:rh_collector/ui/screens/camera_screen.dart';
import 'package:rh_collector/ui/screens/meter_edit_screen.dart';
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
                TextButton(
                  onPressed: () {
                    _openEditor(context);
                  },
                  child: Text(
                    _meter.name,
                    style: Theme.of(context).textTheme.headline2,
                  ),
                ),
                Text(_meter.unit ?? ""),
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
                  meter: _meter,
                )));
  }

  _addReading(BuildContext context) async {
    String reading = await Navigator.push(
        context, MaterialPageRoute(builder: (context) => CameraScreen()));
    _meter.addValue(MeterValue(DateTime.now(), int.tryParse(reading) ?? 0));
  }
}
