library mytools.builder;

import 'package:build/build.dart';
import 'package:my_tools/router/annotation.dart';
import 'package:source_gen/source_gen.dart';



Builder myRouterBuilder(BuilderOptions options) =>
    LibraryBuilder(MyRouterGenerator(), generatedExtension:'.g.dart');

Builder myRootRouterBuilder(BuilderOptions options) =>
    LibraryBuilder(MyRootRouterGenerator(), generatedExtension:'.root.dart');