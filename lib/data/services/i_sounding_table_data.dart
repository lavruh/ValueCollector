import 'package:csv/csv.dart';
import 'package:file/file.dart';
import 'package:file/local.dart';

abstract class ISoundingTableData {
  final FileSystem fs;
  ISoundingTableData() : fs = const LocalFileSystem();

  Future<Map<num, num>> loadSoundingTable(String path);
}

class CsvSoundingTableData implements ISoundingTableData {
  @override
  final FileSystem fs;

  CsvSoundingTableData() : fs = const LocalFileSystem();
  @override
  Future<Map<num, num>> loadSoundingTable(String path) async {
    final file = fs.file(path);
    if (!file.existsSync()) throw Exception("File not found");
    final input = await file.readAsString();
    final csvData = const CsvToListConverter(shouldParseNumbers: false)
        .convert(input)
        .toList();
    Map<num, num> output = {};
    for (int i = 0; i < csvData.length; i++) {
      final level = num.parse(csvData[i][0]);
      final volume = num.parse(csvData[i][1]);
      output[level] = volume;
    }
    return output;
  }
}
