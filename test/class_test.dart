// @author luwenjie on 2025/4/19 17:38:43

import 'package:collection/collection.dart';
import 'package:data_class_annotation/data_class_annotation.dart';

part 'class_test.data.dart';

@dataClass
class Bean with BeanDataClassMixin {
  @override
  @JsonKey(name: "name2", readValue: Bean.redValue)
  final String name;
  @override
  final List<String> list;
  @override
  final List<Bean2> list2;
  @override
  final Map<String, dynamic> map;

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

  factory Bean2.fromMap(Map<String, dynamic> map) {
    return Bean2(name: map['name'] as String);
  }

  //</editor-fold>
}
