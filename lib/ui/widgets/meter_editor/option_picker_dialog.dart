import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OptionPickerDialog<T> extends StatefulWidget {
  const OptionPickerDialog({
    super.key,
    required this.initValue,
    required this.options,
    required this.onChanged,
    required this.titleBuilder,
    required this.optionBuilder,
  });

  final T initValue;
  final List<T> options;
  final Function(T v) onChanged;
  final Widget Function(T v) titleBuilder;
  final Widget Function(T v) optionBuilder;

  @override
  State<OptionPickerDialog<T>> createState() => _OptionPickerDialogState();
}

class _OptionPickerDialogState<T> extends State<OptionPickerDialog<T>> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: () {
          Get.dialog(Dialog(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: widget.options.map((e) {
                return TextButton(
                    onPressed: () {
                      widget.onChanged(e);
                      Get.back();
                    },
                    child: widget.optionBuilder(e));
              }).toList(),
            ),
          ));
        },
        child: widget.titleBuilder(widget.initValue));
  }
}
