import 'dart:io';

import 'package:data_class_gen/data_class_gen.dart';
import 'package:data_class_gen/parser.dart';
import 'package:test/test.dart';

void main() {
  test('test parser', () {
    Directory file = Directory('./test');
    Parser parser = Parser(dirPath: file.absolute.path);

    parser.parseClasses();


  });

}




