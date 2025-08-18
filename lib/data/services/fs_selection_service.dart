import 'package:flutter/material.dart';

abstract class FsSelectionService {
  Future<String> selectFile(
      {List<String>? allowedExtensions,
      String? dialogTitle,
      required BuildContext context});
}
