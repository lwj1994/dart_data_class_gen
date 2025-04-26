import 'dart:io';

import 'package:analyzer/dart/analysis/results.dart';
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
    late ParseStringResult parseRes;
    try {
      parseRes = parseString(content: content);
    } catch (e) {
      return null;
    }
    print("parsing $path");
    final classes = <ClassInfo>[];
    final unit = parseRes.unit;
    for (var declaration in unit.declarations) {
      if (declaration is ClassDeclaration) {
        final hasDataAnnotation = declaration.metadata.any((m) {
          return m.name.name == "DataClass" || m.name.name == "dataClass";
        });
        if (!hasDataAnnotation) continue;

        final meta = declaration.metadata.firstWhere((e) {
          return e.name.name == "dataClass" || e.name.name == "DataClass";
        });

        bool fromMap = false;
        List<Expression> arguments = meta.arguments?.arguments ?? [];
        for (var value in arguments) {
          if (value is NamedExpression) {
            final name = value.name.label.name;
            if (name == "fromMap") {
              // 处理类名
              fromMap = value.expression.toSource() == "true";
            }
          }

          final className = declaration.name.lexeme;
          final fields = <FieldInfo>[];
          final defaultValueMap = <String, String>{};

          declaration.members.whereType<ConstructorDeclaration>().forEach((
            member,
          ) {
            if (member.factoryKeyword != null) {
              //
            } else {
              // 主构造函数
              for (var parameter in member.parameters.parameters) {
                if (parameter is DefaultFormalParameter) {
                  if (parameter.defaultValue != null) {
                    defaultValueMap[parameter.name?.lexeme ?? ""] =
                        parameter.defaultValue?.toSource() ?? "";
                  }
                }
              }
            }
          });

          for (final member in declaration.members) {
            if (member is FieldDeclaration && !member.isStatic) {
              // fields
              final type = member.fields.type?.toSource() ?? 'dynamic';
              JsonKeyInfo? jsonKeyInfo;
              for (var e in member.metadata) {
                final name = e.name.name;
                if (name == "JsonKey") {
                  jsonKeyInfo = JsonKeyInfo(name: "", readValue: "");
                  List<Expression> arguments = e.arguments?.arguments ?? [];
                  for (var element in arguments) {
                    if (element is NamedExpression) {
                      final name = element.name.label.name;
                      if (name == "name") {
                        jsonKeyInfo = jsonKeyInfo!.copyWith(
                          name: element.expression.toSource(),
                        );
                      } else if (name == "readValue") {
                        jsonKeyInfo = jsonKeyInfo!.copyWith(
                          readValue: element.expression.toSource(),
                        );
                      }
                    }
                  }
                }
              }

              for (final varDecl in member.fields.variables) {
                if (!varDecl.isConst) {
                  final name = varDecl.name.lexeme;
                  fields.add(
                    FieldInfo(
                      name: name,
                      type: type,
                      isFinal: varDecl.isFinal,
                      jsonKey: jsonKeyInfo,
                      defaultValue: defaultValueMap[name] ?? "",
                    ),
                  );
                }
              }
            }
          }
          print("find class $className");
          classes.add(
            ClassInfo(
              name: className,
              mixinName: '${className}DataClassMixin',
              fields: fields,
              fromMap: fromMap,
            ),
          );
        }
      }

      if (classes.isEmpty) return null;

      final baseName = p.basename(path);
      final partOf = "part of '$baseName';";
      final outputPath = path.replaceAll('.dart', '.data.dart');

      return ParseResult(outputPath, partOf, classes);
    }
  }
}
