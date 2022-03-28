import 'package:flutter/material.dart';
import 'package:rh_collector/domain/entities/meter_value_delta.dart';

class MeterValueDeltaWidget extends StatelessWidget {
  const MeterValueDeltaWidget({
    Key? key,
    required this.v,
  }) : super(key: key);

  final MeterValueDelta v;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text("\u{0394}"),
        Text(
          v.delta.toString(),
          style: TextStyle(color: v.color),
        ),
      ],
    );
  }
}
