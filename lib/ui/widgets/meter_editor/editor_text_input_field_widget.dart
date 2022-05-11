import 'package:flutter/material.dart';

class EditorTextInputFieldWidget extends StatelessWidget {
  const EditorTextInputFieldWidget({
    Key? key,
    this.keyboardType,
    this.lable,
    required this.initValue,
    this.setValue,
  }) : super(key: key);
  final TextInputType? keyboardType;
  final String? lable;
  final String initValue;
  final Function(String val)? setValue;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: MediaQuery.of(context).size.width * 0.9,
        child: TextField(
          controller: TextEditingController(text: initValue),
          showCursor: true,
          keyboardType: keyboardType,
          style: Theme.of(context).textTheme.headline5,
          textAlign: TextAlign.center,
          decoration: InputDecoration(
            labelText: lable,
            // border:
            //     OutlineInputBorder(borderRadius: BorderRadius.circular(8))
          ),
          onChanged: setValue,
        ));
  }
}
