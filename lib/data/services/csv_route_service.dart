import 'package:csv/csv.dart';
import 'package:file/src/interface/file_system.dart';
import 'package:file/local.dart';
import 'package:file/file.dart';

import 'package:rh_collector/data/services/route_service.dart';

class CsvRouteService implements RouteService {
  @override
  final FileSystem fs;

  CsvRouteService() : fs = const LocalFileSystem();
  CsvRouteService.test(this.fs);

  @override
  Future<List<String>> getMetersRoute(String source) async {
    final input = await fs.file(source).readAsString();
    final output = const CsvToListConverter().convert(input).toList();
    return output.map((e) => e.first.toString()).toList();
  }
}
