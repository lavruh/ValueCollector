import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rh_collector/ui/widgets/reminder/date_select_dialog_widget.dart';

class DateSelectWidget extends StatelessWidget {
  const DateSelectWidget({
    super.key,
    required this.value,
    required this.maxValue,
    required this.minValue,
    required this.placeholder,
    required this.callback,
  });
  final int? value;
  final int maxValue;
  final int minValue;
  final String placeholder;
  final void Function(int val) callback;

  @override
  Widget build(BuildContext context) {
    return ActionChip(
      onPressed: () async {
        await Get.dialog(
          DateSelectDialogWidget(
              value: value ?? 1,
              maxValue: maxValue,
              minValue: minValue,
              callback: callback),
          transitionDuration: const Duration(milliseconds: 500),
        );
      },
      label: Text("${value ?? placeholder}"),
      side: const BorderSide(width: 0),
    );
  }
}
