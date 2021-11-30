import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rh_collector/domain/entities/meter_value.dart';

class MeterValueEditWidget extends StatefulWidget {
  MeterValueEditWidget({
    Key? key,
    required this.meterValue,
    this.deleteCallback,
  }) : super(key: key);

  MeterValue meterValue;
  Function? deleteCallback;

  @override
  State<MeterValueEditWidget> createState() => _MeterValueEditWidgetState();
}

class _MeterValueEditWidgetState extends State<MeterValueEditWidget> {
  TextEditingController ctrl = TextEditingController();

  @override
  void initState() {
    ctrl.text = widget.meterValue.value.toString();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(3.0),
        child: Wrap(
          alignment: WrapAlignment.spaceBetween,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Text(
              DateFormat("yyyy-MM-dd").format(widget.meterValue.date),
              style: Theme.of(context).textTheme.subtitle1,
            ),
            FractionallySizedBox(
              widthFactor: 0.4,
              child: TextField(
                controller: ctrl,
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.subtitle1,
                onSubmitted: (String v) {
                  widget.meterValue.value = int.tryParse(ctrl.text) ?? 0;
                },
              ),
            ),
            IconButton(
                onPressed: () {
                  widget.deleteCallback!(widget.meterValue);
                },
                icon: const Icon(Icons.delete_forever))
          ],
        ),
      ),
    );
  }
}
