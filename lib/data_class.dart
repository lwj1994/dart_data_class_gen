import 'dart:io';

import 'package:data_class/src/parser.dart';
import 'package:data_class/src/writer.dart';

export 'src/annotation.dart';

void generate(String path) {
  final entity = FileSystemEntity.typeSync(path);
  final isDirectory = entity == FileSystemEntityType.directory;

  if (isDirectory) {
    Directory(path).listSync(recursive: true).forEach((element) {
      if (element is File && element.path.endsWith('.dart')) {
        final filePath = element.absolute.path;
        final parser = Parser(filePath);
        final parseRes = parser.parseDartFile();
        if (parseRes != null) {
          final writer = Writer(parseRes);
          writer.writeCode();
        }
      }
    });
  } else {
    final parser = Parser(path);
    final parseRes = parser.parseDartFile();
    if (parseRes != null) {
      final writer = Writer(parseRes);
      writer.writeCode();
    }
  }
}
