import 'package:flutter/material.dart';
import 'package:rh_collector/domain/entities/meter_value.dart';
import 'package:rh_collector/l10n/app_localizations.dart';
import 'package:rh_collector/ui/widgets/input_dialog.dart';

class RemarkButton extends StatelessWidget {
  const RemarkButton({
    super.key,
    required this.updateCallback,
    required this.meterValue,
  });

  final Function(MeterValue v)? updateCallback;
  final MeterValue meterValue;

  @override
  Widget build(BuildContext context) {
    return IconButton(
        onPressed: () async {
          final f = updateCallback;
          final v = await inputDialog(
              context: context,
              title: AppLocalizations.of(context)!.remarks,
              initValue: meterValue.remark);
          if (v == null) return;
          meterValue.remark = v.isNotEmpty ? v : null;
          if (f != null) f(meterValue);
        },
        icon: Icon(
          meterValue.remark == null
              ? Icons.mode_comment_outlined
              : Icons.mode_comment,
        ));
  }
}
