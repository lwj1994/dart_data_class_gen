// @author luwenjie on 2025/4/19 17:35:16

import 'dart:io';

import 'package:analyzer/dart/analysis/utilities.dart';
import 'package:analyzer/dart/ast/ast.dart';

/// 解析 class 的结构
class Parser {
  final String dirPath;

  Parser({required this.dirPath});

  void parseClasses() {
    Directory(dirPath).listSync(recursive: true).forEach((element) {
      if (element.path.endsWith('dart')) {
        print(element.path);
        File file = File(element.path);
        final DateTime startTime = DateTime.now();
        final s = file.readAsStringSync();
        final parseResult = parseString(content: s, path: file.absolute.path);
        print("cost ${DateTime.now().difference(startTime).inMilliseconds} ms");
        final unit = parseResult.unit;
        final lineInfo = parseResult.lineInfo;
        for (var declaration in unit.declarations) {
          if (declaration is ClassDeclaration) {
            final className = declaration.name;
            final startOffset = declaration.offset;
            final endOffset = declaration.end;

            final startLocation = lineInfo.getLocation(startOffset);
            final endLocation = lineInfo.getLocation(endOffset);

            print('类名: $className');
            print('起始行: ${startLocation.lineNumber}');
            print('结束行: ${endLocation.lineNumber}');
            print('---');

            final annotations = declaration.metadata;
            for (var annotation in annotations) {
              print(annotation);
              print(annotation.element);
              print(annotation.arguments?.arguments);
              print(annotation.element?.name);
              print(annotation.element2?.name);
              if (annotation.name.name == 'dataClass') {
                print('找到 @dataClass 注解');
                // 处理 @dataClass 注解
                // 你可以在这里添加你的逻辑
              }
            }
          }
        }
      }
    });
  }
}
