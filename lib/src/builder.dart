// lib/src/builder.dart
import 'dart:io';

import 'package:build/build.dart';
import 'package:get_route_generator/src/config.dart';
import 'package:get_route_generator/src/impl.dart';
import 'package:source_gen/source_gen.dart';

Builder getRouteGenerator(BuilderOptions options) {
  stdout.writeln('Generated: getRouteGenerator start...');

  /// Remove the already generated file.
  final file = File(GetGeneratorConfig.routerPath);
  if (file.existsSync()) {
    file.delete();
    sleep(const Duration(milliseconds: 500));
  }

  return SharedPartBuilder([GetRouteGenerator()], 'get_route_generator');
}
