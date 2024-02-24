// ignore_for_file: non_constant_identifier_names

import 'dart:async';

import 'package:shelf/shelf.dart';
import 'package:shelf_swagger_ui/shelf_swagger_ui.dart';

FutureOr<Response> swaggerHandler(Request request) {
  final path = 'specs/swagger.yaml';
  final handler = SwaggerUI(path, title: 'API Promissoria FBD');
  return handler(request);
}