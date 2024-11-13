import 'package:file/local.dart';
import 'package:file/file.dart';

abstract class RouteService {
  final FileSystem fs;
  RouteService() : fs = const LocalFileSystem();
  Future<List<String>> getMetersRoute(String source);
}
