import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rh_collector/domain/entities/meter_value.dart';

class MeterValueWidget extends StatelessWidget {
  const MeterValueWidget({
    super.key,
    required this.v,
    this.textColor = Colors.black45,
  });

  final MeterValue v;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    final value = v.correctedValue;
    final valueString =
        value is int ? value.toString() : value.toStringAsFixed(2);
    return Column(
      children: [
        Text(DateFormat("yy-MM-dd").format(v.date),
            style: TextStyle(color: textColor)),
        Text(DateFormat("HH:mm").format(v.date),
            style: TextStyle(color: textColor)),
        Text(valueString, style: TextStyle(color: textColor)),
      ],
    );
  }
}
