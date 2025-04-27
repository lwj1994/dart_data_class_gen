# dart_data_class_gen

因为 dart_build_runner 的速度实在太慢了，尤其在大型项目。所以写了这个脚本来快速生成。


## Usage

1. dependency:

Add data_class_annotation to your `pubspec.yaml`:
```yaml
  data_class_annotation:
    git:
      url: https://github.com/lwj1994/dart_data_class_gen
      ref: main
      path: annotation
```


Add cli
```shell
dart pub global activate --source git https://github.com/lwj1994/dart_data_class_gen
```

2. Add Annotation to model
```dart
@DataClass(fromMap: true)
class Bean with BeanDataClassMixin {
  @override
  @JsonKey(name: "name", readValue: Bean.redValue)
  final String name;

  static Object? redValue(Map map, String key) {
    return map[key];
  }

  Bean({
    this.name = "a",
  });
}
```

3. Run the cli
```shell

```
