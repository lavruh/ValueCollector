import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

extension DateTimeRangeX on DateTimeRange {
  String get durationInDays => end.difference(start).inDays.toString();
  String get durationInHours => end.difference(start).inHours.toString();
  String get formatedString =>
      DateFormat("y-MM-dd").format(start) +
      " - " +
      DateFormat("y-MM-dd").format(end);
}
