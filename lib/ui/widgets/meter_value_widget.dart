import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rh_collector/domain/entities/meter_value.dart';

class MeterValueWidget extends StatelessWidget {
  const MeterValueWidget({
    super.key,
    required this.v,
  });

  final MeterValue v;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(DateFormat("yy-MM-dd").format(v.date)),
        Text(DateFormat("HH:mm").format(v.date)),
        Text(v.correctedValue.toString()),
      ],
    );
  }
}
