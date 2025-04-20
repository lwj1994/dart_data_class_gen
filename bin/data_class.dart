import 'package:args/args.dart';
import 'package:data_class/data_class.dart';

void main(List<String> args) {
  print(args);
  final parser = ArgParser();

  parser.addOption("path");
  final res = parser.parse(args);
  final path = res.option("path") ?? "";
  if (path.isEmpty) {
    throw StateError("path is null");
  }
  generate(path);
}
