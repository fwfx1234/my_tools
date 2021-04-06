import 'dart:async';

import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';


class MyRouterGenerator extends GeneratorForAnnotation<MyRoute> {

  @override
  dynamic generateForAnnotatedElement(Element element,
      ConstantReader annotation, BuildStep buildStep) {
    String className = element.displayName;
    String name = annotation
        .peek('path')
        ?.stringValue;
    var routers = MyRootRouterGenerator.routers;
    routers[name] = element;
    return null;
  }

}

class MyRootRouterGenerator extends GeneratorForAnnotation<MyRouteRoot> {
  static Map<String, Element> routers = {};

  String genImports() {
    return routers.values.map((e) => "import \'${e.location.components[0]}\'").join(';\n') + ';';
  }

  String genBody() {
    String body = "final Map<String, WidgetBuilder> routes = <String, WidgetBuilder>{\n"
        "${routers.keys.map((e) {
      return "\'$e\': (context) => ${routers[e].displayName}()";
    }).join(',\n')}"
    "\n};";
    return body;
  }

  @override
  generateForAnnotatedElement(Element element, ConstantReader annotation,
      BuildStep buildStep) {
    var code =
        "import 'package:flutter/material.dart';\n"
        "${genImports()}"
        "\n"
        "\n"
        "${genBody()}"
        "\n";
    return code;
  }

}


class MyRoute {
  final String path;

  const MyRoute(this.path);
}

class MyRouteRoot {
  const MyRouteRoot();
}