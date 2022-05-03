import 'package:flutter/material.dart';

class DeleteConfirmDialog extends StatelessWidget {
  const DeleteConfirmDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Delete'),
      content: const Text("Are you sure to want delete"),
      actions: [
        ElevatedButton(
          child: const Text('Yes'),
          onPressed: () => Navigator.of(context).pop(true),
        ),
        ElevatedButton(
          child: const Text('No'),
          onPressed: () => Navigator.of(context).pop(false),
        )
      ],
    );
  }
}
