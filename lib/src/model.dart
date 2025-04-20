class ParseResult {
  final String outputPath;
  final String partOf;
  final List<ClassInfo> classes;

  ParseResult(this.outputPath, this.partOf, this.classes);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ParseResult &&
          runtimeType == other.runtimeType &&
          outputPath == other.outputPath &&
          partOf == other.partOf &&
          classes == other.classes;

  @override
  int get hashCode => outputPath.hashCode ^ partOf.hashCode ^ classes.hashCode;

  @override
  String toString() {
    return 'ParseResult{outputPath: $outputPath, partOf: $partOf, classes: $classes}';
  }
}

class ClassInfo {
  final String name;
  final String mixinName;
  final List<FieldInfo> fields;

  ClassInfo(this.name, this.mixinName, this.fields);

  @override
  String toString() {
    return 'ClassInfo{name: $name, mixinName: $mixinName, fields: $fields}';
  }
}

class FieldInfo {
  final String name;
  final String type;
  final bool isFinal;

  FieldInfo(this.name, this.type, {this.isFinal = true});

  @override
  String toString() {
    return 'FieldInfo{name: $name, type: $type, isFinal: $isFinal}';
  }
}
