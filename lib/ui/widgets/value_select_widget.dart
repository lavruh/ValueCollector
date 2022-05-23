import 'package:flutter/material.dart';

class ValueSelectWidget extends StatelessWidget {
  const ValueSelectWidget(
      {Key? key,
      required this.items,
      required this.callback,
      required this.initValue})
      : super(key: key);
  final List<String> items;
  final Function(int val) callback;
  final int initValue;

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      icon: const Icon(Icons.arrow_drop_down),
      value: items[initValue],
      elevation: 3,
      items: items
          .map((e) => DropdownMenuItem<String>(
                child: Text(e),
                value: e,
              ))
          .toList(),
      onChanged: (value) {
        int index = items.indexOf(value ?? items[0]);
        callback(index);
      },
    );
  }
}
