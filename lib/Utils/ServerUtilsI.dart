
import 'dart:convert';
import 'dart:io';

import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

abstract interface class ServerUtils{
  Router get router;
}

abstract class ResponseUtils{
 static Response getResponse(List<Map<String, dynamic>> listMap) {
    try{
      return Response.ok(jsonEncode(listMap),
      headers: {'Content-Type': ContentType('application', 'json', charset: 'utf-8').toString()
      });
    }catch(e){
      return Response.internalServerError(
          body: "Erro ao tentar realizar a busca, $e");
    }
  }

 static Map<String,dynamic> dadosReqMap(String strReq) => jsonDecode(strReq);
}