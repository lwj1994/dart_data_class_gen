import 'dart:io';

import 'package:analyzer/dart/analysis/utilities.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:path/path.dart' as p;

import 'model.dart';

class Parser {
  final String path;

  Parser(this.path);

  ParseResult? parseDartFile() {
    File file = File(path);
    if (path.endsWith(".data.dart")) return null;
    final content = file.readAsStringSync();
    final unit = parseString(content: content).unit;
    print("parsing $path");
    final classes = <ClassInfo>[];

    for (var declaration in unit.declarations) {
      if (declaration is ClassDeclaration) {
        final hasAnnotation = declaration.metadata.any((m) {
          return m.name.name == "DataClass" || m.name.name == "dataClass";
        });
        if (!hasAnnotation) continue;

        final className = declaration.name.lexeme;
        final fields = <FieldInfo>[];

        for (final member in declaration.members) {
          if (member is FieldDeclaration && !member.isStatic) {
            final type = member.fields.type?.toSource() ?? 'dynamic';
            for (final varDecl in member.fields.variables) {
              if (!varDecl.isConst) {
                fields.add(
                  FieldInfo(
                    varDecl.name.lexeme,
                    type,
                    isFinal: varDecl.isFinal,
                  ),
                );
              }
            }
          }
        }
        print("find class ${className}");
        classes.add(ClassInfo(className, '${className}DataClassMixin', fields));
      }
    }

    if (classes.isEmpty) return null;

    final baseName = p.basename(path);
    final partOf = "part of '$baseName';";
    final outputPath = path.replaceAll('.dart', '.data.dart');

    return ParseResult(outputPath, partOf, classes);
  }
}
