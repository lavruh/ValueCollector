import 'package:flutter/material.dart';
import 'package:rh_collector/domain/entities/meter_value_delta.dart';

class MeterValueDeltaWidget extends StatelessWidget {
  const MeterValueDeltaWidget({
    super.key,
    required this.v,
  });

  final MeterValueDelta v;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text("\u{0394}"),
        Text(
          v.value.toStringAsFixed(2),
          style: TextStyle(color: v.isValid ? Colors.black : Colors.redAccent),
        ),
      ],
    );
  }
}
