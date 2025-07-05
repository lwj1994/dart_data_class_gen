// @author luwenjie on 20/04/2025 15:41:25

import 'package:data_class_annotation/data_class_annotation.dart';
import 'package:data_class_annotation/src/config_data.dart' as config_data;

export 'src/annotation.dart';
export 'src/config.dart';

void initialize({required GlobalConfig globalConfig}) {
  config_data.config = globalConfig;
}
