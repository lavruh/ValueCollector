import 'package:flutter/material.dart';
import 'package:rh_collector/domain/entities/calculation_functions.dart';

class CalcAction extends StatelessWidget with CalculationFunctions {
  const CalcAction({
    super.key,
    required this.title,
    this.meterId,
    this.indexString,
    required this.onDropOnTop,
    this.onEditAction,
  });
  final String title;
  final String? meterId;
  final String? indexString;
  final Function({
    required CalcAction action,
    required CalcAction target,
  }) onDropOnTop;
  final Function(CalcAction)? onEditAction;

  String get action {
    final id = meterId;
    final indStr = indexString;
    if (id == null || indStr == null) return title;
    return encodeMeterById(meterId: id, indexString: indStr);
  }

  @override
  Widget build(BuildContext context) {
    return DragTarget<CalcAction>(
      builder: (context, candidateData, rejectedData) {
        return LongPressDraggable(
            feedback: getButton(), data: this, child: getButton());
      },
      onAcceptWithDetails: (details) {
        onDropOnTop(action: details.data, target: this);
      },
    );
  }

  Widget getButton() {
    final t = indexString != null ? "[$indexString]" : "";
    return TextButton(
        onPressed: () => onEditAction?.call(this),
        child: Text("$title$t"));
  }

  CalcAction copyWith({
    String? title,
    String? meterId,
    String? indexString,
    Function({
      required CalcAction action,
      required CalcAction target,
    })? onDropOnTop,
    Function(CalcAction)? onEditAction,
  }) {
    return CalcAction(
      title: title ?? this.title,
      meterId: meterId ?? this.meterId,
      indexString: indexString ?? this.indexString,
      onDropOnTop: onDropOnTop ?? this.onDropOnTop,
      onEditAction: onEditAction ?? this.onEditAction,
    );
  }
}
