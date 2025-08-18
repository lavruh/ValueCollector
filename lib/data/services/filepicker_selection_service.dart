import 'package:file_provider/file_provider.dart';
import 'package:flutter/material.dart';
import 'package:rh_collector/data/services/fs_selection_service.dart';

class FilePickerSelectionService implements FsSelectionService {
  @override
  Future<String> selectFile({
    List<String>? allowedExtensions,
    String? dialogTitle,
    required BuildContext context,
  }) async {
    try {
      final fileProvider = FileProvider.getInstance();
      final file = await fileProvider.selectFile(
          context: context,
          title: dialogTitle ?? "",
          allowedExtensions: allowedExtensions);
      return file.path;
    } on Exception catch (e) {
      throw Exception("No file selected. $e");
    }
  }
}
