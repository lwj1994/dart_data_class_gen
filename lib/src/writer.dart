import 'dart:io';

import 'package:data_class_gen/src/util.dart';

import 'model.dart';

class Writer {
  final ParseResult result;

  Writer(this.result);

  String writeCode() {
    final buffer = StringBuffer();

    buffer.writeln('// Generated by data class generator');
    buffer.writeln('// DO NOT MODIFY BY HAND\n');
    buffer.writeln(result.partOf);
    buffer.writeln();

    for (final clazz in result.classes) {
      buffer.writeln("mixin ${clazz.mixinName} {");

      for (final field in clazz.fields) {
        buffer.writeln('  abstract final ${field.type} ${field.name};');
      }

      // copyWith
      _buildCopyWith(buffer, clazz);

      // ==
      _buildEquality(buffer, clazz);

      // hashCode
      _buildHashCode(buffer, clazz);
      // toMap
      _buildToMap(buffer, clazz);

      if (clazz.fromMap) {
        _buildFromMap(buffer, clazz);
      }

      buffer.writeln('}\n');
    }

    File(result.outputPath)
      ..createSync(recursive: true)
      ..writeAsStringSync(buffer.toString());
    print("generated ${result.outputPath}");
    return buffer.toString();
  }

  void _buildEquality(StringBuffer buffer, ClassInfo clazz) {
    // == override
    buffer.writeln('\n  @override');
    buffer.writeln('  bool operator ==(Object other) {');
    buffer.writeln('    if (identical(this, other)) { return true;}');
    buffer.writeln('    if (other is! ${clazz.name}) { return false;}');
    buffer.writeln();
    for (final field in clazz.fields) {
      final name = field.name;
      final type = field.type;
      if (field.isRecord) {
        buffer.writeln('    if ($name != other.$name) return false;');
      } else if (field.isFunction) {
        buffer.writeln('    if ($name != other.$name) return false;');
      } else if (type.isCollection()) {
        buffer.writeln(
          '    if (!const DeepCollectionEquality().equals($name, other.$name)) { return false;}',
        );
      } else {
        buffer.writeln('    if ($name != other.$name) return false;');
      }
    }
    buffer.writeln('    return true;');
    buffer.writeln('  }');
  }

  void _buildHashCode(StringBuffer buffer, ClassInfo clazz) {
    buffer.writeln('\n  @override');
    buffer.writeln('  int get hashCode =>');
    final hashParts = clazz.fields.map((f) {
      final name = f.name;
      final type = f.type;
      if (type.isCollection()) {
        return 'const DeepCollectionEquality().hash($name)';
      }
      return '$name.hashCode';
    }).join(' ^\n      ');
    buffer.writeln('      $hashParts;');
  }

  void _buildCopyWith(StringBuffer buffer, ClassInfo clazz) {
    buffer.write('\n  ${clazz.name} copyWith({');
    for (final field in clazz.fields) {
      buffer.write(
        '${field.type.replaceAll('?', "")}? ${field.name}, \n      ',
      );
    }
    buffer.writeln('}) {');
    buffer.writeln('    return ${clazz.name}(');
    for (final field in clazz.fields) {
      buffer.writeln(
        '      ${field.name}: ${field.name} ?? this.${field.name},',
      );
    }
    buffer.writeln('    );');
    buffer.writeln('  }');
  }

  void _buildToMap(StringBuffer buffer, ClassInfo clazz) {
    buffer.writeln('\n  Map<String, dynamic> toMap() => {');
    for (final field in clazz.fields) {
      if (field.jsonKey?.ignore == true) {
        continue;
      }
      buffer.writeln("    '${field.name}': ${field.name},");
    }
    buffer.writeln('  };');
  }

  void _buildFromMap(StringBuffer buffer, ClassInfo clazz) {
    buffer.writeln(
      '\n  static ${clazz.name} fromMap(Map<String, dynamic> map)  {',
    );
    buffer.writeln('    return ${clazz.name}(');
    for (final field in clazz.fields) {
      if (field.jsonKey?.ignore == true) {
        continue;
      }
      String jsonKey = field.name;
      if (field.jsonKey?.name.isNotEmpty == true) {
        jsonKey = field.jsonKey?.name ?? "";
      }
      String getValueExpression = "";
      String dv = "";
      if (field.defaultValue.isNotEmpty) {
        dv = " ?? ${field.defaultValue}";
      }

      String valueExpress = "map['$jsonKey']";
      if (field.jsonKey?.readValue.isNotEmpty == true) {
        valueExpress = "${field.jsonKey?.readValue}(map, '$jsonKey')";
      }

      if (field.type == "String") {
        getValueExpression = "$valueExpress?.toString()$dv";
      } else if (field.type == "bool") {
        getValueExpression =
            "$valueExpress != null ? ($valueExpress as bool?) $dv : null";
      } else if (field.type == "int") {
        getValueExpression =
            "$valueExpress != null ? int.tryParse($valueExpress?.toString() ?? '') $dv  : null";
      } else if (field.type == "double") {
        getValueExpression =
            "$valueExpress != null ? double.tryParse($valueExpress?.toString() ?? '') $dv : null";
      } else if (field.type == "num") {
        getValueExpression =
            "$valueExpress != null ? num.tryParse($valueExpress?.toString() ?? '') $dv : null";
      } else if (field.type.isList()) {
        final index = field.type.indexOf("<");
        final index2 = field.type.indexOf(">");
        final itemType = field.type.substring(index + 1, index2);

        if (itemType == "String") {
          getValueExpression =
              "($valueExpress != null ? ($valueExpress as List<dynamic>?)?.map((e) => e.toString()).toList() : null)$dv";
        } else {
          getValueExpression =
              "($valueExpress != null ? ($valueExpress as List<dynamic>?)?.map((e) => ${itemType}Mixin.fromMap(e)).toList() : null)$dv";
        }
      } else if (field.type.isMap()) {
        getValueExpression = "($valueExpress as Map<String, dynamic>?) $dv";
      } else {
        // object
        getValueExpression =
            "$valueExpress != null ? ${field.type}Mixin.fromMap($valueExpress) $dv : null";
      }

      buffer.writeln("    ${field.name}: $getValueExpression,");
    }
    buffer.writeln('  );}');
  }
}
