import 'dart:io';

import 'package:args/args.dart';
import 'package:data_class/data_class.dart';

void main(List<String> args) {
  print(args);
  final parser = ArgParser();

  parser.addOption("path", defaultsTo: "");
  final res = parser.parse(args);
  String path = res.option("path") ?? "";
  if (path.isEmpty) {
    path = File(".").absolute.path;
  }
  generate(path);
}
