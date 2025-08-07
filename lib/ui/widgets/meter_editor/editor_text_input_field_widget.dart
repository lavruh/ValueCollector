import 'package:flutter/material.dart';

class EditorTextInputFieldWidget extends StatefulWidget {
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
  State<EditorTextInputFieldWidget> createState() =>
      _EditorTextInputFieldWidgetState();
}

class _EditorTextInputFieldWidgetState
    extends State<EditorTextInputFieldWidget> {
  final controller = TextEditingController();

  @override
  initState() {
    super.initState();
    controller.text = widget.initValue;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: MediaQuery.of(context).size.width * 0.4,
        child: TextField(
          controller: controller,
          showCursor: true,
          keyboardType: widget.keyboardType,
          textAlign: TextAlign.center,
          decoration: InputDecoration(labelText: widget.lable),
          onSubmitted: submit,
          onTapOutside: (_) => submit(controller.text),
        ));
  }

  void submit(String v) {
    final callback = widget.setValue;
    if (callback != null) callback(v);
  }
}
