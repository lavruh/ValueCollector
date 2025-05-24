import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class WeekdaySelectorWidget extends StatelessWidget {
  const WeekdaySelectorWidget({
    super.key,
    required this.resultSetter,
    this.selected,
  });
  final void Function(int val) resultSetter;
  final int? selected;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: 7,
          itemBuilder: (context, index) {
            return ActionChip(
                label:
                    Text(DateFormat("E").format(DateTime(2022, 4, 4 + index))),
                side: BorderSide(width: selected == index + 1 ? 3 : 0),
                onPressed: () {
                  resultSetter(index + 1);
                });
          }),
    );
  }
}
