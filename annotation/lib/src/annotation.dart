// @author luwenjie on 2025/4/19 17:37:49

class DataClass {
  final String name;
  final bool fromMap;

  const DataClass({
    this.name = "",
    this.fromMap = true,
  });
}

const dataClass = DataClass();

class JsonKey {
  final String name;
  final bool ignore;
  final Object? Function(Map<dynamic, dynamic> map, String key)? readValue;

  const JsonKey({
    this.name = "",
    this.readValue,
    this.ignore = false,
  });
}
