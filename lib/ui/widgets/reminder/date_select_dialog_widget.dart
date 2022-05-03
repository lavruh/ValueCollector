import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:numberpicker/numberpicker.dart';

class DateSelectDialogWidget extends StatefulWidget {
  const DateSelectDialogWidget({
    Key? key,
    required this.value,
    required this.maxValue,
    required this.minValue,
    required this.callback,
  }) : super(key: key);

  final int value;
  final int maxValue;
  final int minValue;
  final void Function(int val) callback;

  @override
  State<DateSelectDialogWidget> createState() => _DateSelectDialogWidgetState();
}

class _DateSelectDialogWidgetState extends State<DateSelectDialogWidget> {
  late int _value;

  @override
  initState() {
    super.initState();
    _value = widget.value;
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: SizedBox(
        height: 230,
        width: 50,
        child: Card(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              NumberPicker(
                value: _value,
                maxValue: widget.maxValue,
                minValue: widget.minValue,
                step: 1,
                onChanged: _onChange,
              ),
              IconButton(onPressed: _onConfirm, icon: const Icon(Icons.check))
            ],
          ),
        ),
      ),
    );
  }

  _onConfirm() {
    widget.callback(_value);
    Get.back();
  }

  void _onChange(int value) {
    setState(() {
      _value = value;
    });
  }
}
