import 'package:flutter/material.dart';

class EditableTextWidget extends StatefulWidget {
  String text = "";
  VoidCallback? onSubmitCallback;

  EditableTextWidget({Key? key, required this.text, this.onSubmitCallback})
      : super(key: key);

  @override
  _EditableTextWidgetState createState() => _EditableTextWidgetState();
}

class _EditableTextWidgetState extends State<EditableTextWidget> {
  bool editMode = false;
  TextEditingController controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    controller.text = widget.text;
  }

  @override
  Widget build(BuildContext context) {
    late Widget currentWidget;
    if (editMode) {
      currentWidget = TextField(
        controller: controller,
        onSubmitted: _submitChange,
      );
    } else {
      currentWidget = Text(widget.text);
    }
    return InkWell(
      child: currentWidget,
      onTap: _toggleMode,
    );
  }

  _toggleMode() {
    editMode = !editMode;
  }

  _submitChange(String value) {
    widget.text = value;
    editMode = false;
    if (widget.onSubmitCallback != null) {
      widget.onSubmitCallback!();
    }
  }
}
