import 'dart:io';

import 'package:analyzer/dart/element/element.dart';
import 'package:build/src/builder/build_step.dart';
import 'package:get_route_generator/src/annotations.dart';
import 'package:get_route_generator/src/config.dart';
import 'package:path/path.dart' as p;
import 'package:source_gen/source_gen.dart';

class GetRouteGenerator extends GeneratorForAnnotation<GetGeneratePage> {
  @override
  Future<String> generateForAnnotatedElement(
      Element element, ConstantReader annotation, BuildStep buildStep) async {
    final String resultStr = getMainContent(element);
    writeContent(resultStr);
    return resultStr;
  }

  void writeContent(String resultStr) {
    final absoluteOutput = Directory(GetGeneratorConfig.parentPath);
    if (!absoluteOutput.existsSync()) {
      absoluteOutput.createSync(recursive: true);
    }

    /// Write string content to file.
    final file = File(GetGeneratorConfig.routerPath);
    if (!file.existsSync()) {
      file.createSync(recursive: true);
      file.writeAsStringSync(resultStr);
    } else {
      file.writeAsStringSync(
          mergeDartFiles([resultStr, file.readAsStringSync()]));
    }

    stdout.writeln('Generated: ${GetGeneratorConfig.routerPath}');
  }

  String mergeDartFiles(List<String> files) {
    Set<String> imports = {};
    Set<String> routerNames = {};
    List<String> pages = [];

    for (String file in files) {
      // Split the file into lines
      List<String> lines = file.split('\n');

      for (String line in lines) {
        // If the line is an import statement, add it to the imports set
        if (line.startsWith('import ')) {
          imports.add(line);
        }
        // If the line is a route name, add it to the routerNames set
        else if (line.startsWith('  static const String')) {
          routerNames.add(line);
        }
        // If the line is a GetPage instance, add it to the pages list
        else if (line.startsWith('    GetPage(')) {
          pages.add(line);
          stdout.writeln('mergeDartFiles::Generated: $line');
        }
      }
    }

    // Concatenate the imports, routerNames, and pages to create the merged file
    String mergedFile =
        '${imports.join('\n')}\n\nclass AppRouterName {\n${routerNames.join('\n')}\n}\n\nclass AppRouter {\n  static List<GetPage> pages = [\n${pages.join('\n')}\n  ];\n}';
    mergedFile.replaceAll(",,", "");

    return mergedFile;
  }

  String getMainContent(Element element) {
    final String className = element.name.toString();
    stdout.writeln("[GetRouteGenerator] Current handle the class: $className");
    final String routeName = getRouteName(element);
    final String importPath = getImportPath(element);

    // Create the route constant
    String routeConstant = 'static const String $routeName = \'/$routeName\';';

    String bindingClassName = '${className.replaceAll("Page", "")}Binding';
    // Create the GetPage instance
    String getPageInstance =
        'GetPage(name: AppRouterName.$routeName, page: () => const $className(), binding: $bindingClassName()),';

    String import = "import 'package:get/get.dart';\n"
        "$importPath \n";

    // Return the generated code
    return '$import class AppRouterName {\n  $routeConstant\n}\n\n' +
        'class AppRouter {\n  static List<GetPage> pages = [\n    $getPageInstance\n  ];\n}';
  }

  String getRouteName(Element element) {
    // Get the class name
    String className = element.name.toString();

    // Create the route name
    return className[0].toLowerCase() + className.substring(1);
  }

  String getImportPath(Element element) {
    // Get the file path
    // import 'package:pair_up/pages/login/login_view.dart';
    String filePath = element.source!.fullName.toString();

// Split the file path into parts
    List<String> partsForPackage = filePath.split('/');

// Get the package name
    String packageName = partsForPackage[1];

// Remove the leading '/' if present
    if (filePath.startsWith('/')) {
      filePath = filePath.substring(1);
    }

// Split the file path into parts
    List<String> parts = p.split(filePath);

// Find the index of 'lib'
    int libIndex = parts.indexOf('lib');

    String importPath = "";
// If 'lib' is found, create the package import path
    if (libIndex != -1) {
      importPath = "import 'package:${p.joinAll([
            packageName
          ] + parts.sublist(libIndex + 1)).replaceAll('\\', '/')}';\n";
      importPath += importPath.replaceAll("_view.dart';", "_binding.dart';\n");
    }
    return importPath;
  }
}
