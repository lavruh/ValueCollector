import 'package:flutter/material.dart';

class EditorTextInputFieldWidget extends StatelessWidget {
  const EditorTextInputFieldWidget({
    super.key,
    this.keyboardType,
    this.lable,
    required this.initValue,
    this.setValue,
  });
  final TextInputType? keyboardType;
  final String? lable;
  final String initValue;
  final Function(String val)? setValue;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: MediaQuery.of(context).size.width * 0.4,
        child: TextField(
          controller: TextEditingController(text: initValue),
          showCursor: true,
          keyboardType: keyboardType,
          textAlign: TextAlign.center,
          decoration: InputDecoration(
            labelText: lable,
          ),
          onChanged: setValue,
        ));
  }
}
