// @author luwenjie on 2025/4/19 17:38:43

import 'package:collection/collection.dart';
import 'package:data_class_annotation/data_class_annotation.dart'
    as data_class_annotation;

part 'class_test.data.dart';

@data_class_annotation.DataClass(fromMap: null, fromMapName: "fromJson")
class Bean with _Bean {
  @override
  @data_class_annotation.JsonKey(
    name: "name2",
    alternateNames: [
      "xx",
      "xxx",
      "xxx",
    ],
  )
  final String name;
  @override
  @data_class_annotation.JsonKey(name: "isBool")
  final bool recc;
  @override
  final List<String> list;
  @override
  final List<Bean2> list2;
  @override
  final Map<String, dynamic> map;
  @override
  final List<Map<String, dynamic>> map2;

  @override
  @data_class_annotation.JsonKey(ignore: true)
  final List<String> Function()? builderFunction;

  @override
  final Bean2? bean2;
  @override
  final Bean3? bean3;

  static Object? redValue(
    Map map,
    String key,
  ) {
    return map[key];
  }

  Bean({
    this.name = "a",
    this.list = const [],
    this.list2 = const [],
    this.map2 = const [],
    this.map = const {},
    this.bean2,
    this.bean3,
    this.recc = false,
    this.builderFunction,
  });
}

@data_class_annotation.DataClass()
class Bean3 with _Bean3 {
  @override
  final String name;

  const Bean3({
    this.name = "",
  });

  factory Bean3.fromJson(Map<String, dynamic> map) {
    return _Bean3.fromJson(map);
  }
}

class Bean2 {
  final String name;

  //<editor-fold desc="Data Methods">
  const Bean2({required this.name});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Bean2 &&
          runtimeType == other.runtimeType &&
          name == other.name);

  @override
  int get hashCode => name.hashCode;

  @override
  String toString() {
    return 'Bean2{' ' name: $name,' '}';
  }

  Bean2 copyWith({String? name}) {
    return Bean2(name: name ?? this.name);
  }

  Map<String, dynamic> toMap() {
    return {'name': name};
  }

  factory Bean2.fromJson(Map<String, dynamic> map) {
    return Bean2(name: map['name'] as String);
  }

//</editor-fold>
}
