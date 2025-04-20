import 'dart:io';

import 'package:data_class/data_class.dart';
import 'package:data_class/src/model.dart';
import 'package:data_class/src/parser.dart';
import 'package:data_class/src/writer.dart';
import 'package:test/test.dart';

void main() {
  test('test gen', () {
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
        ClassInfo("Bean", "BeanDataClass", [
          FieldInfo("name", "String"),
          FieldInfo("age", "int"),
          FieldInfo("list", "List<A>"),
          FieldInfo("list2", "XXList<A>"),
          FieldInfo("set", "XXSet<A>"),
          FieldInfo("map", "Map<B>"),
          FieldInfo("map2", "LinkedHashMap<B>"),
          FieldInfo("map3", "HashMap<B>"),
          FieldInfo("map4", "XXXMap<B>"),
        ]),
      ],
    );
    final Writer writer = Writer(result);
    writer.writeCode();
  });
}
