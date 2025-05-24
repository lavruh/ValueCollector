import 'package:flutter/material.dart';

Future<String?> inputDialog({
  required BuildContext context,
  String? title,
  String? initValue,
}) async {
  return showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title ?? ""),
          content: TextField(
            controller: TextEditingController(text: initValue),
            onSubmitted: (val) => Navigator.of(context).pop(val),
          ),
        );
      });
}
