import 'package:flutter/material.dart';
import 'package:rh_collector/l10n/app_localizations.dart';

num? parseReading(String valString) {
  return num.tryParse(
      valString.replaceAll(RegExp(r'[^. 0-9]', caseSensitive: false), ""));
}

String? readingValidator(BuildContext context, String? v) {
  final loc = AppLocalizations.of(context);
  if (v == null || v.isEmpty) {
    return loc!.warningReadingEmpty;
  }
  if (parseReading(v) == null) return loc!.warningReadingIsNotInteger;
  return null;
}