import 'package:flutter/material.dart';
import 'package:rh_collector/ui/widgets/delete_confirm_dialog.dart';

class ActionsPanelWidget extends StatelessWidget {
  const ActionsPanelWidget({
    super.key,
    required this.saveCallback,
    required this.deleteCallback,
    required this.clearContent,
    required this.showSaveButton,
  });
  final bool showSaveButton;
  final void Function() saveCallback;
  final void Function() deleteCallback;
  final void Function() clearContent;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        IconButton(
            onPressed: () => _deleteDialog(context: context),
            icon: const Icon(Icons.delete)),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 500),
          transitionBuilder: (child, animation) => FadeTransition(
            opacity: animation,
            child: child,
          ),
          child: showSaveButton
              ? IconButton(
                  onPressed: saveCallback, icon: const Icon(Icons.save))
              : Container(
                  width: 50,
                ),
        ),
        IconButton(
            tooltip: "Clear date/time",
            onPressed: clearContent,
            icon: const Icon(Icons.clear_all)),
      ],
    );
  }

  _deleteDialog({required BuildContext context}) async {
    if (await showDialog(
      context: context,
      builder: (BuildContext context) {
        return const DeleteConfirmDialog();
      },
    )) {
      deleteCallback();
    }
  }
}
