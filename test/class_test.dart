// @author luwenjie on 2025/4/19 17:38:43

import 'package:collection/collection.dart';
import 'package:data_class_annotation/data_class_annotation.dart'
    as data_class_annotation;

part 'class_test.data.dart';

@data_class_annotation.DataClass(fromMap: true, fromMapName: "fromJson")
class Bean with BeanMixin {
  @override
  @data_class_annotation.JsonKey(
    name: "name2",
    readValue: Bean.redValue,
    ignore: true,
  )
  final String name;
  @override
  final List<String> list;
  @override
  final List<Bean2> list2;
  @override
  final Map<String, dynamic> map;

  @override
  @data_class_annotation.JsonKey(ignore: true)
  final List<String> Function()? builderFunction;

  @override
  final Bean2? bean2;

  static Object? redValue(Map map, String key) {
    return map[key];
  }

  Bean({
    this.name = "a",
    this.list = const [],
    this.list2 = const [],
    this.map = const {},
    this.bean2,
    this.builderFunction,
  });
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

@data_class_annotation.DataClass(fromMap: false, name: "_Bean3")
class Bean3 with _Bean3 {
  @override
  final String name;

  Bean3({this.name = ""});
}
