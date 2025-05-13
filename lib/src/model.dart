class ParseResult {
  final String outputPath;
  final String partOf;
  final List<ClassInfo> classes;

  ParseResult(this.outputPath, this.partOf, this.classes);

  @override
  String toString() {
    return 'ParseResult{outputPath: $outputPath, partOf: $partOf, classes: $classes, }';
  }
}

class ClassInfo {
  final String name;
  final String mixinName;
  final String fromMapName;
  final bool fromMap;
  final List<FieldInfo> fields;

  //<editor-fold desc="Data Methods">
  const ClassInfo({
    required this.name,
    required this.mixinName,
    required this.fromMap,
    required this.fromMapName,
    required this.fields,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ClassInfo &&
          runtimeType == other.runtimeType &&
          name == other.name &&
          mixinName == other.mixinName &&
          fromMap == other.fromMap &&
          fromMapName == other.fromMapName &&
          fields == other.fields);

  @override
  int get hashCode =>
      name.hashCode ^
      mixinName.hashCode ^
      fromMap.hashCode ^
      fromMapName.hashCode ^
      fields.hashCode;

  @override
  String toString() {
    return 'ClassInfo{'
        ' name: $name,'
        ' mixinName: $mixinName,'
        ' fromMap: $fromMap,'
        ' fromMapName: $fromMapName,'
        ' fields: $fields,'
        '}';
  }

  ClassInfo copyWith({
    String? name,
    String? mixinName,
    bool? fromMap,
    String? fromMapName,
    List<FieldInfo>? fields,
  }) {
    return ClassInfo(
      name: name ?? this.name,
      fromMapName: fromMapName ?? this.fromMapName,
      mixinName: mixinName ?? this.mixinName,
      fromMap: fromMap ?? this.fromMap,
      fields: fields ?? this.fields,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'mixinName': mixinName,
      'fromMap': fromMap,
      'fromMapName': fromMapName,
      'fields': fields,
    };
  }

  factory ClassInfo.fromMap(Map<String, dynamic> map) {
    return ClassInfo(
      name: map['name'] as String,
      fromMapName: map['fromMapName'] as String,
      mixinName: map['mixinName'] as String,
      fromMap: map['fromMap'] as bool,
      fields: map['fields'] as List<FieldInfo>,
    );
  }

//</editor-fold>
}

class FieldInfo {
  final String defaultValue;
  final String name;
  final String type;
  final bool isFunction;
  final bool isRecord;
  final bool isFinal;
  final JsonKeyInfo? jsonKey;

  //<editor-fold desc="Data Methods">

  const FieldInfo({
    this.defaultValue = "",
    required this.name,
    this.type = "dynamic",
    this.isFinal = true,
    this.isFunction = false,
    this.isRecord = false,
    this.jsonKey,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is FieldInfo &&
          runtimeType == other.runtimeType &&
          defaultValue == other.defaultValue &&
          name == other.name &&
          type == other.type &&
          isFinal == other.isFinal &&
          jsonKey == other.jsonKey);

  @override
  int get hashCode =>
      defaultValue.hashCode ^
      name.hashCode ^
      type.hashCode ^
      isFinal.hashCode ^
      jsonKey.hashCode;

  @override
  String toString() {
    return 'FieldInfo{'
        ' defaultValue: $defaultValue,'
        ' name: $name,'
        ' type: $type,'
        ' isFinal: $isFinal,'
        ' jsonKey: $jsonKey,'
        '}';
  }

  FieldInfo copyWith({
    String? defaultValue,
    String? name,
    String? type,
    bool? isFinal,
    JsonKeyInfo? jsonKey,
  }) {
    return FieldInfo(
      defaultValue: defaultValue ?? this.defaultValue,
      name: name ?? this.name,
      type: type ?? this.type,
      isFinal: isFinal ?? this.isFinal,
      jsonKey: jsonKey ?? this.jsonKey,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'defaultValue': defaultValue,
      'name': name,
      'type': type,
      'isFinal': isFinal,
      'jsonKey': jsonKey,
    };
  }

  factory FieldInfo.fromMap(Map<String, dynamic> map) {
    return FieldInfo(
      defaultValue: map['defaultValue'] as String,
      name: map['name'] as String,
      type: map['type'] as String,
      isFinal: map['isFinal'] as bool,
      jsonKey: map['jsonKey'] as JsonKeyInfo,
    );
  }

//</editor-fold>
}

class JsonKeyInfo {
  final String name;
  final List<String> alternateNames;
  final String readValue;
  final bool ignore;

//<editor-fold desc="Data Methods">
  const JsonKeyInfo({
    required this.name,
    required this.alternateNames,
    required this.readValue,
    required this.ignore,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is JsonKeyInfo &&
          runtimeType == other.runtimeType &&
          name == other.name &&
          alternateNames == other.alternateNames &&
          readValue == other.readValue &&
          ignore == other.ignore);

  @override
  int get hashCode =>
      name.hashCode ^
      alternateNames.hashCode ^
      readValue.hashCode ^
      ignore.hashCode;

  @override
  String toString() {
    return 'JsonKeyInfo{' ' name: $name,' ' alternateNames: $alternateNames,' ' readValue: $readValue,' ' ignore: $ignore,' +
        '}';
  }

  JsonKeyInfo copyWith({
    String? name,
    List<String>? alternateNames,
    String? readValue,
    bool? ignore,
  }) {
    return JsonKeyInfo(
      name: name ?? this.name,
      alternateNames: alternateNames ?? this.alternateNames,
      readValue: readValue ?? this.readValue,
      ignore: ignore ?? this.ignore,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'alternateNames': alternateNames,
      'readValue': readValue,
      'ignore': ignore,
    };
  }

  factory JsonKeyInfo.fromMap(Map<String, dynamic> map) {
    return JsonKeyInfo(
      name: map['name'] as String,
      alternateNames: map['alternateNames'] as List<String>,
      readValue: map['readValue'] as String,
      ignore: map['ignore'] as bool,
    );
  }

//</editor-fold>
}
