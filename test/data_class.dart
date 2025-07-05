import 'dart:io';

import 'package:data_class_annotation/data_class_annotation.dart';
import 'package:data_class_gen/data_class_gen.dart';
import 'package:data_class_gen/src/model.dart';
import 'package:data_class_gen/src/parser.dart';
import 'package:data_class_gen/src/writer.dart';
import 'package:test/test.dart';

void main() {
  test('test gen', () {
    initialize(
        globalConfig: GlobalConfig(
      includeToMap: true,
      includeFromMap: true,
      fromMapName: "fromJson",
      toMapName: "toJson",
    ));
    generate(".");
  });

  test('test parser', () {
    Directory file = Directory('./test');
    Parser parser = Parser("./test/class_test.dart");

    final res = parser.parseDartFile();
    print(res);
  });

  test('test writer', () {
    Directory file = Directory('./test');
    ParseResult result = ParseResult(
      "./test/gen/test_write.g",
      "part of test.dart",
      [
        //  final String name;
        //   final List<String> list;
        //   final Iterable<String> iterable;
        //   final Queue<String> queue;
        //   final QueueList<String> queueList;
        //   final Set<String> set;
        //   final Map<String, String> map;
        //   final HashMap<String, String> map2;
        //   final LinkedHashMap<String, String> map3;
        ClassInfo(
          name: "Bean",
          fromMapName: "",
          mixinName: "BeanDataClass",
          fields: [
            FieldInfo(name: "name", type: "String"),
            FieldInfo(name: "age", type: "int"),
            FieldInfo(name: "list", type: "List<A>"),
            FieldInfo(name: "list2", type: "XXList<A>"),
            FieldInfo(name: "set", type: "XXSet<A>"),
            FieldInfo(name: "map", type: "Map<B>"),
            FieldInfo(name: "map2", type: "LinkedHashMap<B>"),
            FieldInfo(name: "map3", type: "HashMap<B>"),
            FieldInfo(name: "map4", type: "XXXMap<B>"),
          ],
          fromMap: false,
          toMapName: '',
        ),
      ],
    );
    final Writer writer = Writer(result);
    writer.writeCode();
  });
}
