// @author luwenjie on 2025/4/19 17:38:43

import 'dart:collection';

import 'package:collection/collection.dart';
import 'package:data_class_annotation/data_class_annotation.dart';

part 'class_test.data.dart';

@DataClass()
class Bean with BeanDataClassMixin {
  @override
  final String name;
  @override
  final List<String> list;
  @override
  final Iterable<String> iterable;
  @override
  final Queue<String> queue;
  @override
  final QueueList<String> queueList;
  @override
  final Set<String> set;
  @override
  final Map<String, String> map;
  @override
  final HashMap<String, String> map2;
  @override
  final LinkedHashMap<String, String> map3;

  Bean(
    this.name,
    this.list,
    this.iterable,
    this.queue,
    this.queueList,
    this.set,
    this.map,
    this.map2,
    this.map3,
  );
}
