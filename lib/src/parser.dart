import 'dart:io';

import 'package:analyzer/dart/analysis/results.dart';
import 'package:analyzer/dart/analysis/utilities.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:collection/collection.dart';
import 'package:data_class_annotation/data_class_annotation.dart';
import 'package:path/path.dart' as p;

import 'model.dart';

class Parser {
  final String path;

  Parser(this.path);

  ParseResult? parseDartFile() {
    final res = <ParseResult>[];
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
        final meta = declaration.metadata.firstWhereOrNull((e) {
          String s = e.name.name;
          if (s.contains(".")) {
            s = s.split(".").last;
          }
          return s == "DataClass" || s == "dataClass";
        });

        if (meta == null) continue;

        final className = declaration.name.lexeme;
        final fields = <FieldInfo>[];
        final defaultValueMap = <String, String>{};
        print("find class $className");

        bool? fromMap;
        String mixinName = "";
        String fromMapName = "";
        String toMapName = "";
        List<Expression> arguments = meta.arguments?.arguments ?? [];
        for (var value in arguments) {
          if (value is NamedExpression) {
            final name = value.name.label.name;
            if (name == "fromMap") {
              // 处理类名
              final v = value.expression.toSource();
              if (v == "null") {
                fromMap = config.includeFromMap;
              } else {
                fromMap = v == "true";
              }
            } else if (name == "name") {
              mixinName = value.expression.toSource().replaceAll("\"", "");
            } else if (name == "fromMapName") {
              final v = value.expression.toSource().replaceAll("\"", "");
              if (v.isEmpty) {
                fromMapName = config.fromMapName;
              } else {
                fromMapName = v;
              }
            } else if (name == "toMapName") {
              final v = value.expression.toSource().replaceAll("\"", "");
              toMapName = v;
            }
          }
        }

        if (fromMapName.isEmpty) {
          fromMapName = config.fromMapName;
        }
        if (toMapName.isEmpty) {
          toMapName = config.toMapName;
        }

        // ConstructorDeclaration
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

        // fields
        for (final member in declaration.members) {
          if (member is FieldDeclaration && !member.isStatic) {
            // fields
            bool isFunction = member.fields.type is GenericFunctionType;
            bool isRecord = member.fields.type is RecordTypeAnnotation;
            final type = member.fields.type?.toSource() ?? 'dynamic';
            JsonKeyInfo? jsonKeyInfo;
            for (var e in member.metadata) {
              String s = e.name.name;
              if (s.contains(".")) {
                s = s.split(".").last;
              }

              if (s == "JsonKey") {
                jsonKeyInfo = JsonKeyInfo(
                  name: "",
                  readValue: "",
                  ignore: false,
                  alternateNames: [],
                );
                List<Expression> arguments = e.arguments?.arguments ?? [];
                for (var element in arguments) {
                  if (element is NamedExpression) {
                    final name = element.name.label.name;
                    if (name == "name") {
                      jsonKeyInfo = jsonKeyInfo!.copyWith(
                        name: element.expression
                            .toSource()
                            .replaceAll("\"", "")
                            .replaceAll("'", ""),
                      );
                    } else if (name == "readValue") {
                      jsonKeyInfo = jsonKeyInfo!.copyWith(
                        readValue: element.expression.toSource(),
                      );
                    } else if (name == "ignore") {
                      jsonKeyInfo = jsonKeyInfo!.copyWith(
                        ignore: element.expression.toSource() == "true",
                      );
                    } else if (name == "alternateNames") {
                      final s = element.expression
                          .toSource()
                          .replaceAll("[", "")
                          .replaceAll("\"", "")
                          .replaceAll(" ", "")
                          .replaceAll("]", "");

                      jsonKeyInfo = jsonKeyInfo!.copyWith(
                        alternateNames:
                            s.split(',').where((e) => e.isNotEmpty).toList(),
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
                    isFunction: isFunction,
                    jsonKey: jsonKeyInfo,
                    isRecord: isRecord,
                    defaultValue: defaultValueMap[name] ?? "",
                  ),
                );
              }
            }
          }
        }

        classes.add(
          ClassInfo(
            name: className,
            mixinName: mixinName.isEmpty ? '_$className' : mixinName,
            fields: fields,
            fromMap: fromMap ?? config.includeFromMap,
            fromMapName: fromMapName,
            toMapName: toMapName,
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
