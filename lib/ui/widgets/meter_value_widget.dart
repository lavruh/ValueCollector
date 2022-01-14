import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rh_collector/domain/entities/meter_value.dart';

class MeterValueWidget extends StatelessWidget {
  const MeterValueWidget({
    Key? key,
    required this.v,
  }) : super(key: key);

  final MeterValue v;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(DateFormat("y-MM-dd").format(v.date)),
        Text(v.correctedValue.toString()),
      ],
    );
  }
}
