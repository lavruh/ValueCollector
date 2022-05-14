import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class DeleteConfirmDialog extends StatelessWidget {
  const DeleteConfirmDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(AppLocalizations.of(context)!.delete),
      content: Text(AppLocalizations.of(context)!.deleteMsg),
      actions: [
        ElevatedButton(
          child: Text(AppLocalizations.of(context)!.yes),
          onPressed: () => Navigator.of(context).pop(true),
        ),
        ElevatedButton(
          child: Text(AppLocalizations.of(context)!.no),
          onPressed: () => Navigator.of(context).pop(false),
        )
      ],
    );
  }
}
