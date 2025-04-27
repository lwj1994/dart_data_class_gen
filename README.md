# dart_data_class_gen

The speed of `dart_build_runner` is extremely slow, especially in large-scale projects. Therefore,
this script was developed to enable rapid generation.

## Usage

1. **Dependency Setup**

   First, add `data_class_annotation` to your `pubspec.yaml`:

```yaml
  data_class_annotation:
    git:
      url: https://github.com/lwj1994/dart_data_class_gen
      ref: main
      path: annotation
```

    Then, install the CLI tool:

```shell
dart pub global activate --source git https://github.com/lwj1994/dart_data_class_gen
```

2. **Add Annotations to the Model**

   Incorporate the necessary annotations into your model class as shown below:

```dart
part 'model.data.dart';

@DataClass(fromMap: true)
class Bean with _BeanMixin {
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

3. **Execute the CLI**

   Run the following command in the terminal to generate the required code:

```shell
data_class_gen .
``` 