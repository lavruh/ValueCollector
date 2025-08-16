import 'package:flutter/material.dart';
import 'package:rh_collector/data/services/fs_selection_service.dart';

class FsSelectionServiceMock implements FsSelectionService {
  String filePath = "";

  @override
  Future<String> selectFile(
      {List<String>? allowedExtensions,
      String? dialogTitle,
      required BuildContext context}) async {
    return filePath;
  }
}
