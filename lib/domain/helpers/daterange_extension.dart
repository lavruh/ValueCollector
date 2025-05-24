import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

extension DateTimeRangeX on DateTimeRange {
  double get durationInDays => end.difference(start).inDays.toDouble();
  double get durationInHours => end.difference(start).inHours.toDouble();
  String get formatedString =>
      "${DateFormat("y-MM-dd").format(start)} - ${DateFormat("y-MM-dd").format(end)}";
}
