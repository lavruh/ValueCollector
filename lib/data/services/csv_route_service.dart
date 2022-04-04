import 'dart:io';
import 'package:csv/csv.dart';

import 'package:rh_collector/data/services/route_service.dart';

class CsvRouteService implements RouteService {
  @override
  Future<List<String>> getMetersRoute(String source) async {
    final input = await File(source).readAsString();
    final output = const CsvToListConverter().convert(input).toList();
    return output.map((e) => e.first.toString()).toList();
  }
}
